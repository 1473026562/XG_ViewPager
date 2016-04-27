//
//  CustomViewPagerCell.m
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//  github:https://github.com/jiaxiaogang/XG_ViewPager
//

#import "CustomViewPagerCell.h"


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface CustomViewPagerCell ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong,nonatomic) NSMutableArray *datas;

@end

@implementation CustomViewPagerCell

/**
 *  MARK:--------------------init--------------------
 */
-(id) initWithFrame:(CGRect)frame withHeaderHeight:(CGFloat)height{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewWithHeaderHeight:height];
        [self initData];
        [self initDisplay];
    }
    return self;
}


-(void)initViewWithHeaderHeight:(CGFloat)height{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.tableView];
    
    self.header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    [self.header setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:self.header];
}

-(void) initData{
    self.datas = [[NSMutableArray alloc] init];
}

-(void)initDisplay{
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

/**
 *  MARK:--------------------setData & refreshDisplay--------------------
 */
-(void) setData:(NSMutableArray *)datas
{
    if (datas && [datas isKindOfClass:[NSArray class]]) {
        [self.datas addObjectsFromArray:datas];
    }
    [self refreshDisplay];
}

-(void) refreshDisplay{
    [self.tableView reloadData];
}

/**
 *  MARK:--------------------TableViewDataSource和TableViewDelegate--------------------
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.datas objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [lab setText:title];
    [cell addSubview:lab];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  MARK:--------------------UIScrollViewDelegate--------------------
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.customViewPagerCellDelegate != nil && [self.customViewPagerCellDelegate respondsToSelector:@selector(customViewPagerCell_didScroll:)]){
        [self.customViewPagerCellDelegate customViewPagerCell_didScroll:scrollView];
    }
}

@end
