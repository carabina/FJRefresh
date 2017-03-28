//
//  PeapotRefreshHeader.m
//  FJRefresh
//
//  Created by Jeff on 2017/2/17.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "PeapotRefreshHeader.h"

#define Round_W 20.0
#define Round_H 20.0
#define COLOR_666666 [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]
#define COLOR_F3F3F9 [UIColor colorWithRed:(243.0/255.0) green:(243.0/255.0) blue:(249.0/255.0) alpha:1.0]

@interface PeapotRefreshHeader()

@property (assign, nonatomic) CGFloat startRadius;
@property (strong, nonatomic) CAShapeLayer *roundLayer;
@property (strong, nonatomic) CAShapeLayer *arcLayer;

@end

@implementation PeapotRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    [self.layer addSublayer:self.roundLayer];
    [self.roundLayer addSublayer:self.arcLayer];
}

// 圆
- (CAShapeLayer*)roundLayer {
    if(!_roundLayer) {
        
        CGPoint arcCenter = CGPointMake(Round_W/2.0, Round_W/2.0);
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Round_W/2.0, Round_H/2.0) radius:9.0 startAngle:(CGFloat)(0.0) endAngle:(CGFloat) (2*M_PI) clockwise:YES];
        
        _roundLayer = [CAShapeLayer layer];
        _roundLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        _roundLayer.contentsScale = [[UIScreen mainScreen] scale];
        _roundLayer.fillColor = [UIColor clearColor].CGColor;
        _roundLayer.strokeColor = COLOR_666666.CGColor;
        _roundLayer.lineWidth = 1.5;
        _roundLayer.lineCap = kCALineCapRound;
        _roundLayer.lineJoin = kCALineJoinBevel;
        _roundLayer.path = smoothedPath.CGPath;
    }
    return _roundLayer;
}

/**
 *  弧
 */
- (CAShapeLayer*)arcLayer {
    if(!_arcLayer) {
        
        CGPoint arcCenter = CGPointMake(Round_W/2.0, Round_W/2.0);
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Round_W/2.0, Round_H/2.0) radius:9.0 startAngle:(CGFloat)(0.0) endAngle:(CGFloat) (30*M_PI/180) clockwise:YES];
        
        _arcLayer = [CAShapeLayer layer];
        _arcLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        _arcLayer.contentsScale = [[UIScreen mainScreen] scale];
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.strokeColor = COLOR_F3F3F9.CGColor;
        _arcLayer.lineWidth = 2.0;
        _arcLayer.lineCap = kCALineCapRound;
        _arcLayer.lineJoin = kCALineJoinBevel;
        _arcLayer.path = smoothedPath.CGPath;
    }
    return _arcLayer;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.roundLayer.position = CGPointMake(self.mj_w*0.5, self.mj_h*0.5);
    self.arcLayer.position = CGPointMake(Round_W*0.5, Round_H*0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    // NSLog(@"----:%zd",self.state);
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:{
            if (oldState == MJRefreshStateRefreshing) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self stopAnimating];
                });
            }else {
                [self stopAnimating];
            }
            break;
        }
        case MJRefreshStatePulling:
            
            break;
        case MJRefreshStateRefreshing:
            [self startAnimating];
            break;
        default:
            break;
    }
    
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    // NSLog(@"+++%zd : %f", self.state, pullingPercent);
    if (self.state == MJRefreshStateIdle && pullingPercent == 0.0) {
        return;
    }
    _arcLayer.transform = CATransform3DMakeRotation(-pullingPercent*M_PI, 0, 0, 1);
    if (pullingPercent != 1) {
        self.startRadius = -pullingPercent*M_PI;
    }
}

- (void)startAnimating
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation.duration = 0.5;
    theAnimation.removedOnCompletion = NO;
    theAnimation.repeatCount = MAXFLOAT;
    theAnimation.fromValue = [NSNumber numberWithFloat:self.startRadius];
    theAnimation.toValue = [NSNumber numberWithFloat:self.startRadius+M_PI*2];
    [self.arcLayer addAnimation:theAnimation forKey:@"animateTransform"];
}

- (void)stopAnimating
{
    self.startRadius = 0.0;
    self.arcLayer.transform = CATransform3DIdentity;
    [self.arcLayer removeAllAnimations];
}

@end
