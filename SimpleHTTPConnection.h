//
//  SimpleHTTPConnection.h
//  MijoroMusic
//
//  Created by Michael Feldstein on 4/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SimpleHTTPConnection : NSObject {
    NSFileHandle *fileHandle;
    id delegate;
	
    CFHTTPMessageRef message;
    BOOL isMessageComplete;
}
- (id)initWithFileHandle:(NSFileHandle *)fh delegate:(id)dl;
- (NSFileHandle *)fileHandle;
@end
