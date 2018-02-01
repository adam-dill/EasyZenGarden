//
//  AppHelper.h
//  ZenGarden
//
//  Created by Adam Dill on 9/30/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject 

+(NSString *)getDocsDirectory;
+(BOOL)setPlist:(NSString *)strPlistName;
+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key strValue:(NSString *)strValue;
+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key numValue:(NSNumber *)numValue;
+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key dateValue:(NSDate *)dateValue;
+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key;

@end
