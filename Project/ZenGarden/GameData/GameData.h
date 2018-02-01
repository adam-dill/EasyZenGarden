//
//  GameData.h
//  ZenGarden
//
//  Created by Adam Dill on 9/30/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameData : NSObject

+(NSNumber *)getCurrentLevel;
+(void)setCurrentLevel:(NSNumber *)level;

+(int)numberOfLevels;
+(NSArray *)getLevelForId:(int)levelId;

@end
