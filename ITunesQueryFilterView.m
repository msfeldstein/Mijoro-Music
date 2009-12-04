//
//  ITunesQueryFilterView.m
//  MijorTunes
//
//  Created by Michael Feldstein on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ITunesQueryFilterView.h"


@implementation ITunesQueryFilterView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        iTunesController = [[MJITunesController alloc]init];
    }
    return self;
}

-(IBAction) filterForSongs:(id)sender{
	NSString * query = [sender stringValue];
	NSArray * results = [iTunesController search:query];
	NSLog(@"Were filtering and have %@" , results);
	[tableController setData:results];
	[tableController reloadData];
}

@end
