//
//  BFUserLoginManager.m
//  BFTest
//
//  Created by JM on 2017/3/30.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#define showLoginManagerLog  YES

#import "EMSDK.h"
#import "BFUserLoginManager.h"
#import "BFOriginNetWorkingTool+login.h"

@implementation BFUserLoginManager

+ (instancetype)shardManager{
    
    static BFUserLoginManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BFUserLoginManager alloc] init];
        //第一次创建时从本地预加载
        [_instance loadLocalUserInfo];
    });
    
    return _instance;
}

-(NSString *)version{
    if(_version == nil){
        
        NSString *str = JMBASE_URL;
        if([str containsString:@"dev"]){
            _version = @"开发环境";
        }
        else if([str containsString:@"test"]){
            _version = @"测试环境";
        }
        else {
            _version = @"生产环境";
        }
    }
    return  _version;
}

/**
 用户信息对应的打印描述
 */
- (NSString *)description{
    return showLoginManagerLog ? [NSString stringWithFormat:@"\n manager.jmid = %@ \n manager.name = %@ \n manager.phone = %@ \n manager.photo = %@ \n manager.birthDay = %@ \n manager.isLogin = %@ \n manager.loginType = %@ \n manager.jmidExist = %@ \n manager.confirmPhoneNum = %@ \n manager.code = %zd \n manager.loginName = %@ \n manager.device = %@ \n manager.protectCode = %@ \n manager.sendCode = %@ \n manager.user_Code = %@ \n manager.qiniuImageToken = %@ \n manager.qiniu_url = %@ \n manager.wb_accessToken = %@ \n ",self.jmId,self.name,self.phone,self.photo,self.birthDay,self.isLogin?@"YES":@"NO",self.loginType == 1?@"wx":self.loginType == 2?@"QQ":self.loginType == 3?@"wb":@"phone",self.jmidExist==1?@"YES":self.jmidExist == 2?@"NO":@"unknow",self.confirmPhoneNum,self.code,self.loginName,self.device,self.protectCode,self.sendCode,self.user_Code,self.qiniuImageToken,self.qiniu_url,self.wb_accessToken]  :  @"";
}

- (BOOL)isLogin{
    return  self.code == 200 ? YES : NO;
}
- (void)setLoginType:(JM_TokenType)loginType{
    if(_loginType != loginType){
        //当用户的登录方式改变时 清空所有用户单例中存放的
        [self cleanAllUserInfo];
    }
    _loginType = loginType;
}

- (BOOL)isMissBaseUserInfo{
    if(self.name&&self.photo){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 重写一下的set方法  在格式正确的情况下才赋值
- (void)setJmId:(NSString *)jmId{
    if([jmId isKindOfClass:[NSNumber class]]){
        jmId = ((NSNumber *)jmId).stringValue;
    }
    if([jmId isKindOfClass:[NSString class]]){
        if(![_jmId isEqualToString:jmId]){
            //如果获得用户的jmid 则向环信请求登录
            [self loginToEMClientWithJmid:jmId];
            //当得到新的用户信息时 清空上一个用户的信息
            [self cleanLasterJmidInfo];
        }
        _jmId = jmId.copy;
    }
}
- (void)setName:(NSString *)name{
    if([name isKindOfClass:[NSString class]]){
        _name = name.copy;
    }
}
- (void)setSex:(NSString *)sex{
    if([sex isKindOfClass:[NSString class]]){
        _sex = sex.copy;
    }
}
- (void)setBirthDay:(NSString *)birthDay{
    if([birthDay isKindOfClass:[NSString class]]){
        _birthDay = birthDay.copy;
    }
}
- (void)setPhoto:(NSString *)photo{
    if([photo isKindOfClass:[NSString class]]){
        _photo = photo.copy;
    }
}
- (void)setCode:(int)code{
    _code = code;
}

#pragma mark - 登录和退出环信

/**
 登录环信
 */
- (void)loginToEMClientWithJmid:(NSString *)jmid{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if(error == nil){
        NSLog(@"上次登录环信已退出！");
        //加载用户好友信息
        [BFHXManager loadUserRelationshipsArrMWithJmid:jmid];
    }else{
        NSLog(@"上次登录退出环信失败！ aError ->%@",error);
        
    }

    
    [[EMClient sharedClient] loginWithUsername:jmid password:jmid completion:^(NSString *aUsername, EMError *aError) {
        NSLog(@"testStr ->%d",aError.code);
        if(aError == nil){
            NSLog(@"登录环信成功！");
            
            //配置环信推送选项
            [self setupEMClientPushOptions];
            
            //加载用户好友信息
            [BFHXManager loadUserRelationshipsArrMWithJmid:jmid];
        }else{
            NSLog(@"登录环信失败！ aError.code ->%zd",aError.code);
        }
    }];
 }

- (void)setupEMClientPushOptions{
    //环信初始化推送
    EMError *error = [[EMClient sharedClient] bindDeviceToken:self.APNSToken];
    if(error == nil){
        NSLog(@"环信离线推送注册成功");
        
        EMPushOptions *options = [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
        if(error == nil){
            NSLog(@"获取环信推送全局配置成功！");
            options.noDisturbStatus = EMPushNoDisturbStatusClose;
            options.displayStyle = EMPushDisplayStyleMessageSummary;
            options.displayName = [BFUserLoginManager shardManager].name;
            error = [[EMClient sharedClient] updatePushOptionsToServer];
            if(error == nil){
                NSLog(@"更新环信推送全局配置成功！");
            }else{
                NSLog(@"更新环信推送全局配置失败！code ->%zd",error.code);
            }
        }
    }
}

/**
 登出环信
 */
- (void)logoutFromEMClient{
    // 退出环信
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"\n环信退出成功\n");
    }
}


#pragma  mark - 管理用户信息相关
//持久化用户信息
- (void)saveUserInfo{
    NSDictionary *userInfo = (self.phone == nil) ?
    @{
      @"jmId":self.jmId,
      @"photo":self.photo,
      @"name":self.name,
      @"signature":self.signature
      } :
    @{
      @"jmId":self.jmId,
      @"photo":self.photo,
      @"name":self.name,
      @"phone":self.phone,
      @"signature":self.signature
      };
    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:USER_INFO_KEY];
    NSDictionary *user_Info =  USER_INFO_DICT;
    NSLog(@"\n储存在用户偏好设置中的userInfo ->%@",user_Info);
}
- (void)loadLocalUserInfo{
    NSDictionary *userInfo = USER_INFO_DICT;
    self.jmId = userInfo[@"jmId"];
    self.photo = userInfo[@"photo"];
    self.name = userInfo[@"name"];
    self.phone = userInfo[@"phone"];
    self.signature = userInfo[@"signature"];
}

//清除本地持久化得用户信息
- (void)cleanLocalUserInfo{
    //退出环信
    [self logoutFromEMClient];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_INFO_KEY];
    // 设置地图隐身状态
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:PRESENCEORHIDE];
    
    [self cleanAllUserInfo];
}
//清理内存中对应的用户信息
- (void)cleanAllUserInfo{
    _iconImage = nil;
    _jmId = nil;
    _photo = nil;
    _name = nil;
    _sex = nil;
    _birthDay = nil;
    _jmidExist = JM_JmidAlreadyExistUnknown;
    _confirmPhoneNum = nil;
    _code = 0;
    _loginName = nil;
    _meta_code = nil;
    _phone = nil;
    _protectCode = nil;
    _sendCode = nil;
    _user_Code = nil;
    
    [self.timer_GPS invalidate];
    self.timer_GPS = nil;
    
    
}

//清理内存中对应上一个jmid的用户信息
- (void)cleanLasterJmidInfo{
    _name = nil;
    _photo = nil;
    _sex = nil;
    _birthDay = nil;
    
}

#pragma mark - 根据调不同接口返回的数据对用户信息进行增删改查

/**
 登录接口对应用户信息的处理
 */
- (void)setManagerWithLoginResponseDict:(NSDictionary *)dict completionHandler:(void (^)(int, NSError *))completionHandler{
    
    NSDictionary *meta = (NSDictionary *)dict[@"meta"];
    NSDictionary *data = (NSDictionary *)dict[@"data"];
    NSDictionary *user = (NSDictionary *)data[@"user"];
    NSNumber *code = (NSNumber *)meta[@"code"];
    
    _code = code.intValue;
    //根据登录状态码 判断当前登录名是否已有对应jmid 还是新用户
    switch (_code) {
        case 200:
        case 201:
        case 202:
        case 208:
            self.jmidExist = JM_JmidAlreadyExistTure;
            break;
        case 203:
        case 207:
            self.jmidExist = JM_JmidAlreadyExistFalse;
            break;
            
        default:
            self.jmidExist = JM_JmidAlreadyExistUnknown;
            break;
    }
    if(_code == 200){
        id jmid = user[@"jmid"];
        if([jmid isKindOfClass:[NSString class]]){
            self.jmId = jmid;
        }else if([jmid isKindOfClass:[NSValue class]]){
            self.jmId = ((NSNumber *)jmid).stringValue;
        }
        
    }else{
        id jmid = data[@"jmid"];
        if([jmid isKindOfClass:[NSString class]]){
            self.jmId = jmid;
        }else if([jmid isKindOfClass:[NSValue class]]){
            self.jmId = ((NSNumber *)jmid).stringValue;
        }
    }
    self.name = user[@"name"];
    self.photo = user[@"photo"];
    self.phone = user[@"phone"];
    self.protectCode = user[@"protectCode"];
    NSLog(@"\n登录接口的状态码是->%zd",_code);
    completionHandler(_code,nil);
    //当前用户为手机且为新用户时将对应手机号设置为已经短信确认过的手机号
    if(_code == 203 && self.loginType == JM_TokenTypePhone){
        self.phone = self.confirmPhoneNum;
    }
    
}

/**
 发送验证码接口对应用户信息的处理
 */- (void)setManagerWithSendResponseDict:(NSDictionary *)dict completionHandler:(void (^)(NSString *, NSError *))completionHandler{
     NSDictionary *data = (NSDictionary *)dict[@"data"];
     self.sendCode = data[@"code"];
     NSLog(@"\n当前服务器返回的验证码是 -> %@",_sendCode);
     completionHandler(_sendCode,nil);
 }

/**
 授信接口对应用户信息的处理
 */
- (void)setManagerWithValidDeviceResponseDict:(NSDictionary *)dict completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSLog(@"\n%@",dict);
}

/**
 创建新用户接口对应用户信息的处理
 */
- (void)setManagerWithNewUserResponseDict:(NSDictionary *)dict completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *meta = (NSDictionary *)dict[@"meta"];
    NSDictionary *data = (NSDictionary *)dict[@"data"];
    NSNumber *newUserCode = (NSNumber *)meta[@"code"];
    NSString *jmid = data[@"jmid"];
    if(newUserCode.intValue == 200){
        //如果返回200表示创建新用户jmid成功
        self.jmidExist = JM_JmidAlreadyExistTure;
        self.jmId = jmid;
    }
    self.user_Code = newUserCode.stringValue;
    completionHandler(_user_Code,nil);
}

/**
 完善用户基本信息接口对应用户信息的处理
 */
- (void)setManagerWithGetUploadResponseDict:(NSDictionary *)dict completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *data = (NSDictionary *)dict[@"data"];
    NSString *upToken = (NSString *)data[@"upToken"];
    NSString *url = (NSString *)data[@"url"];
    if([upToken isKindOfClass:[NSString class]]){
        [BFUserLoginManager shardManager].qiniuImageToken = upToken;
        [BFUserLoginManager shardManager].qiniu_url = url;
        completionHandler(upToken,nil);
    }
}

/**
 绑定手机接口对应用户信息的处理
 */
- (void)setManagerWithBindResponseDict:(NSDictionary *)dict completionHandler:(void (^)(NSString *bindCode, NSError *error))completionHandler{
    NSDictionary *meta = (NSDictionary *)dict[@"meta"];
    NSDictionary *data = (NSDictionary *)dict[@"data"];
    NSDictionary *user = (NSDictionary *)data[@"user"];
    NSNumber *code = (NSNumber *)meta[@"code"];
    if(code.intValue == 200){
        self.jmId = user[@"jmid"];
        self.name = user[@"name"];
        self.photo = user[@"photo"];
        self.phone = user[@"phone"];
    }else{
        NSLog(@"未绑定成功！");
    }
    completionHandler(code.stringValue,nil);
}
//- (void)testClient{
////    [[EMClient sharedClient].contactManager addContact:@"342460967168" message:@"hello world!"];
//    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:@"342460967168"];
//    if (!error) {
//        NSLog(@"发送同意成功");
//    }
//}

@end
