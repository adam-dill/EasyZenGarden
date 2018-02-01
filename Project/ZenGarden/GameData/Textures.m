//
//  Textures.m
//  ZenGarden
//
//  Created by Adam Dill on 10/14/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import "Textures.h"

@implementation Textures

+(Textures *)sharedTextures
{
    static Textures *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)loadTextures
{
    _horCenter = [SKTexture textureWithImageNamed:@"Tile_Hor_Center"];
    _horLeft = [SKTexture textureWithImageNamed:@"Tile_Hor_Left"];
    _horRight = [SKTexture textureWithImageNamed:@"Tile_Hor_Right"];
    
    _verCenter = [SKTexture textureWithImageNamed:@"Tile_Vert_Center"];
    _verTop = [SKTexture textureWithImageNamed:@"Tile_Vert_Top"];
    _verBottom = [SKTexture textureWithImageNamed:@"Tile_Vert_Bottom"];
    
    _curLeftUp = [SKTexture textureWithImageNamed:@"Tile_Curve_Left_Up"];
    _curLeftDown = [SKTexture textureWithImageNamed:@"Tile_Curve_Left_Down"];
    _curRightUp = [SKTexture textureWithImageNamed:@"Tile_Curve_Right_Up"];
    _curRightDown = [SKTexture textureWithImageNamed:@"Tile_Curve_Right_Down"];
    
    _rock1 = [SKTexture textureWithImageNamed:@"Tile_Rock_1"];
}

@end
