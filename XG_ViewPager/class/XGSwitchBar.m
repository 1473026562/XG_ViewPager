//
//  XGSwitchBar.m
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//


/**
 *  MARK:--------------------标题View--------------------
 *  这个类的代码是在@吴海超_上海 的一些代码基础上作了小小的改动;因为时间原因,并没有自己去重写;
 *  所以要感谢@吴海超_上海 大神给予我的灵感和指教,你永远都是我学习的榜样;
 */
#import "XGSwitchBar.h"


@interface XGSwitchBar ()<XGSwitchBarCellDelegate>{
    UIView                            * _cursorView;                 //游标
    NSInteger                           _barItemCount;               //项的总数
    NSInteger                           _currentBarItemIndex;        //当前选项下标
    NSMutableArray                    * _barItemWidthArray;          //item宽度
    CGFloat                             _barItemTotalWidth;          //item宽度
    CGFloat                             _currentCursorX;             //当前游标x
    NSInteger                           _pageIndex;                  //页下标
    BOOL                                _isLeft;                     //是否点击左边
    BOOL                                _isFristBarItem;             //是否是第一个item
    BOOL                                _isClickBarItem;             //是否点击item切换
}

@property (strong,nonatomic) UIView *topLine;
@property (strong,nonatomic) UIView *bottomLine;

@end

@implementation XGSwitchBar

/**
 *  MARK:--------------------init--------------------
 */
- (instancetype)initWithFrame:(CGRect)frame withDefaultSelectIndex:(NSInteger)defaultSelectIndex{
    self = [super initWithFrame:frame];
    if(self){
        [self initViewWithDefaultSelectIndex:defaultSelectIndex];
        [self initData];
    }
    return self;
}

- (void)initViewWithDefaultSelectIndex:(NSInteger)defaultSelectIndex{
    
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    //topLine
    self.topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    [self addSubview:self.topLine];
    
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 47, self.frame.size.width, 1)];
    [self addSubview:self.bottomLine];
    
    _currentBarItemIndex = defaultSelectIndex;
    CGRect   containerBarItemViewRC = self.bounds;
    
    containerBarItemViewRC.size.width = self.frame.size.width;
    _containerBarItemView = [[UIScrollView alloc]initWithFrame:containerBarItemViewRC];
    _containerBarItemView.showsHorizontalScrollIndicator = NO;
    _containerBarItemView.showsVerticalScrollIndicator = NO;
    _containerBarItemView.scrollEnabled = YES;
    _containerBarItemView.bounces = YES;
    _containerBarItemView.alwaysBounceHorizontal = YES;
    _containerBarItemView.alwaysBounceVertical = NO;
    _containerBarItemView.scrollsToTop = NO;
    
    [self reloadData];
    [self addSubview:_containerBarItemView];
}

-(void) initData{
    self.enable = true;
}

/**
 *  MARK:--------------------刷新UI--------------------
 */
- (void)reloadData{
    for (UIView * viewBack in _containerBarItemView.subviews) {
        for (XGSwitchBarCell *item in viewBack.subviews) {
            if([item isKindOfClass:[XGSwitchBarCell class]]){
                [item removeFromSuperview];
            }
        }
    }
    //_barItemCount = _containerBarParam.titlesArr.count;
    //1,cell个数
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfCellsInViewPagerSwitchBar:)]) {
        _barItemCount = [self.delegate numberOfCellsInViewPagerSwitchBar:self];
    }
    _barItemTotalWidth = 0;
    _barItemWidthArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _barItemCount; i++) {
        //2,cell宽度
        CGFloat barItemWidth = 80;
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgSwitchBar:widthForIndex:)]) {
            barItemWidth = [self.delegate xgSwitchBar:self widthForIndex:i];
        }
        
        [_barItemWidthArray addObject:@(barItemWidth)];
        //3,创建cell
        UIView *barItemBack = [[UIView alloc]initWithFrame:CGRectMake(_barItemTotalWidth, 1, barItemWidth, 46)];
        [_containerBarItemView addSubview:barItemBack];
        _barItemTotalWidth += barItemWidth;
        XGSwitchBarCell *barItem = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(xgSwitchBar:cellForIndex:selected:)]) {
            barItem = [self.delegate xgSwitchBar:self cellForIndex:i selected:_currentBarItemIndex == i];
        }
        if (barItem != nil) {
            barItem.delegate = self;
            [barItemBack addSubview:barItem];
        }
    }
    if(self.visableCursor){
        if(_cursorView){
            [_cursorView removeFromSuperview];
            _cursorView = nil;
        }
        XGSwitchBarCell * barItem = [self barItemWithIndex:_currentBarItemIndex];
        _currentCursorX = barItem.frame.origin.x ;
        _cursorView = [[UIView alloc]initWithFrame:CGRectMake(_currentCursorX, self.frame.size.height - self.cursorHeight, barItem.frame.size.width , self.cursorHeight)];
        _cursorView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        [_containerBarItemView addSubview:_cursorView];
    }
    [_containerBarItemView setContentSize:CGSizeMake(_barItemTotalWidth , 0.0)];
}

-(void) setDelegate:(id<XGSwitchBarDelegate>)delegate{
    _delegate = delegate;
    [self reloadData];
}


/**
 *  MARK:--------------------根据index获取barItem--------------------
 */
- (XGSwitchBarCell *)barItemWithIndex:(NSInteger)index{
    for (UIView * itemBack in _containerBarItemView.subviews) {
        for (XGSwitchBarCell *itemBase in itemBack.subviews) {
            if([itemBase isKindOfClass:[XGSwitchBarCell class]] && index == itemBase.index){
                return itemBase;
                break;
            }
        }
    }
    return nil;
}


/**
 *  MARK:--------------------左右同步滑动--------------------
 */
- (void)resetBarItemStateMaxIndex:(NSUInteger)index oriX:(CGFloat)oriX{
    NSInteger  count = index - 1;
    NSInteger  i = 0;
    if(oriX < 0.0){
    XG:
        for (i = 0; i < count; i++) {
            
        }
    }else if(oriX > 0){
        if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfCellsInViewPagerSwitchBar:)]) {
            count = [self.delegate numberOfCellsInViewPagerSwitchBar:self];//xxx
        }
        goto XG;
    }
}

- (void)beginChangeOffsetX:(CGFloat)offsetX pageIndex:(NSInteger)pageIndex oriX:(CGFloat)oriX{
    if(self.visableCursor ){
        _currentCursorX = _cursorView.frame.origin.x;
    }
    [self resetBarItemStateMaxIndex:offsetX / self.frame.size.width + 1 oriX:oriX];
}

- (void)moveChangeOffsetX:(CGFloat)offsetX oriX:(CGFloat)oriX{
    if(YES){
        _isLeft = NO;
        CGFloat sumItemWidth = _barItemTotalWidth / (_barItemCount - 1);
        CGFloat localOffsetX = offsetX * (sumItemWidth / self.frame.size.width);
        int pageIndex = offsetX / self.frame.size.width + 1;
        if(pageIndex <= 0){
            _isFristBarItem = YES;
            pageIndex = 1;
        }else{
            _isFristBarItem = NO;
        }
        
        _pageIndex = pageIndex - 1;
        float percent = fabs((localOffsetX - sumItemWidth * (pageIndex - 1)) / sumItemWidth);
        if(oriX < 0){
            _isLeft = YES;
        }else if (oriX > 0){
            _isLeft = NO;
        }
        if(_isLeft && ((int)offsetX % (int)self.frame.size.width) == 0){
            percent = 1.0;
            if(pageIndex > 1){
                pageIndex -= 1;
            }
        }
        UIView  * currentItemBack = [[self barItemWithIndex:pageIndex - 1] superview];
        
        CGFloat color_rate = percent;
        if(!_isLeft && _isFristBarItem){
            return;
        }
        
        UIView  * unknownItemBack = [[self barItemWithIndex:pageIndex] superview];
        if(!unknownItemBack) {
            return;
        }
        
        if(self.visableCursor){
            CGRect frame = _cursorView.frame;
            
            frame.origin.x = currentItemBack.frame.origin.x + (unknownItemBack.frame.origin.x - currentItemBack.frame.origin.x) * color_rate ;
            frame.size.width = currentItemBack.frame.size.width + (unknownItemBack.frame.size.width - currentItemBack.frame.size.width) * color_rate ;
            
            _cursorView.frame = frame;
        }
    }
}

- (void)endChangeOffsetX:(CGFloat)offsetX currentPageIndex:(NSInteger)currentPageIndex{
    _currentBarItemIndex = currentPageIndex;
    CGFloat widthLeft = 6;
    for (int i = 0; i < _currentBarItemIndex; i++) {
        widthLeft += [_barItemWidthArray[i] floatValue];
    }
    widthLeft += ([_barItemWidthArray[_currentBarItemIndex] floatValue] * 0.5f);
    
    if (_containerBarItemView.contentSize.width > _containerBarItemView.frame.size.width) {
        if (widthLeft <= _containerBarItemView.frame.size.width * 0.5f) {
            offsetX = 0.0;
        }
        else {
            if (_containerBarItemView.contentSize.width - widthLeft <= _containerBarItemView.frame.size.width * 0.5f) {
                offsetX = _containerBarItemView.contentSize.width - _containerBarItemView.frame.size.width;
            }
            else {
                offsetX = widthLeft - _containerBarItemView.frame.size.width * 0.5f;
            }
        }
    }
    else {
        offsetX = 0.0;
    }
    
    [_containerBarItemView setContentOffset:CGPointMake(offsetX, 0.0) animated:YES];
}

- (void)updateContainer:(NSInteger)currentIndex{
    _currentBarItemIndex = currentIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfCellsInViewPagerSwitchBar:)]) {
        NSInteger count = [self.delegate numberOfCellsInViewPagerSwitchBar:self];
        if (_currentBarItemIndex > count - 1) {
            _currentBarItemIndex = count - 1;
        }
    }
    
    [self updateContainerClickIndex:_currentBarItemIndex];
}

- (void)updateContainerClickIndex:(NSInteger)index{
    [self reloadData];
    XGSwitchBarCell  * tempBarItem = nil;
    for (XGSwitchBarCell  * item in _containerBarItemView.subviews) {
        if([item isKindOfClass:[XGSwitchBarCell class]]){
            if(item.index == index){
                tempBarItem = item;
            }
        }
    }
    [self xgSwitchBarCell:tempBarItem clickIndex:index animated:true];
}

/**
 *  MARK:--------------------XGSwitchBarCellDelegate--------------------
 */
-(void) xgSwitchBarCell:(XGSwitchBarCell *)barItem clickIndex:(NSInteger)index animated:(BOOL)animated{
    if (self.enable == false) {
        return;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(xgSwitchBar:didSelectIndex:animated:)]){
        [self.delegate xgSwitchBar:self didSelectIndex:index animated:animated];
    }
    _currentBarItemIndex = index;
    for (UIView * itemBack in _containerBarItemView.subviews) {
        for (XGSwitchBarCell *itemBar in itemBack.subviews) {
            if([itemBar isKindOfClass:[XGSwitchBarCell class]]){
                itemBar.selected = NO;
            }
        }
    }
    barItem.selected = YES;
    
    CGRect cursorViewRC = CGRectZero;
    if(self.visableCursor){
        cursorViewRC = _cursorView.frame;
        cursorViewRC.origin.x = barItem.superview.frame.origin.x ;
        cursorViewRC.size.width = barItem.superview.frame.size.width ;
    }
    
    CGFloat offsetX = 0;
    CGFloat widthLeft = 6;
    for (int i = 0; i < _currentBarItemIndex; i++) {
        widthLeft += [_barItemWidthArray[i] floatValue];
    }
    widthLeft += ([_barItemWidthArray[_currentBarItemIndex] floatValue] * 0.5f);
    if (_containerBarItemView.contentSize.width > _containerBarItemView.frame.size.width) {
        if (widthLeft <= _containerBarItemView.frame.size.width * 0.5f) {
            offsetX = 0.0;
        }
        else {
            if (_containerBarItemView.contentSize.width - widthLeft <= _containerBarItemView.frame.size.width * 0.5f) {
                offsetX = _containerBarItemView.contentSize.width - _containerBarItemView.frame.size.width;
            }
            else {
                offsetX = widthLeft - _containerBarItemView.frame.size.width * 0.5f;
            }
        }
    }
    else {
        offsetX = 0.0;
    }
    
    CGFloat  animatedDuring = 0.2f;
    if(!animated){
        animatedDuring = 0.0;
    }
    
    [UIView animateWithDuration:animatedDuring animations:^{
        if(self.visableCursor){
            _cursorView.frame = cursorViewRC;
        }
        [_containerBarItemView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    }completion:^(BOOL finished) {
        if(self.visableCursor){
            _currentCursorX = _cursorView.frame.origin.x;
        }
    }];
    
}


/**
 *  MARK:--------------------改变高亮下标--------------------
 */
-(void) setSelectedWithIndex:(NSInteger)index{
    _currentBarItemIndex = index;
    for (UIView * itemBack in _containerBarItemView.subviews) {
        for (XGSwitchBarCell *itemBar in itemBack.subviews) {
            if([itemBar isKindOfClass:[XGSwitchBarCell class]]){
                itemBar.selected = itemBar.index == index;
            }
        }
    }
}

-(NSMutableArray*) getSwitchBars{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (UIView * itemBack in _containerBarItemView.subviews) {
        for (XGSwitchBarCell *itemBar in itemBack.subviews) {
            if([itemBar isKindOfClass:[XGSwitchBarCell class]]){
                [temp addObject:itemBar];
            }
        }
    }
    return temp;
}



@end