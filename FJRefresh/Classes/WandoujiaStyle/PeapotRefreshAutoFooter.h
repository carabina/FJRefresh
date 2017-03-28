//
//  PeapotRefreshAutoFooter.h
//  FJRefresh
//
//  Created by Jeff on 2017/2/17.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>

@interface PeapotRefreshAutoFooter : MJRefreshAutoFooter

// 构造方法
+ (instancetype)footerWithHintViewXib:(NSString*)xibName hintViewHeight:(CGFloat)height refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

// 重置状态
- (void)resetFooterState;

// 隐藏HintView
- (void)endRefreshingWithNoMoreDataNoHint;

@end
