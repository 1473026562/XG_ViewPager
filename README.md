# XG_ViewPager
It's same android's viewPager UI control;use it is so easy if you can use UITableView;because them 是一样的!


QQ交流群:193069075(可申请提交您更佳的代码)


![image](https://github.com/jiaxiaogang/XG_ViewPager/blob/master/XG_ViewPager/XG_ViewPager.gif )  



## 安装
1. 打开`XG_ViewPager`项目导入`XG_ViewPager/classes文件夹中所有类`即可

## 使用
有Simplate示例可以参考;并且此实例已经有了比较全面的功能实现;
### 继承
* 导入头文件`XG_ViewPager.h`
* 当前要实现的控制器继承`实现XG_ViewPagerDelgate`
``` objective-c
#import "XG_ViewPager.h"
@interface ViewController ()<XG_ViewPagerDelegate>
@end
``` 

* 给当前的控制器设置代理方法 
```objective-c
@property(strong,nonamic) XG_ViewPager viewPager;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewPager.delegate = self;
}
```
###代理方法实现
```objective-c

- (BOOL)xgViewPager:(XGViewPager *)containerView loadCanChangeItemWithCurrentView:(XGViewPagerCell *)currentView 
                    currentIndex:(NSInteger)index withGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //用于header上的手势截断,使用户左右滑动headerView时不左右切换页面;
}

-(XGViewPagerCell*) xgViewPager:(XGViewPager*)viewPager cellFor:(NSInteger)index
{
    //类似与UITableView的cellFor方法
}

-(NSInteger) numberOfCellsXGViewPager:(XGViewPager*)viewPager
{
    //类似于UITableView的numberOf方法
}

-(void) xgViewPager_willChangePage
{
    //左右滑动将切换页面时执行
}

-(void) xgViewPager_didChangePage:(NSInteger)index
{
    //左右滑动切换页面后执行
}

-(void) xgViewPager_willDisplayCell:(XGViewPagerCell*)displayView forIndex:(NSInteger)displayIndex               
              willNoDisplayCell:(XGViewPagerCell*)noDisplayView forIndex:(NSInteger)noDisplayIndex
{
    //将要显示某页面时执行,有时从0页快速切到4页;此处执行4次
}


```
