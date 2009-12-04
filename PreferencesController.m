//
//  PreferencesController.m
//  MijoroMusic
//
//  Created by Michael Feldstein on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"
#import "LoginItemLoader.h"
#import "PluginLoader.h"

@interface ClickableTextView : NSTextField {}
@end
@implementation ClickableTextView 
  -(void)mouseDown:(NSEvent *)sender {
    NSString *url = [self stringValue];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
  }
@end

@implementation PreferencesController
- (void)windowDidLoad{
  [NSApp makeMainWindow];
  [[self window] makeKeyWindow];
}
-(IBAction)ok:(id)sender{
  [self close];
}

-(IBAction)startAtLaunchToggled:(id)sender {
  NSButton * checkbox = (NSButton *)sender;
  if ([checkbox state]){
    [LoginItemLoader addLoginItem:[LoginItemLoader getCurrentAppPath]];
  } else {
    [LoginItemLoader removeLoginItem:[LoginItemLoader getCurrentAppPath]];
  }
}
-(IBAction)showNotificationsToggled:(id)sender {
  
}

-(IBAction)launchURL:(id)sender {
  [[NSWorkspace sharedWorkspace] 
               openURL:[NSURL URLWithString:@"http://mijoro.com/music"]]; 
 
}

-(void)controlTextDidChange:(NSNotification*)notif {
  NSLog(@"Notif is %@", [notif object]);
  NSTextField* field = [notif object];
  if(field != pluginDropPoint) {
    return;
  }
  NSString *path = [field stringValue];
  [field setStringValue:@""];
  [PluginLoader installPlugin:path];
}
@end
