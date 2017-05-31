//
//  MyWalletController.m
//  BFTest
//
//  Created by 伯符 on 16/12/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "MyWalletController.h"
#import "WalletBalanceController.h"
@interface MyWalletController ()

@end

@implementation MyWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [self configureHeader];
    self.title = @"我的钱包";
    self.dataArray = @[@"我的收益",@"支付设置"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)configureHeader{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 120*ScreenRatio)];
    header.backgroundColor = BFColor(37, 38, 39, 1);
    
    UIImageView *img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"walletlogo"]];
    img1.frame = CGRectMake(0, 0, 40*ScreenRatio, 40*ScreenRatio);
    img1.center = CGPointMake(Screen_width/4, header.height/2 - 20*ScreenRatio - 5*ScreenRatio);
    img1.contentMode = UIViewContentModeScaleAspectFit;
    img1.clipsToBounds = YES;
    [header addSubview:img1];
    UILabel *walletNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 23*ScreenRatio)];
    walletNum.center = CGPointMake(Screen_width/4, header.height/2 + 10*ScreenRatio);
    walletNum.text = @"885.00";
    walletNum.textAlignment = NSTextAlignmentCenter;
    walletNum.textColor = [UIColor whiteColor];
    walletNum.font = [UIFont boldSystemFontOfSize:19];
    [header addSubview:walletNum];
    
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 20*ScreenRatio)];
    balanceLabel.center = CGPointMake(Screen_width/4, CGRectGetMaxY(walletNum.frame)+10*ScreenRatio);
    balanceLabel.text = @"钱包余额(元)";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = [UIColor whiteColor];
    balanceLabel.font = [UIFont boldSystemFontOfSize:15];
    [header addSubview:balanceLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(Screen_width/2, 15*ScreenRatio, 1.0, header.height - 30*ScreenRatio)];
    line.backgroundColor = [UIColor whiteColor];
    [header addSubview:line];
    
    UIImageView *img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinbalance"]];
    img2.frame = CGRectMake(0, 0, 40*ScreenRatio, 40*ScreenRatio);
    img2.center = CGPointMake(Screen_width/4*3, header.height/2 - 20*ScreenRatio - 5*ScreenRatio);
    img2.contentMode = UIViewContentModeScaleAspectFit;
    img2.clipsToBounds = YES;
    [header addSubview:img2];
    
    UILabel *jinCornNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 23*ScreenRatio)];
    jinCornNum.center = CGPointMake(Screen_width/4 * 3, header.height/2 + 10*ScreenRatio);
    jinCornNum.text = @"665.00";
    jinCornNum.textAlignment = NSTextAlignmentCenter;
    jinCornNum.textColor = [UIColor whiteColor];
    jinCornNum.font = [UIFont boldSystemFontOfSize:19];
    [header addSubview:jinCornNum];
    
    UILabel *balanceJinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 20*ScreenRatio)];
    balanceJinLabel.center = CGPointMake(Screen_width/4 * 3, CGRectGetMaxY(jinCornNum.frame)+10*ScreenRatio);
    balanceJinLabel.text = @"近脉币余额";
    balanceJinLabel.textAlignment = NSTextAlignmentCenter;
    balanceJinLabel.textColor = [UIColor whiteColor];
    balanceJinLabel.font = [UIFont boldSystemFontOfSize:15];
    [header addSubview:balanceJinLabel];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10*ScreenRatio, 15*ScreenRatio, Screen_width/2 - 20*ScreenRatio, CGRectGetHeight(line.frame));
    [btn1 addTarget:self action:@selector(walletClick:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(CGRectGetMaxX(line.frame)+10*ScreenRatio, 15*ScreenRatio, Screen_width/2 - 20*ScreenRatio, CGRectGetHeight(line.frame));
    [btn2 addTarget:self action:@selector(jinWalletClick:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn2];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellident = @"mywalletcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        // 我的收益
        
    }else{
        // 支付设置
    }
}

- (void)walletClick:(UIButton *)btn{
    NSLog(@"walletClick");
    WalletBalanceController *walletvc = [[WalletBalanceController alloc]init];
    [self.navigationController pushViewController:walletvc animated:YES];
}

- (void)jinWalletClick:(UIButton *)btn{
    NSLog(@"jinWalletClick");
}

@end
