//
//  XGSwitchBar.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGSwitchBarCell.h"

/**
 *  MARK:--------------------XGSwitchBarDelegate--------------------
 */
@class XGSwitchBar;
@protocol  XGSwitchBarDelegate<NSObject>

@required
- (void)xgSwitchBar:(XGSwitchBar *)switchBar didSelectIndex:(NSInteger)index animated:(BOOL)animated; //clickIndex
- (XGSwitchBarCell*)xgSwitchBar:(XGSwitchBar *)switchBar cellForIndex:(NSInteger)index selected:(BOOL)selected;//cell获取
- (CGFloat)xgSwitchBar:(XGSwitchBar *)switchBar widthForIndex:(NSInteger)index;                       //cell宽度
- (NSInteger)numberOfCellsInViewPagerSwitchBar:(XGSwitchBar *)switchBar;                                     //cell个数


@end

@interface XGSwitchBar : UIView

@property (nonatomic , assign)id<XGSwitchBarDelegate>  delegate;
@property (strong,nonatomic) UIScrollView *containerBarItemView;    //容器项
@property (assign, nonatomic) BOOL enable;                          //点击开关
@property (nonatomic , assign) BOOL             visableCursor;     //游标是否可见
@property (nonatomic , assign) CGFloat          cursorHeight;      //游标高度

- (instancetype)initWithFrame:(CGRect)frame withDefaultSelectIndex:(NSInteger)defaultSelectIndex;

- (void)beginChangeOffsetX:(CGFloat)offsetX pageIndex:(NSInteger)pageIndex oriX:(CGFloat)oriX;

- (void)moveChangeOffsetX:(CGFloat)offsetX oriX:(CGFloat)oriX;

- (void)endChangeOffsetX:(CGFloat)offsetX currentPageIndex:(NSInteger)currentPageIndex;

- (void)updateContainer:(NSInteger)currentIndex;

- (void)updateContainerClickIndex:(NSInteger)index;

/**
 *  MARK:--------------------改变高亮下标--------------------
 */
-(void) setSelectedWithIndex:(NSInteger)index;


/**
 *  MARK:--------------------刷新UI--------------------
 */
- (void)reloadData;



@end
