//
//  UIViewController+BFViewController.m
//  BFTest
//
//  Created by 伯符 on 16/5/11.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UIViewController+BFViewController.h"
#import <objc/runtime.h>


static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (BFViewController)

- (void)buildNavigationBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 100, Screen_width, 64)];
    navBar.backgroundColor = [UIColor blackColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = kbackBtntag;
    [navBar addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navBar.mas_left).with.offset(5);
        make.top.equalTo(navBar.mas_top).with.offset(17);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.tag = kfinishBtntag;
    [navBar addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navBar.mas_right).with.offset(-5);
        make.top.equalTo(navBar.mas_top).with.offset(17);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar];
}

#pragma mark -hideTabbar
- (void)hideTabbar:(BOOL)isHide{
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIView *tabbar = [rootView viewWithTag:kTabbarTag];
    if (isHide) {
        [UIView animateWithDuration:0.35 animations:^{
            tabbar.transform = CGAffineTransformMakeTranslation(- Screen_width, 0);
        }];
    }else{
        [UIView animateWithDuration:0.35 animations:^{
            tabbar.transform = CGAffineTransformIdentity;
        }];
    }
    
}

#pragma mark - alerview

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        NSLog(@"手机无效");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg  duration:(NSTimeInterval)duration{
    [self showAlertViewTitle:title message:mesg duration:duration finishCallBack:nil];
    }
- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg  duration:(NSTimeInterval)duration finishCallBack:(void(^)())finishCallBack{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if(finishCallBack){
                finishCallBack();
            }
        }];
    });
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg sureAction:(void(^)())sureActionHandler cancelAction:(void(^)())cancelActionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelActionHandler();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureActionHandler();
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg sureAction:(void(^)())sureActionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureActionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}





- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg cancelbutton:(NSString *)str otherbutton:(NSString *)otherstr{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:otherstr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    }]];
    [self presentViewController:alert animated:YES completion:nil];

}



#pragma mark - 转化网络返回参数
- (NSString *)transformData:(id)data{
    NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",dataArray);
    NSDictionary *dic = [dataArray firstObject];
    NSString *result = [dic objectForKey:@"state"];
    return result;
}

- (void)backClick:(UIButton *)btn{
    NSLog(@"backClick");
}

#pragma mark - showUpLabel;
+ (void)showUpLabelText:(NSString *)mesg{
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(10, - 50, Screen_width - 20, 50)];
    back.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:back];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(back.frame) - 20, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = mesg;
    label.font = BFFontOfSize(14);
    label.textColor = [UIColor whiteColor];
    [back addSubview:label];
    [UIView animateWithDuration:1.0f animations:^{
        back.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:1.0f delay:1.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            back.top = - 50;
        } completion:^(BOOL finished) {
            [back removeFromSuperview];
        }];
    }];
}

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.yOffset = 180;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.yOffset = 180;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)openMicroph{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //                        [[[UIAlertView alloc] initWithTitle:nil
                    //                                                    message:@"近脉需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                    //                                                   delegate:nil
                    //                                          cancelButtonTitle:@"确定"
                    //                                          otherButtonTitles:nil] show];
                    //                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}

- (BOOL)canRecord{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) {
        //        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:@"程序需要访问您的相机。\n请启用麦克风-设置/隐私/相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alerView show];
        return NO;
    }else{
        return YES;
    }
}


@end
