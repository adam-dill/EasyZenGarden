//
//  GameData.m
//  ZenGarden
//
//  Created by Adam Dill on 9/30/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import "GameData.h"
#import "AppHelper.h"
#import "LevelData.h"

#define MAIN_PLIST "ZenGarden"
#define CURRENT_LEVEL "CurrentLevel"
#define LAST_COMPLETED_DATE "LastCompletedDate"

#define LEVEL_COMPLETE_PLIST "CompletedLevels"
#define LEVEL_COMPLETED "completed"

@implementation GameData

+(NSNumber *)getCurrentLevel
{
    return [AppHelper getPlistData:@MAIN_PLIST key:@CURRENT_LEVEL];
}

+(void)setCurrentLevel:(NSNumber *)level
{
    [AppHelper setPlistData:@MAIN_PLIST key:@CURRENT_LEVEL numValue:level];
}

+(int)numberOfLevels
{
    return [LevelData numberOfLevels];
}

+(NSArray *)getLevelForId:(int)levelId
{
    return [LevelData getLevelForId:levelId];
}

@end
