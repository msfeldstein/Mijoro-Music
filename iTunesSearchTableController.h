//
//  iTunesSearchTableController.h
//  MijorTunes
//
//  Created by Michael Feldstein on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "MJSongTrack.h"

@interface iTunesSearchTableController : NSArrayController {
	NSArray * data;
	IBOutlet id resultTable;
	
}
- (void) setData:(NSArray *)data;
- (void) reloadData;
- (int)numberOfRowsInTableView:(NSTableView *)aTable;
- (id)tableView:(NSTableView *)aTable objectValueForColumn:(NSTableColumn *)aCol row:(int)aRow;
@end
