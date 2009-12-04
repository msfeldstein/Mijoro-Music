//
//  MJItunesObserver.h
//  MijorTunes
//
//  Created by Michael Feldstein on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MJItunesObserver : NSObject {
	NSMutableArray * observers;
}
-(void)addObserver:(id)observerToAdd;
-(void)removeObserver:(id)observerToRemove;
-(void)listenForItunesEvent;
-(void)iTunesEventReceived:(id)info;
@end
