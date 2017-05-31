//
//  BFRegisterController.m
//  BFTest
//
//  Created by 伯符 on 16/5/31.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFRegisterController.h"
#import "BFTabbarController.h"
#import <sys/utsname.h>
#import "EditUserMesgController.h"
#import "BFNavigationController.h"
#import "BFChatHelper.h"
@interface BFRegisterController ()

@end

@implementation BFRegisterController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self configureUI];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)configureUI{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard:)]];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = BFColor(16, 16, 16, 1);

    UIImageView *back = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textback"]];
    back.userInteractionEnabled = YES;
    back.frame = CGRectMake(10*ScreenRatio, NavigationBar_Height + 20*ScreenRatio, Screen_width - 20*ScreenRatio, 40*ScreenRatio);
    back.contentMode = UIViewContentModeScaleAspectFit;
    back.clipsToBounds = YES;
    [self.view addSubview:back];
    mobileTF = [[UITextField alloc]initWithFrame:CGRectMake(35*ScreenRatio, 2*ScreenRatio, CGRectGetWidth(back.frame)-45*ScreenRatio, 38*ScreenRatio)];
    mobileTF.keyboardType = UIKeyboardTypeNumberPad;

    mobileTF.backgroundColor = [UIColor clearColor];
    mobileTF.placeholder = @"+86|手机号";
    mobileTF.delegate = self;
    [mobileTF setValue:BFColor(151, 151, 151, 1) forKeyPath:@"_placeholderLabel.textColor"];
    mobileTF.textColor = BFColor(134, 134, 134, 1);
    mobileTF.font = BFFontOfSize(15);
    [back addSubview:mobileTF];
    UIImageView *mobile = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15*ScreenRatio, 15*ScreenRatio)];
    mobile.contentMode = UIViewContentModeScaleAspectFit;
    mobile.clipsToBounds = YES;
    mobile.center = CGPointMake(25*ScreenRatio, 20*ScreenRatio);
    mobile.image = [UIImage imageNamed:@"mobilelogo"];
    [back addSubview:mobile];
    
    UIImageView *verBack = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verback"]];
    verBack.userInteractionEnabled = YES;
    verBack.frame = CGRectMake(20*ScreenRatio, CGRectGetMaxY(back.frame) + 14*ScreenRatio, 150*ScreenRatio, 40*ScreenRatio);
    verBack.contentMode = UIViewContentModeScaleAspectFit;
    verBack.clipsToBounds = YES;
    [self.view addSubview:verBack];
    UIImageView *verLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verlogo"]];
    verLogo.frame = CGRectMake(0, 0, 12*ScreenRatio, 12*ScreenRatio);
    verLogo.center = CGPointMake(14*ScreenRatio, 20*ScreenRatio);
    verLogo.contentMode = UIViewContentModeScaleAspectFit;
    verLogo.clipsToBounds = YES;
    [verBack addSubview:verLogo];
    vercode = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verLogo.frame)+5*ScreenRatio, 2*ScreenRatio, 120*ScreenRatio, 36*ScreenRatio)];
    vercode.keyboardType = UIKeyboardTypeNumberPad;
    vercode.backgroundColor = [UIColor clearColor];
    vercode.placeholder = @"验证码";
    vercode.delegate = self;
    [vercode setValue:BFColor(151, 151, 151, 1) forKeyPath:@"_placeholderLabel.textColor"];
    vercode.textColor = BFColor(134, 134, 134, 1);
    vercode.font = BFFontOfSize(15);
    [verBack addSubview:vercode];
    
    getcode = [UIButton buttonWithType:UIButtonTypeSystem];
    [getcode setBackgroundImage:[UIImage imageNamed:@"getvercode"] forState:UIControlStateNormal];
    getcode.frame = CGRectMake(CGRectGetMaxX(verBack.frame)+10*ScreenRatio, verBack.top, Screen_width - 150*ScreenRatio - 50*ScreenRatio, 40*ScreenRatio);
    [getcode addTarget:self action:@selector(getVertifiedCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getcode];
    codeLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(getcode.frame) - 10, CGRectGetHeight(getcode.frame) - 10)];
    codeLb.text = @"获取验证码";
    codeLb.textAlignment = NSTextAlignmentCenter;
    codeLb.textColor = BFColor(151, 151, 151, 1);
    codeLb.font = BFFontOfSize(13);
    [getcode addSubview:codeLb];
    
    // 完成 登录按钮
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"completebtn"] forState:UIControlStateNormal];
    completeBtn.frame = CGRectMake(20*ScreenRatio, CGRectGetMaxY(getcode.frame)+20*ScreenRatio, Screen_width - 40*ScreenRatio, 40*ScreenRatio);
    [self.view addSubview:completeBtn];
    [completeBtn addTarget:self action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - resignKeyboard
- (void)resignKeyboard:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

- (void)getVertifiedCode:(UIButton *)btn{
    [vercode becomeFirstResponder];
    NSString *username = self.isPhoneEn ? [NSString stringWithFormat:@"%@jm",mobileTF.text] : self.mesg[@"openuid"];
    if ([self isValidateMobile:mobileTF.text]) {
        [self resumeTime];
        
        [BFNetRequest postWithURLString:GETVERTITIEDCODE parameters:@{@"name":username,@"phone":mobileTF.text} success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
    } failure:^(NSError *error) {
        //
    }];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return ;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手机号码错误" message:@"您输入的是一个无效的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
            NSLog(@"手机无效");
        }]];
        double delayInSeconds = 1.0;
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            NSLog(@"Grand Center Dispatch!");
            [self presentViewController:alert animated:YES completion:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    }
}

#pragma mark -手机号码验证 MODIFIED BY HELENSONG
-(BOOL) isValidateMobile:(NSString *)mobile
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (void)resumeTime{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                codeLb.text = @"重新获取";
                getcode.enabled = YES;
                
            });
        }else{
            
            int seconds = timeout;
            //            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"(%i)秒后重新获取",seconds];
                codeLb.text = str;
                getcode.enabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


@end
