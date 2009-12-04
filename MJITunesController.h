//
//  MJITunesController.h
//  MijorTunes
//
//  Created by Michael Feldstein on 2/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MJSongTrack.h"
#import "MusicControllerProtocol.h"
@interface MJITunesController : NSObject <MusicControllerProtocol>{
  id<MusicControllerDelegate> delegate;
}
- (NSArray *) search:(NSString *)query;
@end

@interface MJITunesController (Private)
- (NSString *)sendScriptEvent:(NSString *)action;
- (NSData *) getScriptData:(NSString *) action;
@end

