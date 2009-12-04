//
//  StatusbarController.m
//  MijorTunes
//
//  Created by Michael Feldstein on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StatusbarController.h"
#import "PreferencesController.h"
#import "PluginLoader.h" 

int port = 6456;

@implementation StatusbarController
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	growlDelegate = [[MJGrowlDelegate alloc] init];
  plugins = [PluginLoader pluginClasses];
	[self setPlugin:[plugins objectAtIndex:0]];
  [growlDelegate setMusicController:musicAppController];
  [musicAppController setDelegate:self];
  remoteControl = [[AppleRemote alloc] initWithDelegate: self];
  
 
  
  [self activateStatusMenu];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(defaultsChanged:)
                                               name:NSUserDefaultsDidChangeNotification 
                                             object:nil];
  [self setupRemote:[[NSUserDefaults standardUserDefaults] boolForKey:@"useRemoteControl"]];
  [self setupServer:[[NSUserDefaults standardUserDefaults] boolForKey:@"useServer"]];
}

- (void) setupRemote:(BOOL)enabled {
  if(enabled){
    [remoteControl startListening: self]; 
  } else {
    [remoteControl stopListening:self];
  }
}

- (void) setupServer:(BOOL)enabled {
  if(enabled){
    NSLog(@"setting up server");
     server = [[SimpleHTTPServer alloc]initWithPortNumber:port delegate:self];
  } else {
    if(server) server = nil;
  }
}

- (void) defaultsChanged:(NSNotification *) notification {
  NSUserDefaults *defaults = (NSUserDefaults *)[notification object];
  [self setupRemote:[defaults boolForKey:@"useRemoteControl"]];
  [self setupServer:[defaults boolForKey:@"useServer"]];
  NSLog(@"Phone number %@", [defaults stringForKey:@"phoneNumber"]);
}

- (void) setPlugin:(Class)plugin{
  if(![plugin conformsToProtocol:@protocol(MusicControllerProtocol)]) {
    return;
  }
  currentPluginName = [plugin appName];
  musicAppController = [[plugin alloc] init];
  [musicAppController setDelegate:self];
  [showAppItem setTitle:[NSString stringWithFormat:@"Show %@", currentPluginName]];
}

- (void)activateStatusMenu{
	NSBundle* bundle = [NSBundle mainBundle];
  
	NSString * imagePath = nil;
  imagePath = [bundle pathForResource:@"playImage" ofType:@"png"];
	playImage = [[NSImage alloc] initByReferencingFile:imagePath];
	imagePath = [bundle pathForResource:@"pauseImage" ofType:@"png"];
	pauseImage = [[NSImage alloc] initByReferencingFile:imagePath];
    
	appMenu = [[NSMenu alloc]init];
  
	NSString * showAppTitle = [NSString stringWithFormat:@"Show %@", [musicAppController appName]];
	showAppItem = [[NSMenuItem alloc]initWithTitle:showAppTitle action:@selector(showApp) keyEquivalent:@"s"];
	[appMenu addItem:showAppItem];
  
  [appMenu addItem:[NSMenuItem separatorItem]];
  pluginMenuItems = [[NSMutableArray alloc]init];
  for (int i = 0; i < [plugins count]; i++) {
    Class plugin = [plugins objectAtIndex:i];
    NSMenuItem* item = [appMenu addItemWithTitle:[plugin appName] action:@selector(switchProvider:) keyEquivalent:@""];
    if([[plugin appName] isEqualToString:currentPluginName]){
      [item setState:NSOnState];
    }
    [pluginMenuItems addObject:item];
  }
  [appMenu addItem:[NSMenuItem separatorItem]];
  
  
  NSMenuItem * preferences = [[NSMenuItem alloc]initWithTitle:@"Preferences..." action:@selector(preferences) keyEquivalent:@""];
  [appMenu addItem:preferences];
  
	NSMenuItem * quit = [[NSMenuItem alloc] initWithTitle:@"Quit Mijoro Music" action:@selector(quitApp) keyEquivalent:@"q"];
	[appMenu addItem:quit];
	
	NSStatusBar *bar = [NSStatusBar systemStatusBar];

  nextItem = [bar statusItemWithLength:25];	
  [nextItem retain];
	[nextItem setHighlightMode:YES];
	[nextItem setTarget:self];
	imagePath = [bundle pathForResource:@"nextImage"	ofType:@"png"];
	nextButton = [[NSButton alloc]init];
	[nextButton setImage:[[NSImage alloc] initByReferencingFile:imagePath]];
	[nextButton setMenu:appMenu];
	[nextButton setAction:@selector(nextSong)];
	[nextButton setBordered:NO];
	[nextItem setView:nextButton];
	
	playPauseItem = [bar statusItemWithLength:15];	
  [playPauseItem retain];
	[playPauseItem setHighlightMode:YES];
	[playPauseItem setTarget:self];
	[playPauseItem setAction:@selector(pauseSong)];
  
  playPauseButton = [[NSButton alloc]init];
	[playPauseButton setImage:playImage];
	[playPauseButton setAction:@selector(pauseSong)];
	[playPauseButton setMenu:appMenu];
	[playPauseButton setBordered:NO];
	[playPauseItem setView:playPauseButton];

	prevItem = [bar statusItemWithLength:25];	
  [prevItem retain];

	[prevItem setTarget:self];
	[prevItem setAction:@selector(prevSong)];	
	imagePath = [bundle pathForResource:@"prevImage"	ofType:@"png"];
	prevButton = [[NSButton alloc]init];
	[prevButton setImage:[[NSImage alloc] initByReferencingFile:imagePath]];
	[prevButton setMenu:appMenu];
	[prevButton setAction:@selector(prevSong)];	
	[prevButton setBordered:NO];
	[prevItem setView:prevButton];
  
  [self checkForPlayingState];
}

- (void)switchProvider:(id)sender{
  for (int i = 0; i < [plugins count]; i++) {
    Class plugin = [plugins objectAtIndex:i];
    NSMenuItem* item = [pluginMenuItems objectAtIndex:i];
    if([[plugin appName] isEqualToString:[sender title]]){
      [item setState:NSOnState];
      [self setPlugin:plugin];
    } else {
      [item setState:NSOffState]; 
    }
  }
}

- (void) setPlayerState:(BOOL)playing withSong:(NSString*)song artist:(NSString*)artist artwork:(NSData*)artwork {
  currentSong = song;
  currentArtist = artist;
  currentToolTip = [NSString stringWithFormat:@"%@ - %@", currentSong, currentArtist];
  
  [playPauseButton setImage:(playing? pauseImage : playImage)];
  [playPauseButton setToolTip:currentToolTip];
	[nextButton setToolTip:currentToolTip];
	[prevButton setToolTip:currentToolTip];
  
  if(playing) {
    [growlDelegate updateSong:song byArtist:artist withArtwork:artwork]; 
  }
  
  if(server) {
    NSLog(@"Pushign info");
    [server pushPlayerInfo:[self getPlayerStateDictionary]];
  }
}

- (void) switchToClosedMode {
	appIsOpen = NO;
	[nextButton setHidden:YES];
	[prevButton setHidden:YES];
}

-(void) switchToOpenedMode {
	appIsOpen = YES;
	[nextButton setHidden:NO];
	[prevButton setHidden:NO];		
}

-(void) setPlayerState:(Boolean)state {
	if(state){
		[playPauseButton setImage:pauseImage];
	} else {
		[playPauseButton setImage:playImage];
	}
}

- (void) checkForPlayingState{
  BOOL state = [musicAppController currentState];
	[self setPlayerState:state];
}

- (void) quitApp{
	[NSApp terminate:self];
}

- (void) showApp {
	[musicAppController showApp];
}

- (NSDictionary *) nextSong {
	return [musicAppController nextTrack];
}

- (NSDictionary *) prevSong{
	return [musicAppController previousTrack];
}

- (NSDictionary *) pauseSong{
	return [musicAppController playPause];
}

- (void) preferences {
  PreferencesController* prefsController = [[PreferencesController alloc ]init];
  [prefsController retain];
  [[NSApplication sharedApplication] activateIgnoringOtherApps: YES];
  [NSBundle loadNibNamed:@"Preferences" owner:prefsController];
  [[prefsController window] center];
}

- (void) sendRemoteButtonEvent: (RemoteControlEventIdentifier) event 
                   pressedDown: (BOOL) pressedDown 
                 remoteControl: (RemoteControl*) remoteControl {
  if(pressedDown) {
    return;
  }
  switch (event) {
    case kRemoteButtonLeft:
      [self prevSong];
      break;
    case kRemoteButtonRight:
      [self nextSong];
      break;
    case kRemoteButtonPlay:
      [self pauseSong];
      break;
  }
}

- (NSDictionary *)sendServerAction:(NSDictionary *)params{
	NSString * action = [params objectForKey:@"action"];
	NSLog(@"The aciton is %@", params);
	if(action != nil){
		if([action isEqualToString:@"getStatus"]){
			return [musicAppController playerState];
		} else if([action isEqualToString:@"nextSong"]){
			return [self nextSong];
		} else if([action isEqualToString:@"previousSong"]){
      return [self prevSong];
//		} else if([action isEqualToString:@"setVolume"]){
//		 	return [controller setVolume:[params objectForKey:@"volume"]];
//		} else if([action isEqualToString:@"search"]){
//			return [controller search:[params objectForKey:@"query"]];
		} else if([action isEqualToString:@"playPause"]){
			return [self pauseSong];
      //		} else if([action isEqualToString:@"upvote"]){
//			return [controller upvote];
//		} else if([action isEqualToString:@"downvote"]){
//			return [controller downvote];
//		} else if([action isEqualToString:@"playSong"]){
//			return [controller playSong:[params objectForKey:@"trackId"]];
		}
	}
	return nil;
}

-(NSDictionary *)getPlayerStateDictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys: 
          currentSong, @"currentSong",
          currentArtist, @"currentArtist",
          nil];
}
@end
