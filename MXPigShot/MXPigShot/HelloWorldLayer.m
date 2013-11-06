//
//  HelloWorldLayer.m
//  MXPigShot
//
//  Created by longquan on 13-11-5.
//  Copyright longquan 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize pSprite;
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        float imageW = 200.0;
        float imageH = 150.0;
        CGSize size = [[CCDirector sharedDirector] winSize];
        //添加草地的背景图
		CCSprite *bgSprite = [CCSprite spriteWithFile:@"bg.jpg" rect:CGRectMake(0, 0, imageW/2, imageH/2)];
        float winw = size.width*2/imageW;
        float winy = size.height*2/imageH;
        bgSprite.scaleX = winw;
        bgSprite.scaleY = winy;
        bgSprite.position = ccp(size.width/2,size.height/2);
        [self addChild:bgSprite];
        //添加射击对象
        pSprite = [CCSprite spriteWithFile:@"people.png" rect:CGRectMake(0, 0, 27, 40)];
        pSprite.position = ccp(pSprite.contentSize.width/2, pSprite.contentSize.height/2);
        [self addChild:pSprite];
        //开启屏幕点击事件接受
        self.touchEnabled = YES;
	}
    //定时添加目标
    [self schedule:@selector(gameLogic:) interval:1.0];
	return self;
}

- (void)gameLogic:(id)sender{
    [self addTarget];
}

-(void)addTarget {
    CCSprite *target = [CCSprite spriteWithFile:@"enemy.png"
                                           rect:CGRectMake(0, 0, 27, 40)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];
    
    // Determine speed of the target
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}

-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    //根据触摸点 调整射击者的位置
    pSprite.position = ccp(pSprite.contentSize.width/2, location.y);
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"war.png"
                                               rect:CGRectMake(0, 0, 20, 20)];
    projectile.position = ccp(20, location.y);
    [self addChild:projectile];
    

    CGPoint realDest = ccp(winSize.width, location.y);
    
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = winSize.width/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], nil]];
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
