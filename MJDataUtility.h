//
//  MJDataUtility.h
//  MijoroMusic
//
//  Created by Michael Feldstein on 4/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MJDataUtility : NSObject {
}
+ (NSString *) createJSONStringFromDictionary:(NSDictionary *)dictionary;	
+ (NSDictionary *) getDictionaryFromURLString:(NSString *)query;
@end
