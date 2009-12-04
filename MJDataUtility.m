//
//  MJDataUtility.m
//  MijoroMusic
//
//  Created by Michael Feldstein on 4/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MJDataUtility.h"


@implementation MJDataUtility
+ (NSString *) createJSONStringFromDictionary:(NSDictionary *)dictionary{
	NSMutableString * json = [NSMutableString stringWithString:@"{"];
	NSEnumerator *enumerator = [dictionary keyEnumerator];
	NSString * key;
	
	while ((key = [enumerator nextObject])) {
		[json appendString:[NSString stringWithFormat:@"\"%@\"", key]];
		[json appendString:@":"];
		[json appendString:[NSString stringWithFormat:@"\"%@\"", [dictionary objectForKey:key]]];
		[json appendString:@","];
	}
	json = [NSString stringWithFormat:@"%@}", [json substringToIndex:[json length]-1]];
	return json;
}

+ (NSDictionary *) getDictionaryFromURLString:(NSString *)query{
	NSMutableDictionary * ret = [[NSMutableDictionary alloc]init];
	NSArray * urlParams = [query componentsSeparatedByString:@"&"];
	NSArray * paramParts;
	NSString * urlPart;
	for(int i = 0; i < [urlParams count]; i++){
		urlPart = [urlParams objectAtIndex:i];
		paramParts = [urlPart componentsSeparatedByString:@"="];
		[ret setObject:[paramParts objectAtIndex:1] forKey:[paramParts objectAtIndex:0]];
	}
	return ret;
}

@end
