//
//  MJLoginItemLoader.m
//  MijorTunes
//
//  Created by Michael Feldstein on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoginItemLoader.h"



@implementation LoginItemLoader
+ (void)addLoginItem:(NSString *)path {
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:path];
	
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	// We call LSSharedFileListInsertItemURL to insert the item at the bottom of Login Items list.
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);		
	if (item)
		CFRelease(item);
	
	CFRelease(loginItems);
}

+(void)removeLoginItem:(NSString *)path {
	UInt32 seedValue;
	CFURLRef thePath = (CFURLRef)[NSURL fileURLWithPath:path];
	LSSharedFileListRef theLoginItemsRefs = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	// We're going to grab the contents of the shared file list (LSSharedFileListItemRef objects)
	// and pop it in an array so we can iterate through it to find our item.
	NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
	for (id item in loginItemsArray) {		
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
			if ([[(NSURL *)thePath path] hasPrefix:path])
				LSSharedFileListItemRemove(theLoginItemsRefs, itemRef); // Deleting the item
		}
	}
	
	[loginItemsArray release];
	
}

+(NSString *)getCurrentAppPath {
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* path = [bundle bundlePath];
	return path;
}
@end
