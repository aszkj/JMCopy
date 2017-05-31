//
//  AppDelegate+Register.m
//  BFTest
//
//  Created by JM on 2017/3/30.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "AppDelegate+Register.h"
#import "BFNavigationController.h"
#import "BFRegisterNewController.h"
#import "LoginProtectViewController.h"
#import "EditUserMesgController+new.h"


@implementation AppDelegate (Register)

- (UINavigationController *)currentNavigationController{
    return (BFNavigationController *)self.window.rootViewController;
}

/**
 ********** 统一登录一定会走的接口 **********
 
 @param token 第三方唯一标识码 手机登录时填nil
 @param type 当前登录的类型
 */
- (void)receiveToken:(NSString *)token from:(JM_TokenType )type{
    
    [BFUserLoginManager shardManager].loginType = type;
    NSString *loginName = nil;
    
    //判断当前的登录类型 根据类型做下一步处理
    switch (type) {
            
            //手机登录
        case JM_TokenTypePhone:
            loginName = nil;
            [self jumpToPhoneRegistVC];
            break;
            
            //第三方登录
        case JM_TokenTypeQQ:
            loginName = [token stringByAppendingString:@"qq" ];
            break;
        case JM_TokenTypeWB:
            loginName = [token stringByAppendingString:@"wb" ];
            break;
        case JM_TokenTypeWX:
            loginName = [token stringByAppendingString:@"wx" ];
            break;
        default:
            break;
    }
    //保存当前的登录名
    [BFUserLoginManager shardManager].loginName = loginName;
    //如果是第三方登录则调登录接口 根据返回code 做下步判断
    if(loginName){
        [BFOriginNetWorkingTool loginByLoginName:loginName completionHandler:^(int code, NSError *error) {
            [self dealWithLoginResultCode:code];
        }];
    }
}


/**
 处理第三方登录时 调用登录接口后返回code之后的处理
 @param code 调用登录接口后返回的 code
 */
- (void)dealWithLoginResultCode:(int )code{
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    switch (code) {
        case 200://授信且判断为老用户的情况 记录返回的jmid 跳转登录成功
            //判断此用户信息是否有头像和昵称
            if([manager.photo isKindOfClass:[NSString class]] && [manager.name isKindOfClass:[NSString class]]){
                //不缺基本信息 直接跳转到登录完成界面
                [manager saveUserInfo];
                [self jumpToMainVC ];
            }else{
                //缺失头像和昵称 需跳转到完善信息界面
                [self jumpToUserEditVC];
            }

            break;
            
        case 201://设备未授信 返回校验码 跳转到校验码验证页面
            [self jumpToProtectVC];
            break;
            
        case 202://此状态码说明是对应有已存在的jmid  并且没有绑定手机 需要验证手机号 然后将第三方唯一标示和设备 调用创建新用户接口
            [self jumpToPhoneRegistVC];
            break;
            
        case 203://新用户
            //第三方登录的新用户 需要跳转到绑定手机号页面
            [self jumpToPhoneRegistVC];
            break;
            
        default:
            break;
    }
}
/**
 跳转到手机号码验证的界面
 */
- (void)jumpToPhoneRegistVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        BFRegisterNewController *registController = [[BFRegisterNewController alloc]init];
        [self.currentNavigationController pushViewController:registController animated:YES];
    });
}


/**
 跳转到登录保护界面
 */
- (void)jumpToProtectVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LoginProtect" bundle:nil];
        LoginProtectViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LoginProtectViewController"];
        [self.currentNavigationController pushViewController:vc animated:YES];
    });
}

/**
 跳转到完善个人信息界面
 */
- (void)jumpToUserEditVC{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        EditUserMesgController *editVC = [[EditUserMesgController alloc]init];
        [self.currentNavigationController pushViewController:editVC animated:YES];
    });
}

/**
 登录到主界面
 */
- (void)jumpToMainVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        BFTabbarController *vc = [[BFTabbarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    });
}


@end
