//
//  MJLoginItemLoader.h
//  MijorTunes
//
//  Created by Michael Feldstein on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LoginItemLoader : NSObject {

}
+(void)addLoginItem:(NSString *)path ;
+(void)removeLoginItem:(NSString *)path ;
+(NSString*)getCurrentAppPath;
@end
