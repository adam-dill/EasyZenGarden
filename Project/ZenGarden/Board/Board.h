//
//  Board.h
//  ZenGarden
//
//  Created by Adam Dill on 10/7/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol BoardDelegate <NSObject>

-(void)remainingChanged:(int)remaining;

@end

@interface Board : SKSpriteNode

@property (nonatomic) id<BoardDelegate> delegate;
@property (nonatomic) int tilesRemaining;
@property (nonatomic, readonly) CGPoint lastTouch;

-(instancetype)initWithSize:(CGSize)size data:(NSArray *)data;

@end
