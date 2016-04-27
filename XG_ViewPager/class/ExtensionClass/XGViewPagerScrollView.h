//
//  VIewPagerScrollView.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//  github:https://github.com/jiaxiaogang/XG_ViewPager
//


#import <UIKit/UIKit.h>

/**
 *  MARK:--------------------自定义viewPager用的scrollView--------------------
 *  用于scrollView的一些手势拦截功能;
 */
@protocol XGViewPagerScrollViewDelegate <NSObject>

/**
 *  MARK:--------------------当前手势是否可用于滑动;(用于某些touch坐标上中断左右切换操作)--------------------
 */
-(BOOL) xgViewPagerScrollView_CanTouchMoveWithPanGesture:(UIGestureRecognizer*)panGesture;

@end

@interface XGViewPagerScrollView : UIScrollView

@property (weak, nonatomic) id<XGViewPagerScrollViewDelegate> xgViewPagerScrollViewDelegate;

/**
 *  MARK:--------------------是否打开拦截功能--------------------
 *  默认为false不拦截;
 */
@property (assign, nonatomic) BOOL canStopTouchMove;

@end
