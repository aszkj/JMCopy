//
//  FansCareViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "FansCareViewCell.h"
@interface FansCareViewCell(){
    UILabel *focusNum;
    UILabel *fansNum;
}
@end
@implementation FansCareViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *focus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        focus.center = CGPointMake(Screen_width/4 - 25, 45 *ScreenRatio/2);
        focus.text = @"关注";
        focus.textAlignment = NSTextAlignmentCenter;
        focus.textColor = [UIColor blackColor];
        focus.font = BFFontOfSize(17);
        [self.contentView addSubview:focus];
        
        focusNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(focus.frame), CGRectGetMinY(focus.frame), 40, 20)];
        focusNum.textAlignment = NSTextAlignmentLeft;
        focusNum.textColor = [UIColor lightGrayColor];
        focusNum.font = BFFontOfSize(17);
        [self.contentView addSubview:focusNum];
        
        UIView *verticleLine = [[UIView alloc]initWithFrame:CGRectMake(Screen_width/2, CGRectGetMinY(focus.frame), 1, 20)];
        verticleLine.backgroundColor = BFColor(243, 243, 242, 1);
        [self.contentView addSubview:verticleLine];
        
        UILabel *fans = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        fans.center = CGPointMake(Screen_width/4*3 - 25, 45 *ScreenRatio/2);
        fans.text = @"粉丝";
        fans.textAlignment = NSTextAlignmentCenter;
        fans.textColor = [UIColor blackColor];
        fans.font = BFFontOfSize(17);
        [self.contentView addSubview:fans];
        
        fansNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fans.frame), CGRectGetMinY(fans.frame), 40, 20)];
        fansNum.text = @"52";
        fansNum.textAlignment = NSTextAlignmentLeft;
        fansNum.textColor = [UIColor lightGrayColor];
        fansNum.font = BFFontOfSize(17);
        [self.contentView addSubview:fansNum];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    
    focusNum.text = dic[@"focus"];
    fansNum.text = dic[@"fans"];
}

@end
