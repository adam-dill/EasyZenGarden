//
//  Board.m
//  ZenGarden
//
//  Created by Adam Dill on 10/7/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import "Board.h"
#import "Tile.h"


@implementation Board
{
    SKSpriteNode *_background;
    NSMutableArray *_selectedPath;
    BOOL _allowInput;
}

-(instancetype)initWithSize:(CGSize)size data:(NSArray *)data
{
    if (self = [super initWithColor:nil size:size])
    {
        self.userInteractionEnabled = YES;
        self.anchorPoint = CGPointZero;
        
        // Default members
        _selectedPath = [[NSMutableArray alloc] init];
        _tilesRemaining = 0;
        _allowInput = YES;
        
        // Construct the background
        _background = [SKSpriteNode spriteNodeWithColor:nil size:self.size];
        _background.anchorPoint = CGPointZero;
        
        [self addChild:_background];
        [self buildBoard:data];
    }
    return self;
}

-(void)buildBoard:(NSArray *)data
{
    _background.texture = [SKTexture textureWithImageNamed:@"Board_7_7"];
    
    // assuming the board is a square
    int divide = sqrtf([data count]);
    CGFloat tileWidth = self.size.width / divide;
    CGFloat tileHeight = self.size.height / divide;
    int count = 0;
    for (int i = 0; i < divide; i++) {
        for (int j = 0; j < divide; j++) {
            Tile *tile = [[Tile alloc] initWithSize:CGSizeMake(tileWidth, tileHeight)
                                        coordinates:CGPointMake(j, i)
                                          textureId:(int)[data[count] integerValue]];
            tile.zPosition = 1;
            CGFloat newX = tileWidth * j + tileWidth * 0.5;
            CGFloat newY = self.size.height - (tileHeight * i + tileWidth * 0.5);
            tile.position = CGPointMake(newX, newY);
            [self addChild:tile];
            
            if (tile.state != BLOCKED)
                _tilesRemaining++;
            
            count++;
        }
    }
}

#pragma mark User Input

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_allowInput)
        return;
    
    Tile *tile = [self getTileAtTouch:[touches anyObject]];
    if (!tile)
        return;
    
    if (tile.state != BLOCKED)
    {
        NSUInteger tileIndex = [_selectedPath indexOfObject:tile];
        BOOL isGoodVector = [self tileIsGoodVector:tile];
        
        // This a new path. Tile is not blocked AND is in the path AND isn't a good vector
        if (tileIndex == NSNotFound && !isGoodVector && [_selectedPath count] != 0)
        {
            [self clearTilesFrom:0];
        }
        // The user selected a previous tile in the path
        else if (tileIndex != NSNotFound)
        {
            [self clearTilesFrom:tileIndex];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_allowInput)
        return;
    
    Tile *tile = [self getTileAtTouch:[touches anyObject]];
    if (!tile)
        return;
        
    NSUInteger tileIndex = [_selectedPath indexOfObject:tile];
    BOOL isGoodVector = [self tileIsGoodVector:tile];
    
    // if tile state is not BLOCKED
    // AND not in the selectedPath
    // AND a good vector (one tile UP, DOWN, LEFT, or RIGHT)
    if(tile.state != BLOCKED && tileIndex == NSNotFound && isGoodVector)
    {
        [self addTileToPath:tile];
    }
    // the user went back one tile
    else if(tileIndex == [_selectedPath count] - 2)
    {
        [self clearTilesFrom:(tileIndex + 1)];
    }
    
    _lastTouch = [[touches anyObject] locationInNode:self];
}

#pragma mark Helpers

-(Tile *)getTileAtTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    return (node != self) ? (Tile *)node : nil;
}

-(void)addTileToPath:(Tile *)tile
{
    Tile *lastTile = [_selectedPath lastObject];
    tile.previousTile = lastTile;
    tile.previousTile.nextTile = tile;
    [_selectedPath addObject:tile];
    _tilesRemaining--;
    
    // prevent updating the board if only one tile is selected, because
    // the tile won't have a texture yet.
    if ([_selectedPath count] != 1) {
        [self updateRemaining];
    }
}

-(void)clearTilesFrom:(NSUInteger)index
{
    int begin = ((int)index == 0) ? 0 : ((int)index + 1);
    int end = (int)[_selectedPath count] - 1;
    
    for (int i = end; i >= begin; i--)
    {
        Tile *tile = (Tile *)_selectedPath[i];
        tile.previousTile.nextTile = nil;
        tile.previousTile = nil;
        [_selectedPath removeObjectAtIndex:i];
        _tilesRemaining++;
    }
    [self updateRemaining];
}

-(BOOL)tileIsGoodVector:(Tile *)tile
{
    CGPoint vector = [self getTileVectorFromLast:tile];
    // we moved more than one tile, or we moved diagonal.
    int xMove = abs(vector.x);
    int yMove = abs(vector.y);
    BOOL hasMoved = (xMove != 0 || yMove != 0);
    BOOL movedInBounds = (xMove <= 1 && yMove <= 1);
    BOOL movedOneWay = (xMove == 0 || yMove == 0);
    BOOL isFirstMove = ([_selectedPath count] == 0);
    return (hasMoved && movedInBounds && movedOneWay) || isFirstMove;
}

-(CGPoint)getTileVectorFromLast:(Tile *)tile
{
    CGPoint returnValue = CGPointZero;
    NSUInteger count = [_selectedPath count];
    if (count != 0)
    {
        Tile *lastTile = (Tile *)_selectedPath[[_selectedPath count] - 1];
        if (tile != lastTile)
        {
            returnValue = CGPointMake(tile.coordinates.x - lastTile.coordinates.x, tile.coordinates.y - lastTile.coordinates.y);
        }
    }
    return returnValue;
}

-(void)updateRemaining
{
    if (_tilesRemaining == 0)
    {
        _allowInput = NO;
    }
    [_delegate remainingChanged:_tilesRemaining];
}

@end
