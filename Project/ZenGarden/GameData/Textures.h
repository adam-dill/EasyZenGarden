//
//  Textures.h
//  ZenGarden
//
//  Created by Adam Dill on 10/14/14.
//  Copyright (c) 2014 Adam Dill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Textures : NSObject



+(Textures *)sharedTextures;
-(void)loadTextures;



/** Blocks */
@property (nonatomic, readonly) SKTexture *rock1;



/** Paths */
@property (nonatomic, readonly) SKTexture *horCenter;
@property (nonatomic, readonly) SKTexture *horLeft;
@property (nonatomic, readonly) SKTexture *horRight;

@property (nonatomic, readonly) SKTexture *verCenter;
@property (nonatomic, readonly) SKTexture *verTop;
@property (nonatomic, readonly) SKTexture *verBottom;

@property (nonatomic, readonly) SKTexture *curLeftUp;
@property (nonatomic, readonly) SKTexture *curLeftDown;
@property (nonatomic, readonly) SKTexture *curRightUp;
@property (nonatomic, readonly) SKTexture *curRightDown;





@end
