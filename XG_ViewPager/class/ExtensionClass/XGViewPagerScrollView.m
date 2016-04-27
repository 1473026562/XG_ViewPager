//
//  VIewPagerScrollView.m
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//  github:https://github.com/jiaxiaogang/XG_ViewPager
//

#import "XGViewPagerScrollView.h"

@implementation XGViewPagerScrollView

/**
 *  MARK:--------------------override super panGes--------------------
 *
 */
-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && self.xgViewPagerScrollViewDelegate
        && [self.xgViewPagerScrollViewDelegate respondsToSelector:@selector(xgViewPagerScrollView_CanTouchMoveWithPanGesture:)]
        && self.canStopTouchMove) {
        return [self.xgViewPagerScrollViewDelegate xgViewPagerScrollView_CanTouchMoveWithPanGesture:gestureRecognizer];
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

//当左滑时,如果当前scrollView在最左index==0时;再左滑不拦截controller.view手势;以使大多应用里的页面左滑返回功能有效;
- ( BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        UIPanGestureRecognizer *panGes = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint velocity = [panGes velocityInView:self];
//        if ([gestureRecognizer.view isEqual:self] && velocity.x > 0 && self.contentOffset.x <= 0 && ![otherGestureRecognizer.view isKindOfClass:[/*XGViewPagerCell.contentView*/ class]]) {
//            return true;
//        }
    }
    return false;
}

@end
