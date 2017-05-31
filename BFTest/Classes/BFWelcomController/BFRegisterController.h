//
//  BFRegisterController.h
//  BFTest
//
//  Created by 伯符 on 16/5/31.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFRegisterController : UIViewController<UITextFieldDelegate>{
    UITextField *passwordTF;
    UITextField *mobileTF;
    UITextField *vercode;
    UIButton *getcode;
    UILabel *codeLb;
    MBProgressHUD *hub;
    BOOL hasData;
    NSString *userStr;
    NSString *tokenStr;
}

@property (nonatomic,strong) NSDictionary *mesg;

@property (nonatomic,assign) BOOL isPhoneEn ;

// 对应接口/register3 里面 at 参数，在进入手机界面之前，判断返回数据为 {s:d},则是新用户,则at=n1,
// 如果返回数据中解析有phone字段，但是为空，则at=c2    (傻逼的数据结构逻辑)!!!!!
@property (nonatomic,copy) NSString *phoneident;

@property (nonatomic,assign) BOOL isnewer ;

-(BOOL) isValidateMobile:(NSString *)mobile;
- (void)resumeTime;

@end
