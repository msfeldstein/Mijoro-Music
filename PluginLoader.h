//
//  PluginLoader.h
//  MijorTunes
//
//  Created by Michael Feldstein on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PluginLoader : NSObject {
}
+(NSArray *) pluginClasses;
+(NSMutableArray *) allBundles;
+(BOOL) installPlugin:(NSString*)path;
@end
