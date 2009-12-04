//
//  MJSongTrack.h
//  MijorTunes
//
//  Created by Michael Feldstein on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MJSongTrack : NSObject {
	NSString * artistName;
	NSString * songName;
}
@property (retain) NSString* artistName; 
@property (retain) NSString* songName;
@end
