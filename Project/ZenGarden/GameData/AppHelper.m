//
//  AppHelper.m
//  ZenGarden
//
//  Created by Adam Dill on 9/30/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

+(NSString *)getDocsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

+(BOOL)setPlist:(NSString *)strPlistName
{
    NSError *error;
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:strPlistName ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
        return YES;
    }
    else {
        return NO;
    }
}

+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key strValue:(NSString *)strValue
{
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [data setObject:strValue forKey:key];
    
    [data writeToFile:path atomically:YES];
}

+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key numValue:(NSNumber *)numValue
{
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [data setObject:numValue forKey:key];
    
    [data writeToFile:path atomically:YES];
}

+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key dateValue:(NSDate *)dateValue
{
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [data setObject:dateValue forKey:key];
    
    [data writeToFile:path atomically:YES];
}

+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key
{
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    return [data objectForKey:key];
}

@end