//
//  CustomViewPagerCell.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import "XGViewPagerCell.h"

@protocol CustomViewPagerCellDelegate <NSObject>

-(void)customViewPagerCell_didScroll:(UIScrollView*)scrollView;

@end

@interface CustomViewPagerCell : XGViewPagerCell

@property (weak, nonatomic) id<CustomViewPagerCellDelegate> customViewPagerCellDelegate;
-(id) initWithFrame:(CGRect)frame withHeaderHeight:(CGFloat)height;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *header;
-(void) setData:(NSMutableArray *)datas;

@end
