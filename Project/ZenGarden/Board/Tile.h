//
//  Tile.h
//  ZenGarden
//
//  Created by Adam Dill on 10/7/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum{
    NONE,
    BLOCKED,
    SELECTED
}TileState;

@interface Tile : SKSpriteNode

-(instancetype)initWithSize:(CGSize)size coordinates:(CGPoint)coordinates textureId:(int)textureId;

@property (nonatomic, readonly) TileState state;
@property (nonatomic) CGPoint coordinates;
@property (nonatomic) Tile *previousTile;
@property (nonatomic) Tile *nextTile;

@end
