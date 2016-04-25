//
//  VIewPagerScrollView.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol XGViewPagerScrollViewDelegate <NSObject>

//当前手势是否可用于滑动;(用于某些touch坐标上中断左右切换操作)
-(BOOL) xgViewPagerScrollView_CanTouchMoveWithPanGesture:(UIGestureRecognizer*)panGesture;

@end

@interface XGViewPagerScrollView : UIScrollView

@property (weak, nonatomic) id<XGViewPagerScrollViewDelegate> xgViewPagerScrollViewDelegate;
@property (assign, nonatomic) BOOL canStopTouchMove;

@end
