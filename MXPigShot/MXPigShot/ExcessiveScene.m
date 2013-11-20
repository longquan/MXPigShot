//
//  ExcessiveScene.m
//  MXPigShot
//
//  Created by longquan on 13-11-12.
//  Copyright 2013年 longquan. All rights reserved.
//

#import "ExcessiveScene.h"

@implementation ExcessiveLayer


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ExcessiveLayer *layer = [ExcessiveLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        
        CCSprite* icon = [CCSprite spriteWithFile:@"Icon.png"];
        CCProgressTimer* process = [CCProgressTimer progressWithSprite:icon];
        [process setPosition:ccp(100, 180)];
        [process setType:kCCProgressTimerTypeRadial];
        [process setPercentage:100];
        [process setReverseDirection:YES];
        [self addChild:process];
        CCProgressTo *to1 = [CCProgressTo actionWithDuration:2 percent:100];
        [process runAction:[CCRepeatForever actionWithAction:to1]];
        
        CCProgressTimer* process2 = [CCProgressTimer progressWithSprite:icon];
        [process2 setPosition:ccp(200, 180)];
        [process2 setType:kCCProgressTimerTypeBar];
        [process2 setMidpoint:ccp(0, 1)];
        [process2 setBarChangeRate:ccp(0, 1)];
        [self addChild:process2];
        
        CCProgressTo *to2 = [CCProgressTo actionWithDuration:2 percent:100];
        [process2 runAction:[CCRepeatForever actionWithAction:to2]];
        
        
        
    }
    return self;
    
}

- (void)dealloc {
    [super dealloc];
    
}

@end

@implementation ExcessiveScene
@synthesize layer;
- (id)init {
    
    
    if ((self = [super init])) {
        self.layer = [ExcessiveLayer node];
        [self addChild:layer];
        
    }
    return self;
}

- (void)dealloc {
    [layer release];
    layer = nil;
    [super dealloc];
    
}

@end
