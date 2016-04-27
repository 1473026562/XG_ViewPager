//
//  ViewPagerCell.m
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//  github:https://github.com/jiaxiaogang/XG_ViewPager
//

#import "XGViewPagerCell.h"

@implementation XGViewPagerCell



-(id) initWithFrame:(CGRect)frame withContentView:(UIView*)contentView{
    self = [super initWithFrame:frame];
    if (self) {
        if (contentView) {
            _contentView = contentView;
            [self addSubview:contentView];
        }
    }
    return self;
}



@end
