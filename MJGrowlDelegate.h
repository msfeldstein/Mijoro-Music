//
//  GrowlDelegate.h
//  MijorTunes
//
//  Created by Michael Feldstein on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl-WithInstaller/Growl.h> 
#import "MusicControllerProtocol.h"
@interface MJGrowlDelegate : NSObject <GrowlApplicationBridgeDelegate>  {
  BOOL showNotifications;
  NSObject<MusicControllerProtocol>* musicController;
}
@property (retain) NSObject<MusicControllerProtocol>* musicController;

-(void)updateSong:(NSString *)songName byArtist:(NSString*)artistName withArtwork:(NSData*)artwork;
@end
