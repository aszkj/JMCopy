//
//  WalletBalanceController.m
//  BFTest
//
//  Created by 伯符 on 16/12/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "WalletBalanceController.h"
#import "BalanceTopupController.h"
@interface WalletBalanceController ()

@end

@implementation WalletBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI{
    self.title = @"钱包余额";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureFriendBarItem];
    UIImageView *img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"walletlogo"]];
    img1.frame = CGRectMake(0, 0, 60*ScreenRatio, 60*ScreenRatio);
    img1.center = CGPointMake(Screen_width/2, 120*ScreenRatio);
    img1.contentMode = UIViewContentModeScaleAspectFit;
    img1.clipsToBounds = YES;
    [self.view addSubview:img1];
    
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 20*ScreenRatio)];
    balanceLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(img1.frame)+20*ScreenRatio);
    balanceLabel.text = @"我的余额";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = [UIColor blackColor];
    balanceLabel.font = BFFontOfSize(15);
    [self.view addSubview:balanceLabel];
    
    UILabel *walletNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230*ScreenRatio, 30*ScreenRatio)];
    walletNum.center = CGPointMake(Screen_width/2, CGRectGetMaxY(balanceLabel.frame)+30*ScreenRatio);
    walletNum.text = @"885.00";
    walletNum.textAlignment = NSTextAlignmentCenter;
    walletNum.textColor = [UIColor blackColor];
    walletNum.font = [UIFont boldSystemFontOfSize:26];
    [self.view addSubview:walletNum];

    CGFloat height = 40 *ScreenRatio;
    CGFloat spacing = 20 *ScreenRatio;
    NSArray *title = @[@"充值",@"发红包",@"转出"];

    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15*ScreenRatio, CGRectGetMaxY(walletNum.frame) + 60*ScreenRatio + (height + spacing) * i, Screen_width - 30*ScreenRatio, height);
        btn.tag = i + 99;
        [btn setBackgroundColor:BFColor(37, 38, 39, 1)];
        [btn setTitle:title[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5.0f;
        btn.layer.masksToBounds = YES;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)configureFriendBarItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 65*ScreenRatio, 16*ScreenRatio);
    [btn setContentEdgeInsets:UIEdgeInsetsMake(10*ScreenRatio, 10*ScreenRatio, 6, -20)];
    [btn setTitle:@"账单" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = BFFontOfSize(14);
    [btn addTarget:self action:@selector(checkBill:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)checkBill:(UIButton *)bill{
    
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 0 + 99) {
        // 充值
        BalanceTopupController *topupvc = [[BalanceTopupController alloc]init];
        [self.navigationController pushViewController:topupvc animated:YES];
    }
}

@end
