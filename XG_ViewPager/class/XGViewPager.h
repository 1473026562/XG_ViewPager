//
//  XGViewPager.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XGViewPagerScrollView.h"
#import "XGSwitchBar.h"
#import "XGSwitchBarCell.h"
#import "XGViewPagerCell.h"

@class XGViewPager;

@protocol  XGViewPagerDelegate<NSObject>

@required

/**
 *  MARK:--------------------是否允许当前手势切换页面--------------------
 */
- (BOOL)xgViewPager:(XGViewPager *)containerView loadCanChangeItemWithCurrentView:(XGViewPagerCell *)currentView currentIndex:(NSInteger)index withGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
/**
 *  MARK:--------------------建造viewPagerItem--------------------
 */
-(XGViewPagerCell*) xgViewPager:(XGViewPager*)viewPager cellFor:(NSInteger)index;
/**
 *  MARK:--------------------获取vierPagerItem总数--------------------
 */
-(NSInteger) numberOfCellsXGViewPager:(XGViewPager*)viewPager;
/**
 *  MARK:--------------------点击switchBar或者左右滑时;运行一次(未改变页面时,不执行)--------------------
 */
-(void) xgViewPager_willChangePage;

/**
 *  MARK:--------------------点击switchBar或者左右滑;惯性结束后;运行一次(未改变页面时,不执行)--------------------
 */
-(void) xgViewPager_didChangePage:(NSInteger)index;


/**
 *  MARK:--------------------开始滑动--------------------
 *  1,offsetX:坐标
 *  2,touchX:触摸坐标;用来调整switchBar的光标位置
 */
-(void) xgViewPager_didScrollBegin:(UIScrollView*)scrollView withPageIndex:(NSInteger)index;
-(void) xgViewPager_didScrollMove:(UIScrollView*)scrollView;
/**
 *  MARK:--------------------点击switchBar或者左右滑;惯性结束后;运行一次--------------------
 */
-(void) xgViewPager_didScrollStop:(UIScrollView*)scrollView withPageIndex:(NSInteger)index;



/**
 *  MARK:--------------------将要显示的tableView;从1跳转到3时,执行2次;--------------------
 */
-(void) xgViewPager_willDisplayCell:(XGViewPagerCell*)displayView forIndex:(NSInteger)displayIndex willNoDisplayCell:(XGViewPagerCell*)noDisplayView forIndex:(NSInteger)noDisplayIndex;


@end






@interface XGViewPager : UIView



@property (nonatomic , assign) id<XGViewPagerDelegate> delegate;
@property (strong,nonatomic) XGViewPagerScrollView *containerView;     //容器滚动器


- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  MARK:--------------------刷新显示--------------------
 */
- (void)reloadData;

/**
 *  MARK:--------------------设置左右切换页面的截断--------------------
 */
-(void) setXGScrollViewCanStopTouchMove:(BOOL)canStopTouchMove;

/**
 *  MARK:--------------------自定义index的跳转--------------------
 */
- (void) setSelectWithIndex:(NSInteger)index animated:(BOOL)animated;


/**
 *  MARK:--------------------获取所有views--------------------
 */
- (NSMutableArray*) getViewPagerAllViews;
- (XGViewPagerCell*) getViewWithIndex:(NSInteger)index;
- (NSUInteger)getCurrentPageIndex;
- (NSUInteger)getDisplayPageIndex;


@end