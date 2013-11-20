//
//  GameBeginScene.h
//  MXPigShot
//
//  Created by longquan on 13-11-9.
//  Copyright 2013年 longquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface GameBeginLayer : CCLayerColor
+(CCScene *) scene;
@end

@interface GameBeginScene : CCScene{
    GameBeginLayer *_layer;
}

@property (nonatomic, retain) GameBeginLayer *layer;

@end
