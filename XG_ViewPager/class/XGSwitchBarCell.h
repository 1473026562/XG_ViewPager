//
//  SwitchBarCell.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XGSwitchBarCell;
@protocol XGSwitchBarCellDelegate <NSObject>
@optional

/**
 *  MARK:--------------------switchBarCell OnClick--------------------
 *  #if onclick switchBar's Cell will dothismethod;MyEnglishIsVeryGood;^_^!!!
 *  params:animated is not valid;
 */
- (void)xgSwitchBarCell:(XGSwitchBarCell*)cell clickIndex:(NSInteger)index animated:(BOOL)animated;
@end



/**
 *  MARK:--------------------viewPagerSwitchBarItem父类--------------------
 */

@interface XGSwitchBarCell : UIView

/**
 *  MARK:--------------------实现可选中的属性--------------------
 */
@property (assign, nonatomic) BOOL selected;                        //选中状态
@property (nonatomic , assign)   NSInteger   index;                 //下标
@property (weak, nonatomic) id<XGSwitchBarCellDelegate> delegate;   //静态代理

@end
