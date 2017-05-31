//
//  BFHXDelegateManager+Client.m
//  BFTest
//
//  Created by JM on 2017/4/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXDelegateManager+Client.h"
#import "BFNavigationController.h"
#import "JinMaimMainController.h"

@implementation BFHXDelegateManager (Client)

/*!
 *  \~chinese
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 *
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    switch (aConnectionState) {
            //成功连接网络时的后续处理
        case EMConnectionConnected:
            
            break;
            //连接失败的处理
        case EMConnectionDisconnected:
            break;
            
        default:
            break;
    }
}

/*!
 *  \~chinese
 *  自动登录失败时的回调
 *
 *  @param aError 错误信息
 *
 */
- (void)autoLoginDidCompleteWithError:(EMError *)aError{
    
}

/*!
 *  \~chinese
 *  当前登录账号在其它设备登录时会接收到此回调
 *
 */
- (void)userAccountDidLoginFromOtherDevice{
    
    //删除本地持久化的用户信息
    [[BFUserLoginManager shardManager]cleanLocalUserInfo];
    //退出环信
    [[BFUserLoginManager shardManager]logoutFromEMClient];
    // 直接跳转到未登录或注册或没有编辑个人资料进入APP的情况
    JinMaimMainController *main = [[JinMaimMainController alloc]init];
    BFNavigationController *nv = [[BFNavigationController alloc]initWithRootViewController:main];
    [UIApplication sharedApplication].delegate.window.rootViewController = nv;
    [main showAlertViewTitle:@"您的账号已经在其他地方登录！" message:nil];

}

/*!
 *  \~chinese
 *  当前登录账号已经被从服务器端删除时会收到该回调
 *
 */
- (void)userAccountDidRemoveFromServer{
    
}



@end
