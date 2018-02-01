//
//  LevelData.h
//  ZenGarden
//
//  Created by Adam Dill on 9/25/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelData : NSObject

+(int)numberOfLevels;
+(NSArray *)getLevelForId:(int)levelId;

@end
