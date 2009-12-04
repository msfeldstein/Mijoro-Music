//
//  iTunesSearchTableController.m
//  MijorTunes
//
//  Created by Michael Feldstein on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "iTunesSearchTableController.h"


@implementation iTunesSearchTableController


- (void) setData:(NSArray *)newdata {
	data = newdata;
	[resultTable reloadData];
}
	 
- (int)numberOfRowsInTableView:(NSTableView *)aTable{
	NSLog(@"Asking for num rows");
	if(data == NULL){
		return 0;
	} else {
		return [data count];
	}
}

- (void) reloadData {
	[resultTable reloadData];
}

- (id)tableView:(NSTableView *)aTable objectValueForColumn:(NSTableColumn *)aCol row:(int)aRow{
	NSLog(@"Were looking for column %@ and row %@", aCol, aRow);
	MJSongTrack * song = [data objectAtIndex:aRow];
	return @"Hi";
}
@end
