//
//  PreferencesController.h
//  MijoroMusic
//
//  Created by Michael Feldstein on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//enum { 
//  MJLaunchAtBoot = @"launchAtBoot",
//  MJShowNotifications = @"showNotifications"
//};

@interface PreferencesController : NSWindowController {
  IBOutlet NSButton* okButton;
  IBOutlet NSButton* startAtLaunchCheckbox;
  IBOutlet NSButton* showNotificationsCheckbox;
  IBOutlet NSTextField* pluginDropPoint;
  IBOutlet NSView* serverSettingsBox;
  IBOutlet NSTextField* phoneNumberField;
}

-(IBAction)ok:(id)sender;
-(IBAction)startAtLaunchToggled:(id)sender;
-(IBAction)showNotificationsToggled:(id)sender;
-(IBAction)launchURL:(id)sender;
-(IBAction)dropPlugin:(id)sender;
@end
