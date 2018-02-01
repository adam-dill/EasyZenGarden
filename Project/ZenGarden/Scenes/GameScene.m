//
//  GameScene.m
//  ZenGarden
//
//  Created by Adam Dill on 10/7/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import "GameScene.h"
#import "GameData.h"
#import "LevelData.h"

const CGFloat PADDING = 0.0;
const int PLAYS_BEFORE_AD = 5;
int NumberOfPlays = 0;

@implementation GameScene
{
    Board *_board;
    SKLabelNode *_levelLabel;
    SKLabelNode *_nextLabel;
    SKLabelNode *_prevLabel;
    
    SKLabelNode *_remainingLabel;
    BOOL isTransitioning;
    
    SKEmitterNode *_backgroundEffect;
    SKEmitterNode *_completedEffect;
    
    CGPoint _lastTouch;
}

#pragma mark Initialization


-(void)didMoveToView:(SKView *)view
{
    _backgroundEffect = [SKEmitterNode nodeWithFileNamed:@"Magic.sks"];
    _backgroundEffect.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    _backgroundEffect.userInteractionEnabled = NO;
    
    _completedEffect = [SKEmitterNode nodeWithFileNamed:@"Fireflies.sks"];
    _completedEffect.userInteractionEnabled = NO;
    _completedEffect.zPosition = 10;
    
    [self addChild:_backgroundEffect];
    
    [self buildLabels];
    self.backgroundColor = [SKColor whiteColor];
    [self transitionIn];
}

-(void)buildLevel
{
    CGFloat boardSize = self.size.width - (PADDING * 2);
    int currentLevel = (int)[[GameData getCurrentLevel] integerValue];
    _board = [[Board alloc] initWithSize:CGSizeMake(boardSize, boardSize) data:[GameData getLevelForId:currentLevel]];
    _levelLabel.text = [NSString stringWithFormat:@"Garden %d", currentLevel];
    _board.delegate = self;
    CGFloat boardX = self.size.width * 0.5 - _board.size.width * 0.5;
    CGFloat boardY = self.size.height * 0.5 - _board.size.height * 0.5;
    _board.position = CGPointMake(boardX, boardY);
    _board.alpha = 0;
    [self addChild:_board];
    
    _levelLabel.position = CGPointMake(boardX + _board.size.width * 0.5, boardY - 20);
    _prevLabel.position = CGPointMake(_levelLabel.position.x - _levelLabel.frame.size.width * 0.5 - 10, _levelLabel.position.y - 3);
    _nextLabel.position = CGPointMake(_levelLabel.position.x + _levelLabel.frame.size.width * 0.5 + 10, _levelLabel.position.y - 3);
    
    _remainingLabel.position = CGPointMake(boardX + _board.size.width - 10, boardY + _board.size.height + 10);
    [self remainingChanged:_board.tilesRemaining];
}

-(void)buildLabels
{
    NSString *fontface = @"HiraKakuProN-W3";
    
    _levelLabel = [SKLabelNode labelNodeWithFontNamed:fontface];
    _levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _levelLabel.fontColor = [SKColor grayColor];
    [self addChild:_levelLabel];
    
    _nextLabel = [SKLabelNode labelNodeWithFontNamed:fontface];
    _nextLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _nextLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _nextLabel.fontColor = [SKColor grayColor];
    _nextLabel.text = @">>";
    [self addChild:_nextLabel];
    
    _prevLabel = [SKLabelNode labelNodeWithFontNamed:fontface];
    _prevLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    _prevLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _prevLabel.fontColor = [SKColor grayColor];
    _prevLabel.text = @"<<";
    [self addChild:_prevLabel];
    
    _remainingLabel = [SKLabelNode labelNodeWithFontNamed:fontface];
    _remainingLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    _remainingLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    _remainingLabel.fontSize = 14;
    _remainingLabel.fontColor = [SKColor grayColor];
    [self addChild:_remainingLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!isTransitioning)
    {
        CGPoint location = [[touches anyObject] locationInNode:self];
        if ([_nextLabel containsPoint:location])
        {
            [self boardCleared];
        }
        else if([_prevLabel containsPoint:location])
        {
            [self goLevelBack];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _lastTouch = [[touches anyObject] locationInNode:self];
}

#pragma mark Entry/Exit

-(void)transitionIn
{
    [self buildLevel];
    
    SKAction *fade = [SKAction fadeInWithDuration:1.0];
    SKAction *completed = [SKAction runBlock:^{
        //NSLog(@"transition in completed");
        isTransitioning = NO;
    }];
    [_board runAction:[SKAction sequence:@[fade, completed]]];
}

-(void)transitionOut
{
    isTransitioning = YES;
    //[_board removeFromParent];
    SKAction *fade = [SKAction fadeOutWithDuration:1.0];
    SKAction *completed = [SKAction runBlock:^{
        [_board removeFromParent];
        [self transitionIn];
    }];
    [_board runAction:[SKAction sequence:@[fade, completed]]];
}

#pragma mark Remaining Changed

-(void)remainingChanged:(int)remaining
{
    NSString *plural = (remaining != 1) ? @"s" : @"";
    _remainingLabel.text = [NSString stringWithFormat:@"%d tile%@ remaining", remaining, plural];
    
    // check for completion
    if (remaining == 0) {
        [_completedEffect removeFromParent];
        _completedEffect.position = [_board convertPoint:_board.lastTouch toNode:self];//_board.lastTouch;
        [_completedEffect resetSimulation];
        [self addChild:_completedEffect];
        [self boardCleared];
    }
}

-(void)boardCleared
{
    [self goLevelForward];
}



#pragma mark Helpers

-(void)goLevelForward
{
    [GameData setCurrentLevel:[NSNumber numberWithInt:[self calculateNextLevel]]];
    [self transitionOut];
}

-(void)goLevelBack
{
    [GameData setCurrentLevel:[NSNumber numberWithInt:[self calculatePrevLevel]]];
    [self transitionOut];
}

-(int)calculateNextLevel
{
    int totalLevels = [GameData numberOfLevels];
    NSNumber *currentLevel = [GameData getCurrentLevel];
    int newLevel = [currentLevel intValue] + 1;
    if (newLevel > totalLevels) {
        newLevel = 1;
    }
    return newLevel;
}

-(int)calculatePrevLevel
{
    int totalLevels = [GameData numberOfLevels];
    NSNumber *currentLevel = [GameData getCurrentLevel];
    int newLevel = [currentLevel intValue] - 1;
    if (newLevel <= 0) {
        newLevel = totalLevels;
    }
    return newLevel;
}



@end
