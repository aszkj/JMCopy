//
//  AccountViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "AccountViewCell.h"
@interface AccountViewCell(){
    UILabel *moneyNum;
    UILabel *receiveNum;
}
@end
@implementation AccountViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        moneyNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 20)];
        moneyNum.center = CGPointMake(Screen_width/4, 60 *ScreenRatio/2 - 15);
        moneyNum.textAlignment = NSTextAlignmentCenter;
        moneyNum.textColor = [UIColor blackColor];
        moneyNum.font = BFFontOfSize(17);
        [self.contentView addSubview:moneyNum];
        
        UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 20)];
        money.center = CGPointMake(Screen_width/4, 60 *ScreenRatio/2 + 15);
        money.text = @"送出金额";
        money.textAlignment = NSTextAlignmentCenter;
        money.textColor = [UIColor lightGrayColor];
        money.font = BFFontOfSize(16);
        [self.contentView addSubview:money];
        
        UIView *verticleLine = [[UIView alloc]initWithFrame:CGRectMake(Screen_width/2, CGRectGetMinY(moneyNum.frame), 1, 40)];
        verticleLine.backgroundColor = BFColor(243, 243, 242, 1);
        [self.contentView addSubview:verticleLine];
        
        receiveNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 20)];
        receiveNum.center = CGPointMake(Screen_width/4 * 3, 60 *ScreenRatio/2 - 15);
        receiveNum.text = @"¥ 585.00";
        receiveNum.textAlignment = NSTextAlignmentCenter;
        receiveNum.textColor = [UIColor blackColor];
        receiveNum.font = BFFontOfSize(17);
        [self.contentView addSubview:receiveNum];
        
        UILabel *receiveMoney = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 20)];
        receiveMoney.center = CGPointMake(Screen_width/4 * 3, 60 *ScreenRatio/2 + 15);
        receiveMoney.text = @"收到金额";
        receiveMoney.textAlignment = NSTextAlignmentCenter;
        receiveMoney.textColor = [UIColor lightGrayColor];
        receiveMoney.font = BFFontOfSize(16);
        [self.contentView addSubview:receiveMoney];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    
    moneyNum.text = dic[@"sendmoney"];
    receiveNum.text = dic[@"getmoney"];

}

@end
