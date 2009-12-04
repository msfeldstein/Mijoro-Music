//
//  StatusbarController.h
//  MijorTunes
//
//  Created by Michael Feldstein on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MJGrowlDelegate.h"
#import "LoginItemLoader.h"
#import "MJITunesController.h"
#import "MusicControllerProtocol.h"
#import "AppleRemote.h"
#import "SimpleHTTPServer.h"

@interface StatusbarController : NSObject<MusicControllerDelegate, ServerDelegate> {
	NSAppleScript * script;
	NSStatusItem * playPauseItem;
	NSStatusItem * prevItem;
	NSStatusItem * nextItem;
	NSButton * playPauseButton;
	NSButton * nextButton;
	NSButton * prevButton;
  NSMenuItem * showAppItem;
  
	MJGrowlDelegate * growlDelegate;
	NSObject<MusicControllerProtocol> * musicAppController;
	NSImage * playImage;
	NSImage * pauseImage;
	NSString * currentSong;
	NSString * currentArtist;
	NSString * currentToolTip;
	
	NSMenu * appMenu;
	
	Boolean appIsOpen;
  
  NSArray * plugins;
  NSString * currentPluginName;
  NSMutableArray * pluginMenuItems;
  
  AppleRemote * remoteControl;
  
  SimpleHTTPServer * server;
}
- (void) activateStatusMenu;
- (void) checkForPlayingState;
- (void) setPlayerState:(Boolean)state;

- (NSDictionary *) prevSong;
- (NSDictionary *) nextSong;
- (NSDictionary *) pauseSong;
- (void) setPlugin:(Class)plugin;
- (void) setupRemote:(BOOL)enabled;
- (void) setupServer:(BOOL)enabled;
@end

@interface StatusbarController (MyPrivateMethods) 
- (void) switchToOpenedMode;
- (void) checkAppState;
-(NSDictionary *)getPlayerStateDictionary;
@end
