//
//  CustomSwitchBarCell.m
//  XG_ViewPager
//
//  Created by 贾  on 16/4/25.
//  Copyright © 2016年 XiaoGang. All rights reserved.
//

#import "CustomSwitchBarCell.h"


@interface CustomSwitchBarCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation CustomSwitchBarCell

/**
 *  MARK:--------------------Init--------------------
 */
-(id) init{
    self = [CustomSwitchBarCell newWithOwner:nil];
    if(self != nil){
    }
    return self;
}

+ (id)newWithOwner:(id)owner
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CustomSwitchBarCell" owner:owner options:nil];
    return [nibs objectAtIndex:0];
}

-(void) awakeFromNib{
    [self initView];
}

-(void)initView{
    
}

/**
 *  MARK:--------------------setData--------------------
 */
-(void) setData:(NSString*)title
{
    [self.titleLab setText:title];
}

- (IBAction)backBtnOnClick:(UIButton*)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(xgSwitchBarCell:clickIndex:animated:)]){
        [self.delegate xgSwitchBarCell:self clickIndex:self.index animated:true];
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self refreshDisplay_SwitchBtn:selected];
}


/**
 *  MARK:--------------------刷新高亮状态--------------------
 */
-(void) refreshDisplay_SwitchBtn:(BOOL)selected
{
    if(selected){
        [self.titleLab setTextColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    }else{
        [self.titleLab setTextColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:1]];
    }
}


@end
