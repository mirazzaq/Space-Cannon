//
//  GameScene.m
//  Space Canon
//
//  Created by M Irfan on 24/10/2014.
//  Copyright (c) 2014 NTES. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene{
    SKNode *_mainLayer;
    SKSpriteNode *_cannon;
    SKSpriteNode *_bg;
    BOOL _didShoot;
    
}

static const CGFloat SHOOT_SPEED = 1000.0f;

static inline CGVector radiansToVector(CGFloat radians){
    CGVector vector;
    vector.dx = cosf(radians);
    vector.dy = sinf(radians);
    return vector;
}
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //turn off gravity
    self.size = view.bounds.size;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    //self.backgroundColor = [SKColor blackColor];
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Starfield"];
    background.position =  CGPointZero;//CGPointMake(self.size.width * .5, self.size.height * .5);
    background.anchorPoint = CGPointZero;
    background.blendMode = SKBlendModeReplace;
    [self addChild:background];
    
    //add edges
    SKNode *leftEdge = [[SKNode alloc] init];
    leftEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(0.0, self.size.height)];
    leftEdge.position = CGPointZero;
    [self addChild:leftEdge];
    
    SKNode *rightEdge = [[SKNode alloc] init];
    rightEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(0.0, self.size.height)];
    rightEdge.position = CGPointMake(self.size.width, 0.0);
    [self addChild:rightEdge];
    
    
    //add main layer
    _mainLayer = [[SKNode alloc] init];
    [self addChild:_mainLayer];
    
    //add cannon
    _cannon = [SKSpriteNode spriteNodeWithImageNamed:@"Cannon"];
    _cannon.position = CGPointMake(self.size.width * .5, 0.0);
    [_mainLayer addChild:_cannon];
    
    //create cannon rotate action.
    SKAction *rotateCannon = [SKAction sequence:@[[SKAction rotateByAngle:M_PI duration:2],[SKAction rotateByAngle:-M_PI duration:2]]];
    [_cannon runAction:[SKAction repeatActionForever:rotateCannon]];
    
}
-(void) shoot{
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
    ball.name = @"ball";
    CGVector rotationVector = radiansToVector(_cannon.zRotation);
    ball.position = CGPointMake(_cannon.position.x + (_cannon.size.width * .5 * rotationVector.dx),
                                _cannon.position.y + (_cannon.size.width * .5 * rotationVector.dy));
    //ball.zPosition =2;
    [_mainLayer addChild:ball];
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:6.0];
    ball.physicsBody.velocity = CGVectorMake(rotationVector.dx * SHOOT_SPEED, rotationVector.dy * SHOOT_SPEED);
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //[self shoot];
        _didShoot = YES;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}
-(void)didSimulatePhysics{
    if (_didShoot) {
        [self shoot];
        _didShoot = NO;
    }
    [_mainLayer enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop){
        if(!CGRectContainsPoint(self.frame, node.position)){
            [node removeFromParent];
        }
    }];
}

@end
