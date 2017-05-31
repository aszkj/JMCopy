//
//  UserBaseViewController.m
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserBaseViewController.h"

@interface UserBaseViewController ()
@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureBarItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"vc --- %@ will appear",NSStringFromClass([self class]));
}

- (void)configureBarItem{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 40, 18);
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:back];
    [back addTarget:self action:@selector(backpush:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBar;
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(0, 0, 40, 18);
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *saveBtem = [[UIBarButtonItem alloc]initWithCustomView:save];
    [save addTarget:self action:@selector(saveUserMsg:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = saveBtem;
    self.rightBar = save;
}

- (void)backpush:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveUserMsg:(UIButton *)save{
    [self showAlertViewTitle:@"保存成功" message:nil];
}

- (void)setRightStr:(NSString *)rightStr{
    [self.rightBar setTitle:rightStr forState:UIControlStateNormal];
}

@end
