//
//  ITunesQueryFilterView.h
//  MijorTunes
//
//  Created by Michael Feldstein on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MJITunesController.h"
#include "MJSongTrack.h"
#import "iTunesSearchTableController.h"

@interface ITunesQueryFilterView : NSView {
	IBOutlet id filter;
	IBOutlet id resultTable;
	IBOutlet id tableController;
	iTunesSearchTableController * controller;
	MJITunesController * iTunesController;
}
-(IBAction) filterForSongs:(id)sender;
@end
