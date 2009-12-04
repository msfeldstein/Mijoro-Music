//
//  PluginLoader.m
//  MijorTunes
//
//  Created by Michael Feldstein on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PluginLoader.h"
#import "MusicControllerProtocol.h"

//static NSString *appSupportPath = @"~/Library/Application Support/MijoroMusic/PlugIns/";
//static PluginLoader *instance = nil;
@implementation PluginLoader
//+(PluginLoader *) getInstance {
//  if(instance){
//    return instance;
//  }
//  instance = [[PluginLoader alloc]init];
//}
//
//-(id)init {
//  NSFileManager *fileManager = [NSFileManager defaultManager];
//  NSArray * contents = [fileManager directoryContentsAtPath:appSupportPath];
//  if(contents == nil){
//    [fileManager createDirectoryAtPath:path attributes:nil];
//  }
//}


//+(BOOL) installPlugin:(NSString*)path {
//  NSFileManager *fileManager = [NSFileManager defaultManager];
//  NSString *extension = [path pathExtension];
//  if(![extension isEqualToString:@"bundle"] || ![fileManager fileExistsAtPath:path]){
//    return NO;
//  }
//  
//  NSString *filename = [[path pathComponents] lastObject];
//  BOOL success = [fileManager copyPath:path toPath:[appSupportPath stringByAppendingPathComponent:filename] handler:self];
//
//  return success;
//}

+ (NSArray *)pluginClasses {
  NSLog(@"Called plugin classes");
  NSMutableArray *instances;
  NSMutableArray *bundlePaths;
  NSMutableArray *classArray = [[NSMutableArray alloc]  init];
  NSEnumerator *pathEnum;
  NSString *currPath;
  NSBundle *currBundle;
  Class currPrincipalClass;
  id currInstance;
  
  bundlePaths = [NSMutableArray array];
  if(!instances) {
    instances = [[NSMutableArray alloc] init];
  }
  
  [bundlePaths addObjectsFromArray:[self allBundles]];
 
  pathEnum = [bundlePaths objectEnumerator];
  while(currPath = [pathEnum nextObject]) {
    currBundle = [NSBundle bundleWithPath:currPath];
    if(currBundle) {
      currPrincipalClass = [currBundle principalClass];
      if(currPrincipalClass) {
        currInstance = [[currPrincipalClass alloc] init];
        if(currInstance) {
          if([currPrincipalClass conformsToProtocol:@protocol(MusicControllerProtocol)]) {
            [classArray addObject:currPrincipalClass];
          } 
        }
      }
    }
  }
  return classArray;
}



+ (NSMutableArray *)allBundles{
  NSString *ext = @"bundle";
  
  NSString *appSupportSubpath = @"Application Support/MijoroMusic/PlugIns";
  NSArray *librarySearchPaths;
  NSEnumerator *searchPathEnum;
  NSString *currPath;
  NSMutableArray *bundleSearchPaths = [NSMutableArray array];
  NSMutableArray *allBundles = [NSMutableArray array];
  NSBundle *bundle = [NSBundle mainBundle];
  //NSString *defaultPlugin = [bundle pathForResource:@"ITunesControllerPlugin" ofType:@"bundle"];
//  [allBundles addObject:defaultPlugin];
  
  librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
  
  searchPathEnum = [librarySearchPaths objectEnumerator];
  while(currPath = [searchPathEnum nextObject])
  {
    [bundleSearchPaths addObject:  
    [currPath stringByAppendingPathComponent:appSupportSubpath]];
  }
  [bundleSearchPaths addObject:
  [[NSBundle mainBundle] builtInPlugInsPath]];
  searchPathEnum = [bundleSearchPaths objectEnumerator];
  while(currPath = [searchPathEnum nextObject]) {
    NSDirectoryEnumerator *bundleEnum;
    NSString *currBundlePath;
    bundleEnum = [[NSFileManager defaultManager]
                  enumeratorAtPath:currPath];
    if(bundleEnum)  {
      while(currBundlePath = [bundleEnum nextObject]) {
        if([[currBundlePath pathExtension] isEqualToString:ext]) {
          [allBundles addObject:[currPath
                                 stringByAppendingPathComponent:currBundlePath]];
        }
      }
    }
  }
  return allBundles;
  
}
@end
