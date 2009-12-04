//
//  GrowlDelegate.m
//  MijorTunes
//
//  Created by Michael Feldstein on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MJGrowlDelegate.h"
#import <Growl-WithInstaller/Growl.h>

@implementation MJGrowlDelegate
@synthesize musicController;

- (id)init
{
	self = [super init];
	[GrowlApplicationBridge setGrowlDelegate:self];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(notificationChanged:)
                                               name:NSUserDefaultsDidChangeNotification 
                                             object:nil];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  showNotifications = [defaults boolForKey:@"showNotifications"];
	return self;
}

- (void) growlNotificationWasClicked:(id)clickContext{
	if([clickContext isEqual:@"launch"]){
    [musicController showApp];
  }
}

-(void)updateSong:(NSString *)songName byArtist:(NSString*)artistName withArtwork:(NSData*)artwork
{
   
  if (showNotifications) {
    [GrowlApplicationBridge
    notifyWithTitle:artistName
    description:songName
    notificationName:@"MijorTunesUpdate"
    iconData: artwork
    priority:1
    isSticky:NO
    clickContext:@"launch"
    identifier:@"MijorSongNotification"];	
  }
}

- (NSDictionary *) registrationDictionaryForGrowl
{
	NSArray *notifications = [NSArray arrayWithObject: @"MijorTunesUpdate"];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  notifications, GROWL_NOTIFICATIONS_ALL,
						  notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
	
	return dict;
}

- (void) notificationChanged:(NSNotification *)notification {
  NSUserDefaults * defaults = (NSUserDefaults*)[notification object];
  showNotifications = [defaults boolForKey:@"showNotifications"];
}
@end
