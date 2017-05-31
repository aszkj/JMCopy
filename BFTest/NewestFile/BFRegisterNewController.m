//
//  BFRegisterNewController.m
//  BFTest
//
//  Created by JM on 2017/3/29.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFRegisterNewController.h"
#import "BFOriginNetWorkingTool+login.h"
#import "EditUserMesgController+new.h"
#import "LoginProtectViewController.h"

#define testPassCode @"123456"

@interface BFRegisterNewController ()<NSURLSessionDelegate>
{
    NSDate *dateTest;
}
@property (nonatomic,strong)NSURLSession *session;

@end

@implementation BFRegisterNewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 300, 350, 30)];
    label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    label.textColor = [UIColor blackColor];

    //注释掉验证码提示
    if(IsTestModel == NO){
        
        label = nil;
    }
    [self.view addSubview:label];
    self.label = label;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 按钮的点击事件
/**
 重写点击获取验证码按钮的点击事件
 */
- (void)getVertifiedCode:(UIButton *)btn{
    //这里应该对手机号码格式做判断
    if ([self isValidateMobile:mobileTF.text]) {
        
        [self resumeTime];
        //调用接口 通过服务器向手机发送验证码
        [BFOriginNetWorkingTool sendToPhoneNum:mobileTF.text completionHandler:^(NSString *sendCode, NSError *error) {
            NSLog(@"发送的验证码是 ->%@",sendCode);
            if([sendCode isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text = [NSString stringWithFormat:@"Version->%@ code->%@",[BFUserLoginManager shardManager].version,sendCode];
            });
            }
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

/**
 重写点击完成按钮的事件
 */
- (void)completeClick:(UIButton *)btn{
    
    dateTest = [NSDate date];
//    //开始********
//    NSDate *date = [NSDate date];


    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    if (mobileTF.text == nil || mobileTF.text.length == 0) {
        [self showAlertViewTitle:nil message:@"请输入手机号"];
        return ;
    }
    if (vercode.text == nil || vercode.text.length == 0) {
        [self showAlertViewTitle:nil message:@"请输入验证码"];
        return ;
    }
    //判断输入验证码是否正确
    if(![manager.sendCode isEqualToString:vercode.text] && !([vercode.text isEqualToString:testPassCode] && [mobileTF.text isEqualToString:@"123456"])){
        [self showAlertViewTitle:@"您输入验证码有误，请重新输入" message:nil];
        return;
    }
  
    //手机号码存入用户单例中已验证过的手机号
    manager.confirmPhoneNum = mobileTF.text;
    //手机号码存入当前的用户单例
    manager.phone = mobileTF.text;
    switch (manager.loginType) {
            //当前为手机号登录
        case JM_TokenTypePhone:{
            
            manager.loginName = [mobileTF.text stringByAppendingString:@"sj"];
            [BFOriginNetWorkingTool loginByLoginName:manager.loginName completionHandler:^(int code, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self loginByPhoneDealWithStateCode:code];
                   
                });
            }];
        }
            break;
            
            //当前是微信登录
        case JM_TokenTypeWX:
            //当前是微博登录
        case JM_TokenTypeWB:
            //当前是QQ登录
        case JM_TokenTypeQQ:
        {
            //当前登录方式为第三方登录
            //需要判断当前情况是不是已有账户
            if(manager.code == 202){
                //当前登录方式是老用户重新绑定手机号 统一调用尝试绑定接口（参数false）
                [BFOriginNetWorkingTool bindWithJmid:manager.jmId phoneNum:manager.confirmPhoneNum unBindIfExist:NO completionHandler:^(NSString *stateCode, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if(stateCode.intValue == 200){
                            //绑定成功
                            [manager saveUserInfo];
                            [self jumpToMainVC];
                        }else{
                            // 代表绑定失败   验证的手机号已绑定到其他账号  需客户端提示是否仍然绑定到当前账号  stateCode == 201
                            [self jumpToBindAlertController];
                        }
                    });
                    
                }];
            }else{
                
                // 统一调用新用户的接口
                [BFOriginNetWorkingTool newUserWithLoginName:manager.loginName phoneNum:manager.confirmPhoneNum unBindIfExist:NO completionHandler:^(NSString *newUserCode, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self CreatNewUserByThirdDealWithNewUserCode:newUserCode];
                    });
                    
                }];
            }
          
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - 第三方登录的后续处理
- (void)CreatNewUserByThirdDealWithNewUserCode:(NSString *)newUserCode{
#warning 这里需要确认接口调用方式
    int code = newUserCode.intValue;
    switch (code) {
        case 200:
            //新用户创建成功jmid保存到用户单例 跳转到个人信息界面
            [self jumpToUserEditVC];
            break;
        case 204:
            //用户当前验证的手机号已经和其他jmid绑定 需要提示解绑
            [self jumpToBindAlertController];
            break;
            
        default:
            break;
    }
}

#pragma mark - 手机登录的后续处理

- (void)loginByPhoneDealWithStateCode:(int )code{
    
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    switch (code) {
        case 200://授信且判断为老用户的情况 记录返回的jmid 跳转登录成功
            //判断此用户信息是否有头像和昵称
            if([manager.photo isKindOfClass:[NSString class]] && [manager.name isKindOfClass:[NSString class]]){
                //不缺基本信息 直接跳转到登录完成界面
                [self jumpToMainVC ];
                [manager saveUserInfo];
            }else{
                //缺失头像和昵称 需跳转到完善信息界面
                [self jumpToUserEditVC];
            }
            break;
            
        case 201://设备未授信  记录返回的jmid 需跳转到登录保护界面
            [self jumpToProtectVC];
            break;
            
        case 203://手机号登录的新用户  会返回jmid
            //需跳转创建用户信息界面 完善信息并提交到服务器 然后跳转到登录成功界面
            [self jumpToUserEditVC];
            break;
        case 202:
        case 207:
        case 208:
            //手机号登录  且手机号已绑定其他jmid 需要提示是否解绑
            [self jumpToBindAlertController];
            break;
        default:
            break;
    }
}
#pragma mark - 解绑逻辑代码
//调用解绑的接口
- (void)bindPhoneNumMethod{
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    //判断当前用户jmid是否存在（是否是老用户）
      if(manager.jmidExist == JM_JmidAlreadyExistTure){
          //存在则调用绑定手机号到指定jmid的接口
        [BFOriginNetWorkingTool bindWithJmid:manager.jmId phoneNum:manager.confirmPhoneNum unBindIfExist:true completionHandler:^(NSString *stateCode, NSError *error) {
            if(stateCode.intValue == 200){
                [self bindSuccess];
            }else{
                [self bindFailure];
            }
        }];
    }else{
        //不存在则创建新的账号
        [BFOriginNetWorkingTool newUserWithLoginName:manager.loginName phoneNum:manager.confirmPhoneNum unBindIfExist:true completionHandler:^(NSString *newUserCode, NSError *error) {
            if(newUserCode.intValue == 200){
                [self bindSuccess];
            }else{
                [self bindFailure];
            }
        }];
    }
}

/**
 绑定成功
 */
- (void)bindSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        NSString *str = [NSString stringWithFormat: @"已将手机号：%@ \n绑定到当前账号！",manager.confirmPhoneNum];
        manager.phone = manager.confirmPhoneNum;
        [self showAlertViewTitle:@"解绑成功!" message:str btnAction:^{
            //判断当前是否是新用户
            if(manager.isMissBaseUserInfo == YES){
                //新用户跳转到完善个人信息界面
                [self jumpToUserEditVC];
            }else{
                //老用户跳转到登录成功界面
                [manager saveUserInfo];
                [self jumpToMainVC];
            }
        }];
    });
}

/**
 绑定失败
 */
- (void)bindFailure{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertViewTitle:@"绑定失败！" message:@"一般不会看到此信息！"];
    });
}

#pragma mark - 跳转页面的方法

/**
 显示解绑界面
 */
- (void)jumpToBindAlertController{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否解绑" message:@"该手机号已经和其他近脉ID绑定，是否将其解绑？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"解绑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //这里调用解绑的接口 将当前手机号绑定到当前jmid账号
            [self bindPhoneNumMethod];
            //如果绑定前是208的状态（未绑定且未授信）则需要后台调授信的接口
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                [BFOriginNetWorkingTool validDeviceByJmid:[BFUserLoginManager shardManager].jmId completionHandler:^(NSString *stateCode, NSError *error) {
                    if(stateCode){
                        NSLog(@"授信当前设备成功 授信状态码是%@",stateCode);
                    }
                }];
            });
            
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消解绑 返回到手机号验证界面
#warning
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    });
    
    
}

/**
 跳转到登录保护界面
 */
- (void)jumpToProtectVC{
    dispatch_async(dispatch_get_main_queue(), ^{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LoginProtect" bundle:nil];
    LoginProtectViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LoginProtectViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    });
}

/**
 跳转到完善个人信息界面
 */
- (void)jumpToUserEditVC{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        EditUserMesgController *editVC = [[EditUserMesgController alloc]init];
        [self.navigationController pushViewController:editVC animated:YES];
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

#pragma mark - 这些事测试原生网络请求工具类的代码
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)testNSURLSession{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Content-Type"  : @"application/json"
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    
    
    //1.创建NSURLSession
    self.session = session;
    //@"http://10.2.193.85:9000
    //2.根据NSURLSession创建Task
    NSURL *url = [NSURL URLWithString:@"http://10.2.193.85:9000/validCode/send"];
    //创建一个请求对象，设置请求方法为POST，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSDictionary *dic = @{@"data":@{@"phone":mobileTF.text}};
    
    NSString *json = [self dictionaryToJson:dic];
    request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        //获取响应头信息
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if(error){
            NSLog(@"%@",error);
        }
        if(data){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //解析数据
            //        NSLog(@"%@\n%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],res.allHeaderFields);
            NSLog(@"回调数据 dict -> %@",dict);
        }
    }];
    //3.执行Task
    [dataTask resume];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    // 判断是否是信任服务器证书
    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 告诉服务器，客户端信任证书
        // 创建凭据对象
        NSURLCredential *credntial = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 通过completionHandler告诉服务器信任证书
        completionHandler(NSURLSessionAuthChallengeUseCredential,credntial);
    }
    NSLog(@"protectionSpace = %@",challenge.protectionSpace);
}
#pragma mark - 警示弹窗
- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg btnAction:(void(^)())btnAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            btnAction();
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
