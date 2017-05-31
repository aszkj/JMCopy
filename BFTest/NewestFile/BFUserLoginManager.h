//
//  BFUserLoginManager.h
//  BFTest
//
//  Created by JM on 2017/3/30.
//  Copyright © 2017年 bofuco. All rights reserved.
//

/// 创建这个类的思路是 在整个APP运行周期中以单例的形式来管理当前的用户信息 对应的有处理登录网络请求的数据 以及用户信息的本地化
#import <Foundation/Foundation.h>

@interface BFUserLoginManager : NSObject

typedef  NS_ENUM(NSInteger, JM_TokenType) {
    JM_TokenTypeWX = 1,
    JM_TokenTypeQQ = 2,
    JM_TokenTypeWB = 3,
    JM_TokenTypePhone = 4
};
typedef NS_ENUM(NSInteger,JM_JmidAlreadyExist){
    JM_JmidAlreadyExistUnknown = 0,
    JM_JmidAlreadyExistTure = 1,
    JM_JmidAlreadyExistFalse = 2
};

@property (nonatomic,strong)UIImage *iconImage;
/*---- 个人资料对应信息  -----*/
@property (nonatomic,copy)NSString *jmId;
@property (nonatomic,copy)NSString *photo;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *birthDay;
@property (nonatomic,copy)NSString *signature;


/*---- 用户当前的登录状态  -----*/
@property (nonatomic,assign,readonly)BOOL isLogin;
/*---- 用户当前登录类型  -----*/
@property (nonatomic,assign)JM_TokenType loginType;
/*---- jmId是否是新创建的  -----*/
@property (nonatomic,assign)JM_JmidAlreadyExist jmidExist;
/*---- 当前已验证成功的手机号  -----*/
@property (nonatomic,copy)NSString *confirmPhoneNum;
/*---- 当前用户单例是否缺失基本信息  -----*/
@property (nonatomic,readonly,assign)BOOL isMissBaseUserInfo;

/*---- 当前环境  -----*/
@property (nonatomic,copy) NSString *version;


/*---- 负责用户坐标轮询上传的定时器  -----*/
@property (nonatomic,strong) NSTimer *timer_GPS;

/*---- 处理网络请求返回的数据  -----*/
@property (nonatomic,assign)int code;
@property (nonatomic,copy)NSString *loginName;
@property (nonatomic,copy)NSString *device;
@property (nonatomic,copy)NSString *meta_code;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *protectCode;
@property (nonatomic,copy)NSString *sendCode;
@property (nonatomic,copy)NSString *user_Code;
@property (nonatomic,copy)NSString *qiniuImageToken;
@property (nonatomic,copy)NSString *wb_accessToken;
@property (nonatomic,copy)NSData *APNSToken;
@property (nonatomic,copy)NSString *qiniu_url;
@property (nonatomic,copy)NSString *wx_accessToken;



+ (instancetype)shardManager;
//登出环信
- (void)logoutFromEMClient;
//登录环信
- (void)loginToEMClientWithJmid:(NSString *)jmid;
//保存所有用户信息到本地偏好设置
- (void)saveUserInfo;

- (void)cleanLocalUserInfo;

- (void)setManagerWithLoginResponseDict:(NSDictionary *)dict completionHandler:(void(^)(int code , NSError *error))completionHandler ;
- (void)setManagerWithSendResponseDict:(NSDictionary *)dict completionHandler:(void(^)(NSString *sendCode , NSError *error))completionHandler ;
- (void)setManagerWithValidDeviceResponseDict:(NSDictionary *)dict completionHandler:(void(^)(NSString *stateCode , NSError *error))completionHandler ;
- (void)setManagerWithNewUserResponseDict:(NSDictionary *)dict completionHandler:(void(^)(NSString *newUserCode , NSError *error))completionHandler ;
- (void)setManagerWithGetUploadResponseDict:(NSDictionary *)dict completionHandler:(void (^)(NSString *qiniuImageToken, NSError *error))completionHandler;
- (void)setManagerWithBindResponseDict:(NSDictionary *)dict completionHandler:(void (^)(NSString *bindCode, NSError *error))completionHandler;

@end
