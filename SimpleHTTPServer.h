//
//  SimpleHTTPServer.h
//  MijoroMusic
//
//  Created by Michael Feldstein on 4/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "ServerDelegate.h"

#import "SimpleHTTPConnection.h"
@interface SimpleHTTPServer : NSObject {
	int portNumber;
	id <ServerDelegate>  delegate;
	
	NSSocketPort *socketPort;
	NSFileHandle *fileHandle;
	
	NSMutableArray *connections;
	NSMutableArray *requests;    
  NSFileHandle * remoteFileHandle;
}
- (void)pushPlayerInfo:(NSDictionary *)state;
- (id)initWithPortNumber:(int)pn delegate:(NSObject <ServerDelegate>*)dl;
@end