//
//  XGViewPager.m
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//  github:https://github.com/jiaxiaogang/XG_ViewPager
//

#import "XGViewPager.h"


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@interface XGViewPager ()<UIScrollViewDelegate , XGViewPagerDelegate,XGViewPagerScrollViewDelegate>
{
    NSInteger                            _currentPageIndex;     //当前页下标
    BOOL                                 _isClickSwitch;        //是否单击切换页
    CGFloat                              _lastTouchX;           //上次触摸坐标
}
@property (strong,nonatomic) NSMutableArray *viewArr;

@end

@implementation XGViewPager

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
        [self initData];
    }
    return self;
}

- (void)setDelegate:(id<XGViewPagerDelegate>)delegate{
    _delegate = delegate;
    [self addContentViewToContainerView];
}

/**
 *  MARK:--------------------刷新显示--------------------
 */
- (void)reloadData{
    [self addContentViewToContainerView];
}


/**
 *  MARK:--------------------初始化UI--------------------
 */
- (void)initView{
    _containerView = [[XGViewPagerScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.delegate = self;
    _containerView.pagingEnabled = YES;
    _containerView.scrollsToTop = NO;
    _containerView.xgViewPagerScrollViewDelegate = self;
    
    [self addSubview:_containerView];
}

-(void) initData{
    self.viewArr = [[NSMutableArray alloc]init];
}

/**
 *  MARK:--------------------添加tableView到viewPager--------------------
 */
- (void)addContentViewToContainerView{
    if(self.viewArr){
        for(NSInteger i = 0; i < self.viewArr.count; i++){
            XGViewPagerCell * contentView = self.viewArr[i];
            if([_containerView.subviews containsObject:contentView]){
                [contentView removeFromSuperview];
            }
            contentView = nil;
        }
        [self.viewArr removeAllObjects];
    }
    
    //生成view
    NSInteger  viewCount = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfCellsXGViewPager:)]) {
        viewCount = [self.delegate numberOfCellsXGViewPager:self];
    }
    for (NSInteger i = 0; i < viewCount; i++) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager:cellFor:)]) {
            XGViewPagerCell *item = [self.delegate xgViewPager:self cellFor:i];
            item.tag = i + 1;
            CGRect frame = item.frame;
            frame.origin = CGPointMake(i * self.frame.size.width, 0.0);
            frame.size = CGSizeMake(self.frame.size.width, _containerView.frame.size.height);
            item.frame = frame;
            [_containerView addSubview:item];
            [self.viewArr addObject:item];
        }
    }
    _containerView.contentSize = CGSizeMake(viewCount * self.frame.size.width, 0.0);
    if(_currentPageIndex > self.viewArr.count - 1){
        _currentPageIndex = self.viewArr.count - 1;
    }
    [_containerView setContentOffset:CGPointMake(_currentPageIndex * self.frame.size.width, 0.0) animated:NO];
    
}

/**
 *  MARK:--------------------UIScrollViewDelegate--------------------
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_willChangePage)]) {
        [self.delegate xgViewPager_willChangePage];
    }
    _isClickSwitch = NO;
    _currentPageIndex = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2.0) / scrollView.frame.size.width) + 1;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_didScrollBegin:withPageIndex:)]) {
        [self.delegate xgViewPager_didScrollBegin:scrollView withPageIndex:_currentPageIndex];
    }
    
    //记录坐标
    _lastTouchX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //isClickSwitch开关;在animationEnd的时候已经是No了;所以就算点击switchBar这里也会执行一次;这个以后改;
    if(!_isClickSwitch){
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_didScrollMove:)]) {
            [self.delegate xgViewPager_didScrollMove:scrollView];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_willDisplayCell:forIndex:willNoDisplayCell:forIndex:)])
        {
            CGFloat deltaX = scrollView.contentOffset.x - _lastTouchX;
            //CGPoint ori = [scrollView.panGestureRecognizer velocityInView:scrollView];
            if (deltaX > 0) {
                //1,向左滑取上桢右边view
                int oldRIndex = (_lastTouchX + self.frame.size.width - 0.01f) / self.frame.size.width;
                //2,取本桢右边view
                int newRIndex = (scrollView.contentOffset.x + self.frame.size.width - 0.01f) / self.frame.size.width;
                if (newRIndex > oldRIndex && oldRIndex >= 0 && newRIndex < self.viewArr.count) {
                    XGViewPagerCell *oldRView = [self.viewArr objectAtIndex:oldRIndex];
                    XGViewPagerCell *newRView = [self.viewArr objectAtIndex:newRIndex];
                    [self.delegate xgViewPager_willDisplayCell:newRView forIndex:newRIndex willNoDisplayCell:oldRView forIndex:oldRIndex];
                }
            }
            else {
                //1,向右滑取上桢左边view
                int oldLIndex = (_lastTouchX + 0.01f) / self.frame.size.width;
                //2,取本桢左边view
                int newLIndex = (scrollView.contentOffset.x + 0.01f) / self.frame.size.width;
                if (newLIndex < oldLIndex && newLIndex >= 0 && oldLIndex < self.viewArr.count) {
                    XGViewPagerCell *oldLView = [self.viewArr objectAtIndex:oldLIndex];
                    XGViewPagerCell *newLView = [self.viewArr objectAtIndex:newLIndex];
                    [self.delegate xgViewPager_willDisplayCell:newLView forIndex:newLIndex willNoDisplayCell:oldLView forIndex:oldLIndex];
                }
            }
            _lastTouchX = scrollView.contentOffset.x;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2.0) / scrollView.frame.size.width) + 1;
    _isClickSwitch = NO;
    if (_currentPageIndex != index) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_didChangePage:)]) {
            UIView  * contentView = self.viewArr[_currentPageIndex];
            [_containerView bringSubviewToFront:contentView];
            [self.delegate xgViewPager_didChangePage:index];
        }
    }
    _currentPageIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_didScrollStop:withPageIndex:)]) {
        [self.delegate xgViewPager_didScrollStop:scrollView withPageIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPageIndex = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2.0) / scrollView.frame.size.width) + 1;
    if(currentPageIndex != _currentPageIndex){
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_didChangePage:)]) {
            UIView  * contentView = self.viewArr[currentPageIndex];
            [_containerView bringSubviewToFront:contentView];
            [self.delegate xgViewPager_didChangePage:currentPageIndex];
        }
    }
    
    _currentPageIndex = currentPageIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_didScrollStop:withPageIndex:)]) {
        [self.delegate xgViewPager_didScrollStop:scrollView withPageIndex:currentPageIndex];
    }
    
}

/**
 *  MARK:--------------------自定义index的跳转--------------------
 */
- (void) setSelectWithIndex:(NSInteger)index animated:(BOOL)animated{
    _isClickSwitch = YES;
    
    if (abs(_currentPageIndex - index) <= 1) {
        [_containerView setContentOffset:CGPointMake(index * self.frame.size.width, 0.) animated:animated];
    } else {
        // This means we should "jump" over at least one view controller
        //        self.shouldObserveContentOffset = NO;
        BOOL scrollingRight = (index > _currentPageIndex);
        XGViewPagerCell *leftView = self.viewArr[MIN(_currentPageIndex, index)];
        XGViewPagerCell *rightView = self.viewArr[MAX(_currentPageIndex, index)];
        //此处重新frame时,scrollView会重置contentOffset.y = 0;所以给tableView抢套了一层父view
        //rightView.frame = CGRectMake(self.width, 0., self.width, _containerView.height);
        
        //向右
        if (scrollingRight) {
            CGRect frame = leftView.frame;
            frame.origin.x = (index - 1) * self.frame.size.width;
            leftView.frame = frame;
            _containerView.contentOffset = CGPointMake((index - 1) * self.frame.size.width, 0);
        } else {
            CGRect frame = rightView.frame;
            frame.origin.x = (index - 1) * self.frame.size.width;
            rightView.frame = frame;
            _containerView.contentOffset = CGPointMake((index + 1) * self.frame.size.width, 0.);
        }
        [_containerView setContentOffset:CGPointMake(index * self.frame.size.width, 0.) animated:YES];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            for (NSUInteger i = 0; i < self.viewArr.count; i++) {
                XGViewPagerCell *view = self.viewArr[i];
                view.frame = CGRectMake(i * self.frame.size.width, 0., self.frame.size.width, _containerView.frame.size.height);
                [_containerView addSubview:view];
            }
            _containerView.contentSize = CGSizeMake(self.frame.size.width * self.viewArr.count, 0);
            _containerView.userInteractionEnabled = YES;
        });
    }
    if (_currentPageIndex != index) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager_willChangePage)]) {
            XGViewPagerCell  * contentView = self.viewArr[index];
            [_containerView bringSubviewToFront:contentView];
            [self.delegate xgViewPager_willChangePage];
        }
    }
}

/**
 *  MARK:--------------------XGViewPagerScrollViewDelegate--------------------
 */
-(BOOL) xgViewPagerScrollView_CanTouchMoveWithPanGesture:(UIGestureRecognizer *)panGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(xgViewPager:loadCanChangeItemWithCurrentView:currentIndex:withGestureRecognizer:)]) {
        XGViewPagerCell  * contentView = self.viewArr[_currentPageIndex];
        return [self.delegate xgViewPager:self loadCanChangeItemWithCurrentView:contentView currentIndex:_currentPageIndex withGestureRecognizer:(UIGestureRecognizer *)panGesture];
    }
    return true;
}

-(void) setXGScrollViewCanStopTouchMove:(BOOL)canStopTouchMove{
    self.containerView.canStopTouchMove = canStopTouchMove;
}

/**
 *  MARK:--------------------获取所有views--------------------
 */
- (NSMutableArray*) getViewPagerAllViews{
    return self.viewArr;
}

- (XGViewPagerCell*) getViewWithIndex:(NSInteger)index{
    NSArray *views = [self getViewPagerAllViews];
    if (index >= 0 && index < views.count) {
        return [views objectAtIndex:index];
    }
    return nil;
}

- (NSUInteger)getCurrentPageIndex {
    return _currentPageIndex;
}

- (NSUInteger)getDisplayPageIndex{
    return floor((self.containerView.contentOffset.x - self.containerView.frame.size.width / 2.0) / self.containerView.frame.size.width) + 1;
}

@end
