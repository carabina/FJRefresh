//
//  PeapotRefreshBackFooter.m
//  FJRefresh
//
//  Created by Jeff on 2017/3/28.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "PeapotRefreshBackFooter.h"

#define Round_W 20.0
#define Round_H 20.0
#define COLOR_666666 [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]
#define Default_Xib @"BottomView"
#define Default_FOOTER_HEIGHT 50.0

@interface PeapotRefreshBackFooter()

@property (nonatomic, strong) CAShapeLayer *roundLayer;
@property (nonatomic, strong) CAShapeLayer *arcLayer;
@property (nonatomic, assign) CGFloat startRadius;
@property (nonatomic, strong) UIView       *hintView;
@property (nonatomic, copy)   NSString     *hintViewXibName;

@end

@implementation PeapotRefreshBackFooter

#pragma mark - 构造方法
+ (instancetype)footerWithHintViewXib:(NSString*)xibName hintViewHeight:(CGFloat)height refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    [self setXibName:xibName];
    [self setXibHeight:height];
    PeapotRefreshBackFooter *footer  = [super footerWithRefreshingBlock:refreshingBlock];
    return footer;
}

+ (instancetype)footerWithHintViewXib:(NSString*)xibName hintViewHeight:(CGFloat)height refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock alwaysShowHintView:(BOOL)alwaysShowHintView {
    [self setXibName:xibName];
    [self setXibHeight:height];
    [self setAlwayShowHintView:alwaysShowHintView];
    PeapotRefreshBackFooter *footer  = [super footerWithRefreshingBlock:refreshingBlock];
    return footer;
}

#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = [[self class] getXibHeight];
    
    [self addSubview:self.hintView];
    [self.layer addSublayer:self.roundLayer];
    [self.roundLayer addSublayer:self.arcLayer];
}

// 圆
- (CAShapeLayer*)roundLayer {
    if(!_roundLayer) {
        
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Round_W/2.0, Round_H/2.0)
                                                                    radius:9.0
                                                                startAngle:(CGFloat)(0.0)
                                                                  endAngle:(CGFloat)(2 * M_PI)
                                                                 clockwise:YES];
        
        _roundLayer = [CAShapeLayer layer];
        _roundLayer.frame = CGRectMake(0.0f, 0.0f, Round_W, Round_H);
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

// 弧
- (CAShapeLayer*)arcLayer {
    if(!_arcLayer) {
        
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Round_W/2.0, Round_H/2.0) radius:9.0 startAngle:(CGFloat)(0.0) endAngle:(CGFloat) (30*M_PI/180) clockwise:YES];
        
        _arcLayer = [CAShapeLayer layer];
        _arcLayer.frame = CGRectMake(0.0f, 0.0f, Round_W, Round_H);
        _arcLayer.contentsScale = [[UIScreen mainScreen] scale];
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.strokeColor = [UIColor whiteColor].CGColor;
        _arcLayer.lineWidth = 2.0;
        _arcLayer.lineCap = kCALineCapRound;
        _arcLayer.lineJoin = kCALineJoinBevel;
        _arcLayer.path = smoothedPath.CGPath;
    }
    return _arcLayer;
}

// HintView
- (UIView *)hintView {
    if (!_hintView) {
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _hintView = [[bundle loadNibNamed:[[self class] getXibName] owner:nil options:nil] lastObject];
        _hintView.hidden = YES;
    }
    return _hintView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.hintView.frame = self.bounds;
    self.roundLayer.position = CGPointMake(self.mj_w/2.0, self.mj_h/2.0);
    self.arcLayer.position = CGPointMake(Round_W/2.0, Round_H/2.0);
    
    if ([[self class] getAlwayShowHintView] == NO) {
        if (self.frame.origin.y < self.superview.frame.size.height - [[self class] getXibHeight]) {
            self.hintView.hidden = YES;
        }
    }
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
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.roundLayer.hidden = YES;
            self.hintView.hidden = YES;
            [self stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            if (self.hintView.hidden) {
                self.roundLayer.hidden = NO;
            }
            [self startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            [self stopAnimating];
            self.roundLayer.hidden = YES;
            if ([[self class] getAlwayShowHintView]) {
                self.hintView.hidden = NO;
            }else{
                if (self.frame.origin.y >= self.superview.frame.size.height - [[self class] getXibHeight]) {
                    self.hintView.hidden = NO;
                }else{
                    self.hintView.hidden = YES;
                }
            }
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


#pragma mark -- animation
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

// 重置状态
- (void)resetFooterState
{
    self.state = MJRefreshStateIdle;
}

// 隐藏HintView
- (void)endRefreshingWithNoMoreDataNoHint {
    self.roundLayer.hidden = YES;
    self.hintView.hidden = YES;
}

// 设置HintView的Xib名称
+ (void)setXibName:(NSString *)xibName {
    objc_setAssociatedObject(self, @"xibName", xibName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSString *)getXibName {
    
    NSString *xibName = objc_getAssociatedObject(self, @"xibName");
    if (xibName == nil || xibName.length == 0) {
        return Default_Xib;
    }
    return xibName;
}

// 设置HintView的高度
+ (void)setXibHeight:(CGFloat)height {
    objc_setAssociatedObject(self, @"xibHeight", [NSNumber numberWithFloat:height], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)getXibHeight {
    
    CGFloat height = [objc_getAssociatedObject(self, @"xibHeight") floatValue];
    if (height < 1) {
        return Default_FOOTER_HEIGHT;
    }
    return height;
}

// 设置是否在没滑到一屏幕的时候显示HintView
+ (void)setAlwayShowHintView:(BOOL)alwayShowHintView {
    objc_setAssociatedObject(self, @"alwayShowHintView", [NSNumber numberWithBool:alwayShowHintView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)getAlwayShowHintView {
    return [objc_getAssociatedObject(self, @"alwayShowHintView") boolValue];
}

@end
