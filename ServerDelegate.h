//
//  ServerDelegate.h
//  MijoroMusic
//
//  Created by Michael Feldstein on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol ServerDelegate 
-(NSDictionary *)sendServerAction:(NSDictionary *)parameters;
@end
