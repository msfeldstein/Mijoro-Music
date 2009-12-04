//
//  SimpleHTTPConnection.m
//  MijoroMusic
//
//  Created by Michael Feldstein on 4/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleHTTPConnection.h"


@implementation SimpleHTTPConnection
- (id)initWithFileHandle:(NSFileHandle *)fh delegate:(id)dl
{
	if( self = [super init] ) {
		fileHandle = [fh retain];
		delegate = [dl retain];
		message = NULL;
		isMessageComplete = YES;
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(dataReceivedNotification:)
				   name:NSFileHandleReadCompletionNotification
				 object:fileHandle];
		[fileHandle readInBackgroundAndNotify];
		NSLog(@"The delegate is %@", dl);
	}
	return self;
}

- (void)dataReceivedNotification:(NSNotification *)notification
{
	NSData *data = [[notification userInfo] objectForKey:
					NSFileHandleNotificationDataItem];
    
	if ( [data length] == 0 ) {
		// NSFileHandle's way of telling us
		// that the client closed the connection
		[delegate closeConnection:self];
	} else {
		[fileHandle readInBackgroundAndNotify];
        
		if( isMessageComplete ) {
            message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE);
		}
		Boolean success = CFHTTPMessageAppendBytes(message, [data bytes],
												   [data length]);
		if( success ) {
			if( CFHTTPMessageIsHeaderComplete(message) ) {
				isMessageComplete = YES;
				CFURLRef url = CFHTTPMessageCopyRequestURL(message);
				[delegate newRequestWithURL:(NSURL *)url connection:self];
				CFRelease(url);
				CFRelease(message);
				message = NULL;
			} else {
				isMessageComplete = NO;
			}
		} else {
			NSLog(@"Incomming message not a HTTP header, ignored.");
			[delegate closeConnection:self];
		}
	}
}

-(NSFileHandle *) fileHandle {
	return fileHandle;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if( message ) CFRelease(message);
    [delegate release];
    [fileHandle release];
    [super dealloc];
}
@end
