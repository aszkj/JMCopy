//
//  BFMapAlertView.m
//  BFTest
//
//  Created by 伯符 on 16/8/4.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFMapAlertView.h"

#import "BFMapAlertCell.h"

@interface BFMapAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *alertArray;

@end

@implementation BFMapAlertView



- (void)setSellDic:(NSDictionary *)sellDic{
    _sellDic = sellDic;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.alertArray = @[@{@"alerImg":@"changemesg",@"alertTitle":@"交易消息",@"alertSub":@""},@{@"alerImg":@"mycollection",@"alertTitle":@"商家收藏",@"alertSub":@""}];
    self.sellView = [[UITableView alloc]initWithFrame:self.bounds];
    self.sellView.backgroundColor = [UIColor clearColor];
    self.sellView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sellView.scrollEnabled = NO;
    self.sellView.delegate = self;
    self.sellView.dataSource = self;
    [self addSubview:self.sellView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ident = @"AlertCell";
    BFMapAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[BFMapAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    NSDictionary *alertDic = self.alertArray[indexPath.row];
    cell.dic = alertDic;
    
    return cell;

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    header.backgroundColor = [UIColor clearColor];
    
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 30*ScreenRatio)];
    upview.userInteractionEnabled = YES;
    upview.backgroundColor = [BFColor(44, 45, 46, 1)colorWithAlphaComponent:0.8];
    [header addSubview:upview];
    
    UIImageView *imgAlert = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15*ScreenRatio, 19*ScreenRatio)];
    imgAlert.center = CGPointMake(self.width/2, CGRectGetMidY(upview.frame));
    imgAlert.contentMode = UIViewContentModeScaleToFill;
    imgAlert.clipsToBounds = YES;
    imgAlert.image = [UIImage imageNamed:@"alert"];
    [upview addSubview:imgAlert];
    
    UIImageView *deleteicon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*ScreenRatio, 10*ScreenRatio)];
    deleteicon.center = CGPointMake(self.width - 15*ScreenRatio, CGRectGetMidY(upview.frame));
    deleteicon.contentMode = UIViewContentModeScaleToFill;
    deleteicon.clipsToBounds = YES;
    deleteicon.image = [UIImage imageNamed:@"chahao"];
    [upview addSubview:deleteicon];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.tag = AlertviewButtonTypeDelete;
    deleteBtn.frame = CGRectMake(self.width - 30*ScreenRatio, 0, 30*ScreenRatio, 30*ScreenRatio);
    [deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [upview addSubview:deleteBtn];
    
    NSArray *titleArr = @[@"待支付",@"待完成",@"已完成",@"退款"];
    NSArray *imgArr = @[@"startpay",@"startuse",@"haveuse",@"refund"];
    CGFloat btnwidth = 17*ScreenRatio;
    CGFloat spacing = (self.width - btnwidth * 4 - 40*ScreenRatio)/3;
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20*ScreenRatio + (btnwidth + spacing)*i, CGRectGetMaxY(upview.frame)+13*ScreenRatio, btnwidth, btnwidth);
        btn.tag = i + 1;
        [btn setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [header addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*ScreenRatio, 16*ScreenRatio)];
        titleLabel.center = CGPointMake(CGRectGetMidX(btn.frame), CGRectGetMaxY(btn.frame)+12*ScreenRatio);
        titleLabel.text = titleArr[i];
        titleLabel.textColor = BFColor(255, 255, 255, 1);
        titleLabel.font = BFFontOfSize(12);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:titleLabel];
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    /*
    UIImageView *ticket = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2 - 23*ScreenRatio, 5*ScreenRatio, 46*ScreenRatio, 46*ScreenRatio)];
    ticket.contentMode = UIViewContentModeScaleToFill;
    ticket.clipsToBounds = YES;
    ticket.image = [UIImage imageNamed:@"ticket"];
    [footview addSubview:ticket];
    
    UILabel *ticketL = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2 - 20*ScreenRatio, CGRectGetMaxY(ticket.frame)+ScreenRatio, 40*ScreenRatio, 20*ScreenRatio)];
    ticketL.text = @"抢券";
    ticketL.textColor = [UIColor whiteColor];
    ticketL.font = [UIFont boldSystemFontOfSize:15];
    ticketL.textAlignment = NSTextAlignmentCenter;
    [footview addSubview:ticketL];
    
    UILabel *warnL = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2 - 75*ScreenRatio, CGRectGetMaxY(ticketL.frame)+2*ScreenRatio, 150*ScreenRatio, 15*ScreenRatio)];
    warnL.text = @"每天12：00和18：00限时开抢";
    warnL.textColor = BFColor(75, 76, 77, 1);
    warnL.font = BFFontOfSize(10);
    warnL.textAlignment = NSTextAlignmentCenter;
    [footview addSubview:warnL];
    */
    return footview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 95*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*ScreenRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(selectedRow:)]) {
        [self.delegate selectedRow:indexPath.row];
    }
}

- (void)btnClick:(UIButton *)tap{
    if ([self.delegate respondsToSelector:@selector(alertViewBtnClick:)]) {
        [self.delegate alertViewBtnClick:tap];
    }
}

- (void)showMapAlertView{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, - kMapShowHeight);
        self.sellView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

@end
