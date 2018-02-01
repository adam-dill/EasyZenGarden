//
//  GameScene.h
//  ZenGarden
//

//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Board.h"

@interface GameScene : SKScene <BoardDelegate>

-(void)boardCleared;

@end
