//
//  ExcessiveScene.h
//  MXPigShot
//
//  Created by longquan on 13-11-12.
//  Copyright 2013年 longquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ExcessiveLayer : CCLayerColor
+ (CCScene *) scene;
@end

@interface ExcessiveScene : CCScene{
    ExcessiveLayer *layer;
}

@property (retain,nonatomic) ExcessiveLayer *layer;

@end
