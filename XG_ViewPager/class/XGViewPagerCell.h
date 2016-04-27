//
//  ViewPagerCell.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//  github:https://github.com/jiaxiaogang/XG_ViewPager
//

#import <UIKit/UIKit.h>

/**
 *  MARK:--------------------ViewPagerCell类似于UITableViewCell--------------------
 */
@interface XGViewPagerCell : UIView


-(id) initWithFrame:(CGRect)frame withContentView:(UIView*)contentView;
@property (strong,readonly) UIView *contentView;


@end
