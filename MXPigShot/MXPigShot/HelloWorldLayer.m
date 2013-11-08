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
        _targets = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
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
    [self schedule:@selector(update:)];
	return self;
}

- (void)gameLogic:(id)sender{
    [self addTarget];
}

-(void)addTarget {
    CCSprite *target = [CCSprite spriteWithFile:@"enemy.png"
                                           rect:CGRectMake(0, 0, 27, 40)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int actualx = (arc4random() % ((int)winSize.width/3)) + winSize.width*2/3;
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(actualx, winSize.height);
    target.tag = 1;
    [_targets addObject:target];
    [self addChild:target];
    
    // Determine speed of the target
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(actualx, 0)];
    id actionMoveOther = [CCCallFuncN actionWithTarget:self selector:@selector(actionMoveOther:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveOther, nil]];

}

- (void)actionMoveOther:(id)sender{
    CCSprite *sprite = (CCSprite *)sender;
    // Determine speed of the target
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(0, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                                 selector:@selector(spriteMoveFinished:)];
    [sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    if (sprite.tag == 1) { // target
        [_targets removeObject:sprite];
        GameOverScene *gameOverScene = [GameOverScene node];
        [gameOverScene.layer.label setString:@"You Lose :["];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    } else if (sprite.tag == 2) { // projectile
        [_projectiles removeObject:sprite];
    }
    [self removeChild:sprite cleanup:YES];
}

//  抛物线
//mSprite：需要做抛物线的精灵
//startPoint:起始位置
//endPoint:中止位置
//dirTime:起始位置到中止位置的所需时间
- (void) moveWithParabola:(CCSprite*)mSprite startP:(CGPoint)startPoint endP:(CGPoint)endPoint dirTime:(float)time{
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex =endPoint.x+50;
    float ey =endPoint.y+150;
    int h = [mSprite contentSize].height*0.5;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200); //控制点
    bezier.endPosition = ccp(endPoint.x-30, endPoint.y+h); // 结束位置
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:time bezier:bezier];
    [mSprite runAction:actionMove];
}


//  抛物线运动并同时旋转
//mSprite：需要做抛物线的精灵
//startPoint:起始位置
//endPoint:中止位置
//startA:起始角度
//endA:中止角度
//dirTime:起始位置到中止位置的所需时间
- (void) moveWithParabola:(CCSprite*)mSprite startP:(CGPoint)startPoint endP:(CGPoint)endPoint startA:(float)startAngle endA:(float)endAngle dirTime:(float)time{
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex =endPoint.x+50;
    float ey =endPoint.y+150;
    int h = [mSprite contentSize].height*0.5;
    //设置精灵的起始角度
    mSprite.rotation=startAngle;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200); //控制点
    bezier.endPosition = ccp(endPoint.x-30, endPoint.y+h); // 结束位置
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:time bezier:bezier];
    //创建精灵旋转的动作
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:time angle:endAngle];
    //将两个动作封装成一个同时播放进行的动作
    CCAction * action = [CCSpawn actions:actionMove, actionRotate, nil];
    [mSprite runAction:action];
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
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    [self addChild:projectile];
    

    CGPoint realDest = ccp(winSize.width, location.y);
    
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = winSize.width/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], nil]];
    
}

- (void)update:(ccTime)dt {
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        CGRect projectileRect = CGRectMake(
                                           projectile.position.x - (projectile.contentSize.width/2),
                                           projectile.position.y - (projectile.contentSize.height/2),
                                           projectile.contentSize.width,
                                           projectile.contentSize.height);
        
        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *target in _targets) {
            CGRect targetRect = CGRectMake(
                                           target.position.x - (target.contentSize.width/2),
                                           target.position.y - (target.contentSize.height/2),
                                           target.contentSize.width,
                                           target.contentSize.height);
            
            if (CGRectIntersectsRect(projectileRect, targetRect)) {
                [targetsToDelete addObject:target];
            }
        }
        
        for (CCSprite *target in targetsToDelete) {
            [_targets removeObject:target];
            [self removeChild:target cleanup:YES];
            _projectilesDestroyed++;
            if (_projectilesDestroyed > 50) {
                GameOverScene *gameOverScene = [GameOverScene node];
                [gameOverScene.layer.label setString:@"You Win!"];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
                
            }
        }
        
        if (targetsToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }
        [targetsToDelete release];
        
    }
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
    
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [_targets release];
    _targets = nil;
    [_projectiles release];
    _projectiles = nil;
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
