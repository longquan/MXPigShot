//
//  GameOverScene.m
//  PlaneDemoIOS
//
//  Created by longquan on 13-11-1.
//  Copyright (c) 2013年 longquan. All rights reserved.
//
#import "GameBeginScene.h"
#import "HelloWorldLayer.h"
#import "ccDeprecated.h"
#import "ExcessiveScene.h"

@implementation GameBeginScene
@synthesize layer = _layer;

- (id)init {
    if ((self = [super init])) {
        self.layer = [GameBeginLayer node];
        [self addChild:_layer];
        
    }
    return self;
    
}

- (void)dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
    
}

@end

@implementation GameBeginLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameBeginLayer *layer = [GameBeginLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        CCSprite *spring = [CCSprite spriteWithFile:@"spring.png"];
        CCSprite *springed = [CCSprite spriteWithFile:@"spring.png"];
        CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:spring selectedSprite:springed block:^(id sender) {
            HelloWorldScene *scene = [HelloWorldScene node];
            scene.layer.sceneNum = 1;
            [[CCDirector sharedDirector] replaceScene:[GameBeginScene node]];
        }];
        
        CCSprite *summer = [CCSprite spriteWithFile:@"summer.png"];
        CCSprite *summered = [CCSprite spriteWithFile:@"summer.png"];
        CCMenuItemSprite *item1 = [CCMenuItemSprite itemWithNormalSprite:summer selectedSprite:summered block:^(id sender) {
            HelloWorldScene *scene = [HelloWorldScene node];
            scene.layer.sceneNum = 2;
            [[CCDirector sharedDirector] replaceScene:scene];
        }];
        
        CCSprite *autumn = [CCSprite spriteWithFile:@"autumn.png"];
        CCSprite *autumned = [CCSprite spriteWithFile:@"autumn.png"];
        CCMenuItemSprite *item2 = [CCMenuItemSprite itemWithNormalSprite:autumn selectedSprite:autumned block:^(id sender) {
            HelloWorldScene *scene = [HelloWorldScene node];
            scene.layer.sceneNum = 3;
            [[CCDirector sharedDirector] replaceScene:scene];
        }];
        
        CCSprite *winter = [CCSprite spriteWithFile:@"winter.png"];
        CCSprite *wintered = [CCSprite spriteWithFile:@"winter.png"];
        CCMenuItemSprite *item3 = [CCMenuItemSprite itemWithNormalSprite:winter selectedSprite:wintered block:^(id sender) {
            HelloWorldScene *scene = [HelloWorldScene node];
            scene.layer.sceneNum = 4;
            [[CCDirector sharedDirector] replaceScene:scene];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:item,item1, nil];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        menu.position = ccp(winSize.width * 0.5f, winSize.height * 0.7f);
        [menu alignItemsHorizontallyWithPadding:30];
        [self addChild:menu];
        
        CCMenu *menu1 = [CCMenu menuWithItems:item2,item3, nil];
        menu1.position = ccp(winSize.width * 0.5f, winSize.height * 0.25f);
        [menu1 alignItemsHorizontallyWithPadding:30];
        [self addChild:menu1];
    }
    return self;
    
}

- (void)dealloc {

    [super dealloc];
    
}

@end
