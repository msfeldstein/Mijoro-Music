//
//  SimpleHTTPServer.m
//  MijoroMusic
//
//  Created by Michael Feldstein on 4/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleHTTPServer.h"
#import "MJDataUtility.h"
#import "sys/types.h"
#import "sys/socket.h"
#import "sys/socketvar.h"
#import "netinet/in.h"
#import "JSON.h"

@implementation SimpleHTTPServer
- (id)initWithPortNumber:(int)pn delegate:(NSObject<ServerDelegate> *)dl
{
	if( self = [super init] ) {

		
		
		portNumber = pn;
		delegate = [dl retain];
		
		connections = [[NSMutableArray alloc] init];
		requests = [[NSMutableArray alloc] init];
		
		int fd = -1;
		CFSocketRef socket;
		socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM,
								IPPROTO_TCP, 0, NULL, NULL);
		if( socket ) {
			fd = CFSocketGetNative(socket);
			int yes = 1;
			setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
			
			struct sockaddr_in addr;
			memset(&addr, 0, sizeof(addr));
			addr.sin_len = sizeof(addr);
			addr.sin_family = AF_INET;
			addr.sin_port = htons(pn);
			addr.sin_addr.s_addr = htonl(0);
			NSData *address = [NSData dataWithBytes:&addr length:sizeof(addr)];
			if( CFSocketSetAddress(socket, (CFDataRef)address) !=
			   kCFSocketSuccess ) {
				NSLog(@"Could not bind to address");
			}
		} else {
			NSLog(@"No server socket");
		}

		fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:fd
												   closeOnDealloc:YES];
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(newConnection:)
				   name:NSFileHandleConnectionAcceptedNotification
				 object:nil];
		
		[fileHandle acceptConnectionInBackgroundAndNotify];
	}
	return self;
}

- (void)pushPlayerInfo:(NSDictionary *)state {
  SBJSON * json = [[SBJSON alloc]init];
	NSError *err;
  NSString * ok = [json stringWithObject:state error:&err];
  if(remoteFileHandle){

    NSString * script = [NSString stringWithFormat:@"<script>console.log(%@)</script>", ok];
    NSLog(@"PUSHING %@", script);
    [remoteFileHandle writeData:[script dataUsingEncoding:NSASCIIStringEncoding]];
  }
}

- (void)newConnection:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSFileHandle *remoteFileHandle = [userInfo objectForKey:
									  NSFileHandleNotificationFileHandleItem];
	
	NSNumber *errorNo = [userInfo objectForKey:@"NSFileHandleError"];
	if( errorNo ) {
		NSLog(@"NSFileHandle Error: %@", errorNo);
		return;
	}
	
	[fileHandle acceptConnectionInBackgroundAndNotify];
	
	if( remoteFileHandle ) {
		SimpleHTTPConnection *connection;
		connection = [[SimpleHTTPConnection alloc] initWithFileHandle:
					  remoteFileHandle
															 delegate:self];
		if( connection ) {
			NSIndexSet *insertedIndexes;
			insertedIndexes = [NSIndexSet indexSetWithIndex:
							   [connections count]];
			[self willChange:NSKeyValueChangeInsertion
             valuesAtIndexes:insertedIndexes forKey:@"connections"];
			[connections addObject:connection];
			[self didChange:NSKeyValueChangeInsertion
			valuesAtIndexes:insertedIndexes forKey:@"connections"];
			[connection release];
		}
	}
}

-(void) newRequestWithURL:(NSURL *)url connection:(SimpleHTTPConnection*)conn{
	NSString * module = [[url path] substringFromIndex:1];

	NSString * query = [url query];
	int code = 200;
	NSDictionary * parameters = [MJDataUtility getDictionaryFromURLString:query];
	NSLog(@"parameters is %@", parameters);
	NSDictionary * response = [delegate sendServerAction:parameters];

	CFHTTPMessageRef msg;
	msg = CFHTTPMessageCreateResponse(kCFAllocatorDefault,
									  code,  // status code
									  NULL,  // use standard reason phrase
									  kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(msg,
									 CFSTR("Content-Type"),
									 CFSTR("text/xml"));
	SBJSON * json = [[SBJSON alloc]init];
	NSError *err;
	NSString * ok = [json stringWithObject:response error:&err];
  NSString * script = [NSString stringWithFormat:@"<script>console.log(%@)</script>", ok];
	@try {
    if(remoteFileHandle){
      [remoteFileHandle closeFile];
    }
    remoteFileHandle = [conn fileHandle];
		[remoteFileHandle writeData:[script dataUsingEncoding:NSASCIIStringEncoding]];
		//[remoteFileHandle closeFile];
	}
	@catch (NSException *exception) {
		NSLog(@"Error while transmitting data");
	}
}


			
- (void)replyWithStatusCode:(int)code
		headers:(NSDictionary *)headers
		body:(NSData *)body{
					
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [requests release];
    [connections release];
    [fileHandle release];
    [socketPort release];
    [delegate release];
    [super dealloc];
}
@end
