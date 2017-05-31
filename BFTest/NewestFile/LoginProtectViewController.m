//
//  LoginProtectViewController.m
//  BFTest
//
//  Created by JM on 2017/3/31.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "LoginProtectViewController.h"
#import "BFUserLoginManager.h"
#import "BFTabbarController.h"

@interface LoginProtectViewController ()

@property (weak, nonatomic) IBOutlet UILabel *protectCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *protectCodeTF;

@end

@implementation LoginProtectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.protectCodeLabel.text = [BFUserLoginManager shardManager].protectCode;
}
- (IBAction)protectCodeBtn:(UIButton *)sender {
    if([self.protectCodeTF.text isEqualToString:self.protectCodeLabel.text]){
        // 登录到主界面
        [[BFUserLoginManager shardManager] saveUserInfo];
        BFTabbarController *vc = [[BFTabbarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    }else{
        [self showAlertViewTitle:@"您输入校验码有误，请重新输入" message:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
