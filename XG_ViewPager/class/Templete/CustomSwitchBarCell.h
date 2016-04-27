//
//  CustomSwitchBarCell.h
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//  github:https://github.com/jiaxiaogang/XG_ViewPager
//

#import "XGSwitchBarCell.h"

/**
 *  MARK:--------------------自定义SwitchBarCell必须继承自XGSwitchCell--------------------
 */
@interface CustomSwitchBarCell : XGSwitchBarCell

-(id) init;
-(void) setData:(NSString*)title;

@end
