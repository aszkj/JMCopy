//
//  BalanceTopupController.m
//  BFTest
//
//  Created by 伯符 on 16/12/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BalanceTopupController.h"
#import "BFPayAlertView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface BalanceTopupController ()<BFStartedPayDelegate>{
    UITextField *topupTF;
    UIButton *btn;
    UIView *back;
}
@property (nonatomic,strong) BFPayAlertView *payAlert;
@end

@implementation BalanceTopupController

- (BFPayAlertView *)payAlert{
    if (!_payAlert) {
//        NSLog(@"%@ ----- %d",topupTF.text,[topupTF.text floatValue]);
        _payAlert = [[BFPayAlertView alloc]initWithFrame:CGRectMake(0, 0, Screen_width - 40*ScreenRatio, 250*ScreenRatio) number:[topupTF.text floatValue]];
        _payAlert.center = CGPointMake(Screen_width/2, Screen_height/2);
        _payAlert.delegate = self;
    }
    return _payAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BFColor(235, 236, 237, 1);
    [self configureUI];
    [self addgesture];
}

- (void)addgesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewtapResign:)];
    [self.view addGestureRecognizer:tap];
}

- (void)configureUI{
    UILabel *topup = [[UILabel alloc]initWithFrame:CGRectMake(0, NavBar_Height, 100*ScreenRatio, 45*ScreenRatio)];
    topup.backgroundColor = [UIColor whiteColor];
    topup.text = @"充值(元)";
    topup.textAlignment = NSTextAlignmentCenter;
    topup.textColor = [UIColor blackColor];
    topup.font = BFFontOfSize(17);
    [self.view addSubview:topup];
    
    topupTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(topup.frame), NavBar_Height, Screen_width - 100*ScreenRatio, 45*ScreenRatio)];
    topupTF.keyboardType = UIKeyboardTypeDecimalPad;
    topupTF.backgroundColor = [UIColor whiteColor];
    topupTF.placeholder = @"请输入充值金额";
    topupTF.delegate = self;
    [topupTF setValue:BFColor(151, 151, 151, 1) forKeyPath:@"_placeholderLabel.textColor"];
    topupTF.textColor = BFColor(134, 134, 134, 1);
    topupTF.font = BFFontOfSize(15);
    [self.view addSubview:topupTF];
    [topupTF addTarget:self action:@selector(searchTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    CGFloat height = 40 *ScreenRatio;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15*ScreenRatio, CGRectGetMaxY(topupTF.frame) + 20*ScreenRatio, Screen_width - 30*ScreenRatio, height);
    [btn setBackgroundColor:BFColor(194, 195, 196, 1)];
    btn.enabled = NO;
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 免责
    UILabel *labone = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenRatio, 20*ScreenRatio)];
    labone.center = CGPointMake(Screen_width/2 - 50*ScreenRatio, CGRectGetMaxY(btn.frame)+30*ScreenRatio);
    labone.textAlignment = NSTextAlignmentRight;
    labone.font = BFFontOfSize(12);
    labone.textColor = [UIColor lightGrayColor];
    labone.text = @"登录即代表你同意";
    [self.view addSubview:labone];
    UIButton *btnone = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 20*ScreenRatio)];
    btnone.center = CGPointMake(Screen_width/2 + 60*ScreenRatio, CGRectGetMaxY(btn.frame)+30*ScreenRatio);
    NSMutableAttributedString *disclaimer = [[NSMutableAttributedString alloc]initWithString:@"《近脉钱包用户协议》"];
    [disclaimer addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, disclaimer.length)];
    [disclaimer addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, disclaimer.length)];
    [btnone setAttributedTitle:disclaimer forState:UIControlStateNormal];
    btnone.titleLabel.font = BFFontOfSize(12);
    btnone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnone addTarget:self action:@selector(walletProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnone];

}


- (void)nextClick:(UIButton *)next{
    NSLog(@"nextClick");
    [self.view endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    back.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [window addSubview:back];
    [window addSubview:self.payAlert];
    [back addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)]];

}

- (void)resign{
    [back removeFromSuperview];
    [self.payAlert removeFromSuperview];
}

- (void)walletProtocol:(UIButton *)wallet{
    NSLog(@"walletProtocol");
}

- (void)viewtapResign:(UITapGestureRecognizer *)tapgesture{
    [self.view endEditing:YES];
}

- (void)searchTextFieldChangeAction:(UITextField *)sender{
    if (sender.text == nil || topupTF.text.length == 0) {
        btn.enabled = NO;

        [btn setBackgroundColor:BFColor(194, 195, 196, 1)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        btn.enabled = YES;

        [btn setBackgroundColor:BFColor(37, 38, 39, 1)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)starttoPay:(BalancePayWay)payWay{

    NSString *str = [NSString stringWithFormat:@"http://useralp.jinmailife.com/aliapppay/zfbpay.php"];
    NSString *jmid = [[NSUserDefaults standardUserDefaults]objectForKey:@"HXUID"];

    NSDictionary *para = @{@"boby":jmid,@"amount":topupTF.text};
    NSLog(@"%@",str);
    [BFNetRequest getWithURLString:str parameters:para success:^(id responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",accessDict);
        if ([accessDict[@"s"] isEqualToString:@"t"]) {
            NSString *appScheme = @"JinMaiPay";
            NSString *orderStr = [accessDict objectForKey:@"alipay"];
            
            [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"%@",resultDic);
            }];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

@end
