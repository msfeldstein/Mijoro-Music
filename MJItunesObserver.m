//
//  MJItunesObserver.m
//  MijorTunes
//
//  Created by Michael Feldstein on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MJItunesObserver.h"


@implementation MJItunesObserver

-(id)init {
	self = [super init];
	NSLog(@"initializing itunes observer");
	
	observers = [[NSMutableArray alloc]init];
	
	return self;
}

-(void)addObserver:(id)observerToAdd{
	if(observerToAdd == nil){
		return;
	}
	[observers addObject:observerToAdd];
}


-(void)removeObserver:(id)observerToRemove{
	[observers removeObject:observerToRemove];
}

-(void)listenForItunesEvent {
	NSLog(@"Lets listen!");
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(iTunesEventReceived:)
	 name:@"com.apple.iTunes.playerInfo"
	 object:nil];
}

-(void)iTunesEventReceived:(id)info {

}
@end
