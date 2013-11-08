//
//  HelloWorldLayer.h
//  MXPigShot
//
//  Created by longquan on 13-11-5.
//  Copyright longquan 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameOverScene.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    @private CCSprite *pSprite;
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    int _projectilesDestroyed;
}
@property (retain, nonatomic) CCSprite *pSprite;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
