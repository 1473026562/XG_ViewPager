//
//  ViewController.m
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import "ViewController.h"
#import "XGViewPager.h"
#import "XGViewPagerCell.h"
#import "XGSwitchBar.h"
#import "CustomViewPagerCell.h"
#import "CustomSwitchBarCell.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define HeaderHeight 300
#define TopSpace 20


@interface ViewController ()<XGViewPagerDelegate,XGSwitchBarDelegate,CustomViewPagerCellDelegate>

@property (strong,nonatomic) NSMutableArray *titleDatas;        //存所有将显示的表类型
@property (strong,nonatomic) XGViewPager  * viewPager;
@property (strong,nonatomic) UILabel *header;
@property (strong,nonatomic) XGSwitchBar *switchBar;                //顶部容器条

@end

@implementation ViewController

/**
 *  MARK:--------------------init--------------------
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [self initDisplay];
}

-(void) initView
{
    //1,header
    self.header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeaderHeight)];
    [self.header setText:@"这里是tableView的header,viewPager里有好多个tableView;但他们需要共用一个header;因为左右滑动的时候;我不想让他跟着来回跑!!"];
    [self.header setNumberOfLines:0];
    [self.header setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1]];
    [self.view addSubview:self.header];
    
    //2,switchBar
    self.switchBar = [[XGSwitchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 48) withDefaultSelectIndex:0];
    self.switchBar.visableCursor = true;
    self.switchBar.cursorHeight = 10;
    [self.view addSubview:self.switchBar];
    
    //3,viewPager
    self.viewPager = [[XGViewPager alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.viewPager setXGScrollViewCanStopTouchMove:true];
    [self.viewPager setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.viewPager];
    
    //4,statusBarBack
    UIView *statusBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [statusBack setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:1]];
    [self.view addSubview:statusBack];
}

-(void) initData{
    self.titleDatas = [NSMutableArray arrayWithObjects:@"赤臂生",@"生赤臂",@"赤生臂", nil];
}

-(void) initDisplay{
    [self.switchBar setDelegate:self];
    [self.viewPager setDelegate:self];
}

/**
 *  MARK:--------------------setData--------------------
 */

/**
 *  MARK:--------------------method--------------------
 */
-(void) setScrollsToTopForTv:(UITableView*)tv{
    //设置按下statusBar时跳到顶端;
    if (self.viewPager && [self.viewPager getViewPagerAllViews] && tv) {
        for (CustomViewPagerCell *cell in [self.viewPager getViewPagerAllViews]) {
            cell.tableView.scrollsToTop = [cell.tableView isEqual:tv];
        }
    }
}

/**
 *  MARK:--------------------XGSwitchBarDelegate--------------------
 */
- (XGSwitchBarCell*)xgSwitchBar:(XGSwitchBar *)switchBar cellForIndex:(NSInteger)index selected:(BOOL)selected
{
    CustomSwitchBarCell  * barItem = [[CustomSwitchBarCell alloc]init];
    int width = ScreenWidth / 5;
    if (self.titleDatas.count < 5) {
        width = ScreenWidth / self.titleDatas.count;
    }
    barItem.delegate = self;
    [barItem setFrame:CGRectMake(0, 0, width, 44)];
    barItem.index = index;
    [barItem setData:[self.titleDatas objectAtIndex:index]];
    barItem.selected = selected;
    [barItem setBackgroundColor:[UIColor colorWithRed:0.7 green:1 blue:0 alpha:1]];
    return barItem;
}

- (void)xgSwitchBar:(XGSwitchBar *)switchBar didSelectIndex:(NSInteger)index animated:(BOOL)animated
{
    switchBar.enable = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.switchBar.enable = true;
    });
    
    NSInteger curIndex = [self.viewPager getCurrentPageIndex];
    XGViewPagerCell *cell = [self.viewPager getViewWithIndex:curIndex];
    if (cell && curIndex != index) {
        UITableView *curTV = ((CustomViewPagerCell*)cell).tableView;
        CGFloat curPosY = curTV.contentOffset.y;
        //顶部出界值
        CGFloat topValue = self.header.frame.size.height - 48 - TopSpace;
        NSInteger delta = labs(index - curIndex);
        for (int i = 1; i <= delta; i++) {
            NSInteger targetIndex = curIndex + (index - curIndex)/delta * i;
            XGViewPagerCell *cell = [self.viewPager getViewWithIndex:targetIndex];
            if (cell) {
                UITableView *targetTV = ((CustomViewPagerCell*)cell).tableView;
                CGFloat targetPosY = targetTV.contentOffset.y;
                //curTV已滑致顶部
                if (curPosY > topValue) {
                    if (targetPosY < topValue) {
                        [targetTV setContentOffset:CGPointMake(0, topValue) animated:false];
                    }
                }else{
                    [targetTV setContentOffset:CGPointMake(0, curPosY) animated:false];
                }
            }
        }
    }
    
    [self.viewPager setSelectWithIndex:index animated:animated];
}

- (CGFloat)xgSwitchBar:(XGSwitchBar *)switchBar widthForIndex:(NSInteger)index
{
    if (self.titleDatas.count < 5) {
        return ScreenWidth / self.titleDatas.count;
    }
    return ScreenWidth / 5;
}
- (NSInteger)numberOfCellsInViewPagerSwitchBar:(XGSwitchBar *)switchBar
{
    return self.titleDatas.count;
}

/**
 *  MARK:--------------------XGViewPagerDelegate--------------------
 */
-(NSInteger) numberOfCellsXGViewPager:(XGViewPager*)viewPager
{
    return self.titleDatas.count;
}
-(XGViewPagerCell*) xgViewPager:(XGViewPager*)viewPager cellFor:(NSInteger)index
{
    CustomViewPagerCell *cell = [[CustomViewPagerCell alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withHeaderHeight:HeaderHeight];
    [cell setCustomViewPagerCellDelegate:self];
    [cell setData:[[NSMutableArray alloc]initWithObjects:@"QQ:283636001",@"微信:jia2764894",@"手机:就不告诉你",@"本人很帅",@"不服来辩", @"111",@"222",@"333",@"QQ:283636001",@"微信:jia2764894",@"手机:就不告诉你",@"本人很帅",@"不服来辩", @"111",@"222",@"333",@"QQ:283636001",@"微信:jia2764894",@"手机:就不告诉你",@"本人很帅",@"不服来辩", @"111",@"222",@"333",nil]];
    
    if (index == 0) {
        [cell.tableView.tableHeaderView addSubview:self.header];
        [self.switchBar removeFromSuperview];
        [cell.tableView addSubview:self.switchBar];
        CGRect frame = self.switchBar.frame;
        frame.origin.y = self.header.frame.size.height - 48;
        self.switchBar.frame = frame;
    }else{
        cell.tableView.scrollsToTop = false;
    }
    return cell;
}

- (BOOL)xgViewPager:(XGViewPager *)containerView loadCanChangeItemWithCurrentView:(XGViewPagerCell *)currentView
       currentIndex:(NSInteger)index withGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:((CustomViewPagerCell*)currentView).tableView];
    if (point.y > HeaderHeight) { 
        return true;
    }else{
        return false;
    }
}

-(void) xgViewPager_willDisplayCell:(XGViewPagerCell*)displayView forIndex:(NSInteger)displayIndex willNoDisplayCell:(XGViewPagerCell*)noDisplayView forIndex:(NSInteger)noDisplayIndex
{
    if (!noDisplayView || !displayView) {
        return;
    }
    UITableView *noDView = (((CustomViewPagerCell*)noDisplayView).tableView);
    UITableView *dView = (((CustomViewPagerCell*)displayView).tableView);
    CGFloat noDisplayY = noDView.contentOffset.y;
    CGFloat displayY = dView.contentOffset.y;
    //顶部出界值
    CGFloat topValue = HeaderHeight - 48 - TopSpace;
    //noDisplayView已滑致顶部(因为float精度;所以-0.1)
    if (noDisplayY > topValue - 0.1) {
        if (displayY < topValue) {
            [dView setContentOffset:CGPointMake(0, topValue) animated:false];
        }
    }else{
        [dView setContentOffset:CGPointMake(0, noDisplayY) animated:false];
    }
}

-(void) xgViewPager_willChangePage{
    //1,移动header到self.view
    CGRect headerRect = [self.view convertRect:self.header.frame fromView:self.header.superview];
    headerRect.origin.x = 0;
    [self.header removeFromSuperview];
    [self.view insertSubview:self.header belowSubview:self.viewPager];
    [self.header setFrame:headerRect];
    //2,移动containerBar到self.view
    CGRect barRect = [self.view convertRect:self.switchBar.frame fromView:self.switchBar.superview];
    barRect.origin.x = 0;
    if (barRect.origin.y < TopSpace) {
        barRect.origin.y = TopSpace;
    }
    [self.switchBar setFrame:barRect];
    [self.switchBar removeFromSuperview];
    [self.view addSubview:self.switchBar];
}

-(void) xgViewPager_didChangePage:(NSInteger)index{
    XGViewPagerCell *cell = [self.viewPager getViewWithIndex:index];
    if (cell != nil) {
        [self setScrollsToTopForTv:((CustomViewPagerCell*)cell).tableView];
    }
}

-(void) xgViewPager_didScrollBegin:(UIScrollView*)scrollView withPageIndex:(NSInteger)index
{
    CGPoint  ori = [scrollView.panGestureRecognizer velocityInView:scrollView];
    [self.switchBar beginChangeOffsetX:scrollView.contentOffset.x pageIndex:index oriX:ori.x];
}
-(void) xgViewPager_didScrollMove:(UIScrollView*)scrollView
{
    CGPoint  ori = [scrollView.panGestureRecognizer velocityInView:scrollView];
    [self.switchBar moveChangeOffsetX:scrollView.contentOffset.x oriX:ori.x];
}
-(void) xgViewPager_didScrollStop:(UIScrollView*)scrollView withPageIndex:(NSInteger)index
{
    [self.switchBar endChangeOffsetX:scrollView.contentOffset.x currentPageIndex:index];
    XGViewPagerCell *cell = [self.viewPager getViewWithIndex:index];
    if (cell) {
        UITableView *tv = ((CustomViewPagerCell*)cell).tableView;
        //1,添加header回tableView
        [self.header removeFromSuperview];
        [tv.tableHeaderView addSubview:self.header];
        [self.header setFrame:CGRectMake(0, 0, ScreenWidth, HeaderHeight)];
        //2,添加containerBar回tableView
        [self.switchBar removeFromSuperview];
        [tv addSubview:self.switchBar];
        //3,switchBar坐标
        CGRect frame = self.switchBar.frame;
        if (tv.contentOffset.y > HeaderHeight - 48 - TopSpace ) {
            frame.origin.y = TopSpace + tv.contentOffset.y;
        }else{
            frame.origin.y = HeaderHeight - 48;
        }
        self.switchBar.frame = frame;
        //4,switchBar高亮状态更新
        [self.switchBar setSelectedWithIndex:index];
    }
}


/**
 *  MARK:--------------------CustomViewPagerCellDelegate--------------------
 */
-(void) customViewPagerCell_didScroll:(UIScrollView *)scrollView{
    CGFloat posY = scrollView.contentOffset.y;
    //1,switchBar坐标
    if ([self.switchBar.superview isKindOfClass:[UITableView class]]) {
        CGRect frame = self.switchBar.frame;
        if(posY > HeaderHeight - 48 - TopSpace){
            frame.origin.y = TopSpace + posY;
        }else{
            frame.origin.y = HeaderHeight - 48;
        }
        self.switchBar.frame = frame;
    }
    //5,header坐标
    if ([self.header.superview isEqual:self.view]) {
        CGRect frame = self.header.frame;
        frame.origin.y = -posY;
        self.header.frame = frame;
    }
}


@end
