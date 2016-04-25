//
//  ViewPagerCell.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGViewPagerCell : UIView


-(id) initWithFrame:(CGRect)frame withContentView:(UIView*)contentView;
@property (strong,readonly) UIView *contentView;


@end
