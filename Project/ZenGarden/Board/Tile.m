//
//  Tile.m
//  ZenGarden
//
//  Created by Adam Dill on 10/7/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import "Tile.h"
#import "Textures.h"

@implementation Tile
{
    
}

-(instancetype)initWithSize:(CGSize)size coordinates:(CGPoint)coordinates textureId:(int)textureId
{
    if (self = [super initWithColor:nil size:size])
    {
        _coordinates = coordinates;
        _state = NONE;
        
        // Set the texture of blocked tiles initially.
        // Logic handles the user interactive tiles.
        if (textureId != 0) {
            _state = BLOCKED;
            self.texture = [[Textures sharedTextures] rock1];
        }
        else
        {
            self.alpha = 0.0;
        }
    }
    return self;
}


/**
 *  Next and Previous tile can be used to determine what texture we should use.
 */
-(void)setNextTile:(Tile *)nextTile
{
    _nextTile = nextTile;
    [self updateState];
}

-(void)setPreviousTile:(Tile *)previousTile
{
    _previousTile = previousTile;
    [self updateState];
}

-(void)updateState
{
    // We should not be calling update on a blocked Tiles texture.
    if (_state == BLOCKED) {
        //NSLog(@"ERROR: attempting to update a Tiles state while BLOCKED.");
        return;
    }
    
    _state = (_nextTile != nil || _previousTile != nil) ? SELECTED : NONE;
    
    [self updateTexture];
}

-(void)updateTexture
{
    [self removeAllActions];
    
    // clear the texture
    if (_state == NONE)
    {
        self.texture = nil;
        self.alpha = 0.0;
    }
    else if (_state == SELECTED)
    {
        if (!_previousTile && !_nextTile)
        {
            //NSLog(@"ERROR: updateTexture doesn't have previous and next Tiles set correctly.");
            return;
        }
        
        // This is the first or last Tile in the selected path
        if (!_previousTile || !_nextTile)
        {
            [self handleCapTextures];
        }
        // This is a center Tile in the selected path
        else if(_previousTile && _nextTile)
        {
            [self handleMiddleTextures];
        }
        
        [self runAction:[SKAction fadeInWithDuration:0.5]];
    }
}

-(void)handleCapTextures
{
    // First or Last is determined by which Tile we have a reference to.
    CGPoint vector = [self subtractTilesCoordinates:self b:(_nextTile) ? _nextTile : _previousTile];
    if (vector.x == 0 && vector.y != 0)
    {
        // we are vertical
        if (vector.y > 0) // UP
            self.texture = [[Textures sharedTextures] verBottom];
        else // DOWN
            self.texture = [[Textures sharedTextures] verTop];
    }
    else
    {
        // we are horizontal
        if (vector.x < 0) // RIGHT
            self.texture = [[Textures sharedTextures] horLeft];
        else // LEFT
            self.texture = [[Textures sharedTextures] horRight];
    }
}

-(void)handleMiddleTextures
{
    CGPoint vector = [self subtractTilesCoordinates:_previousTile b:_nextTile];
    // STRAIGHT
    if (vector.x == 0 || vector.y == 0)
    {
        self.texture = (vector.y == 0) ? [[Textures sharedTextures] horCenter] : [[Textures sharedTextures] verCenter];
    }
    // CURVE
    else
    {
        CGPoint diffPrev = [self subtractTilesCoordinates:self b:_previousTile];
        CGPoint diffNext = [self subtractTilesCoordinates:self b:_nextTile];
        self.texture = [self getCurveTexture:diffPrev diffNext:diffNext];
    }
}

-(SKTexture *)getCurveTexture:(CGPoint)diffPrev diffNext:(CGPoint)diffNext
{
    // how are we shifting. Which two opposing tiles are visible
    Tile *shiftHor = (diffPrev.x != 0) ? _previousTile : _nextTile;
    Tile *shiftVer = (diffPrev.y != 0) ? _previousTile : _nextTile;
    
    BOOL isLeft = (_coordinates.x - shiftHor.coordinates.x) > 0;
    BOOL isRight = !isLeft;
    BOOL isUp = (_coordinates.y - shiftVer.coordinates.y) > 0;
    BOOL isDown = !isUp;
    
    SKTexture *texture;
    if (isRight && isUp)
    {
        texture = [[Textures sharedTextures] curRightUp];
    }
    else if (isRight && isDown)
    {
        texture = [[Textures sharedTextures] curRightDown];
    }
    else if (isLeft && isDown)
    {
        texture = [[Textures sharedTextures] curLeftDown];
    }
    else if (isLeft && isUp)
    {
        texture = [[Textures sharedTextures] curLeftUp];
    }
    else
    {
        //NSLog(@"ERROR Tile.getCurveTexture() No conditions match.");
        texture = [[Textures sharedTextures] horCenter]; // Failure default?
    }
    return texture;
}

-(CGPoint)subtractTilesCoordinates:(Tile *)a b:(Tile *)b
{
    if (!a || !b || a == b)
        return CGPointZero;
    
    return CGPointMake(a.coordinates.x - b.coordinates.x, a.coordinates.y - b.coordinates.y);
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"tile [%.f,%.f]", _coordinates.x, _coordinates.y];
}

@end
