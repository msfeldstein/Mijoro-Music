//
//  MJITunesController.m
//  MijorTunes
//
//  Created by Michael Feldstein on 2/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MJITunesController.h"


@implementation MJITunesController

- (id)init {
  self = [super init];
 	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(iTunesEventReceived:)
	 name:@"com.apple.iTunes.playerInfo"
	 object:nil];
  return self;
}

- (void) setDelegate:(id)del {
  delegate = del;
}

- (void) iTunesEventReceived:(NSNotification *)iTunesEvent {
 	NSDictionary * userInfo = [iTunesEvent userInfo];
	NSString* currentArtist = [userInfo objectForKey:@"Artist"];
	NSString* currentSong = [userInfo objectForKey:@"Name"];
	NSString * playerState = [userInfo objectForKey:@"Player State"];
	
	Boolean isPlaying = [playerState isEqualToString:@"Playing"];
  NSData * albumInfo = [self getScriptData:@"set b to artwork 1 of current track \n return get data of b"];
  [delegate setPlayerState:isPlaying withSong:currentSong artist:currentArtist artwork:albumInfo];
}

- (NSString *) appName {
 return @"iTunes"; 
}
- (void) showApp {
	NSLog(@"Launchign itunes");
	[[NSWorkspace sharedWorkspace] launchApplication:@"iTunes"];
	
}

- (void) nextTrack {
	NSString * source = @"tell application \"iTunes\" \n next track \n end tell";
	[self sendScriptEvent:source];
}

- (void) previousTrack{
	NSString * source =@"tell application \"iTunes\" \n back track \n end tell";
	[self sendScriptEvent:source];
} 

- (void) playPause {
	NSString * source = @"tell application \"iTunes\" \n playpause \n end tell";
	[self sendScriptEvent:source];
}

- (BOOL) currentState {
  NSString * state = [self sendScriptEvent:@"return player state"];
  return ![state isEqualToString:@"kPSP"];
}

- (NSArray *) search:(NSString *)query{
	NSString * searchQuery = [NSString stringWithFormat:@"tell application \"iTunes\"\n							  set returnval to {}\n							  set listOfTracks to (get every file track of playlist \"Library\" whose name contains \"%@\" or artist contains \"%@\")\n							  repeat with t in listOfTracks\n							  set songObj to {sntl:\"\", arnm:\"\"}\n							  set sntl of songObj to (get name of t)\n							  set arnm of songObj to (get artist of t)\n							  copy songObj to end of returnval\n							  end repeat\n							  return returnval\n							  end tell", query, query];

	NSMutableArray * array = [[[NSMutableArray alloc] init] autorelease];
	NSAppleScript * script = [[NSAppleScript alloc] initWithSource:searchQuery];
	if (script) {
			NSDictionary* error;
		NSAppleEventDescriptor *result = [script executeAndReturnError:&error];
		if (result)  {
			if ([result descriptorType]!=typeAEList) {
				NSException * myException = [NSException exceptionWithName:@"NoArrayException" reason:@"Returned Apple Event Descriptor is not an Array" userInfo:nil];
				[myException raise];
			};
			int index;
			int total = [result numberOfItems];
			if(total > 10) total = 10;
			NSString * artistName;
			NSString * songName;

			for(index = 1; index <= total; index++) {
				NSAppleEventDescriptor * track = [[result descriptorAtIndex:index] descriptorForKeyword:'usrf'];
				
				MJSongTrack * obj = [[MJSongTrack alloc]init];
				artistName = [[track descriptorAtIndex:4]stringValue];

				songName = [[track descriptorAtIndex:2]stringValue];
				[obj  setArtistName:artistName];
				[obj setSongName:songName];

				[array addObject:obj];
			}
			return array;
		}
	} 
	return false;
	
}
@end

@implementation MJITunesController (Private)
- (NSData *) getScriptData:(NSString *) action
{
	NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
	NSString * source = [NSString stringWithFormat:@"tell application \"iTunes\"\n %@\n end tell	\n", action];
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource: source];
	
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
	
	
	[scriptObject release];
	return [returnDescriptor data];
	
}

- (NSString *)sendScriptEvent:(NSString *)action
{
	
	NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
	NSLog(@"Sending AScript %@", action);
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource: action];
	
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
	
	[scriptObject release];
	return [returnDescriptor stringValue];
}

@end
