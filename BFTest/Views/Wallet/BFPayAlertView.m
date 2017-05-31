//
//  BFPayAlertView.m
//  BFTest
//
//  Created by 伯符 on 16/12/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFPayAlertView.h"
#import "TopupBalanceCell.h"
@interface BFPayAlertView ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    NSArray *data;
    UIImageView *selectCheck;
    CGFloat cellheight;
    CGFloat balancenum;
}

@end

@implementation BFPayAlertView

- (instancetype)initWithFrame:(CGRect)frame number:(CGFloat)num{
    if (self = [super initWithFrame:frame]) {
        [self configureUIwithNum:num];
        NSLog(@"%lf",num);
        data = @[@{@"title":@"微信",@"img":@"weixinlogo"},@{@"title":@"支付宝",@"img":@"zhifubaologo"}];
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)configureUIwithNum:(CGFloat)num{
    balancenum = num;
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;
    [self addSubview:tableview];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 120*ScreenRatio)];
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40*ScreenRatio)];
    upview.backgroundColor = [UIColor blackColor];
    [header addSubview:upview];
    UILabel *payvert = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenRatio, 20*ScreenRatio)];
    payvert.center = CGPointMake(self.width/2, upview.height/2);
    payvert.text = @"支付确认";
    payvert.textAlignment = NSTextAlignmentCenter;
    payvert.textColor = [UIColor whiteColor];
    payvert.font = [UIFont boldSystemFontOfSize:17];
    [upview addSubview:payvert];
    
    UILabel *topupNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenRatio, 20*ScreenRatio)];
    topupNumLabel.center = CGPointMake(self.width/2, CGRectGetMaxY(upview.frame)+20*ScreenRatio);
    topupNumLabel.text = @"充值金额";
    topupNumLabel.textAlignment = NSTextAlignmentCenter;
    topupNumLabel.textColor = [UIColor blackColor];
    topupNumLabel.font = BFFontOfSize(15);
    [header addSubview:topupNumLabel];
    
    UILabel *topupNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230*ScreenRatio, 30*ScreenRatio)];
    topupNum.center = CGPointMake(self.width/2, CGRectGetMaxY(topupNumLabel.frame)+ 19*ScreenRatio);
    topupNum.text = [NSString stringWithFormat:@"%.2f",balancenum];
    topupNum.textAlignment = NSTextAlignmentCenter;
    topupNum.textColor = [UIColor blackColor];
    topupNum.font = BFFontOfSize(26);
    [header addSubview:topupNum];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame) - 0.5, self.width, 0.5)];
    line1.backgroundColor = BFColor(239, 240, 241, 1);
    [header addSubview:line1];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120*ScreenRatio;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*ScreenRatio;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.width, 40*ScreenRatio);
    [btn setTitle:@"立即支付" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startPay:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40*ScreenRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellident = @"Paycell";
    TopupBalanceCell *cell = [tableview dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[TopupBalanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
    }
    NSDictionary *dic = data[indexPath.row];
    cell.icon.image = [UIImage imageNamed:dic[@"img"]];
    cell.nameLabel.text = dic[@"title"];
    if (indexPath.row == 0) {
        cell.checkmark.hidden = NO;
        selectCheck = cell.checkmark;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopupBalanceCell *cell = [tableview cellForRowAtIndexPath:indexPath];
    if (cell.checkmark != selectCheck) {
        selectCheck.hidden = YES;
    }
    cell.checkmark.hidden = NO;
    selectCheck = cell.checkmark;
}

- (void)startPay:(UIButton *)btn{
    TopupBalanceCell *cell = (TopupBalanceCell *)selectCheck.superview;
    NSIndexPath *indexpath = [tableview indexPathForCell:cell];
    NSInteger index = indexpath.row;
    if ([self.delegate respondsToSelector:@selector(starttoPay:)]) {
        [self.delegate starttoPay:index];
    }
}

@end
