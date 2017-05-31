//
//  BFOriginNetWorkingTool+login.h
//  BFTest
//
//  Created by JM on 2017/3/30.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFOriginNetWorkingTool.h"
#import "BFUserLoginManager.h"

@interface BFOriginNetWorkingTool (login)

+ (void)loginByLoginName:(NSString *)loginName completionHandler:(void(^)(int code , NSError *error))completionHandler;

+ (void)sendToPhoneNum:(NSString *)phoneNum completionHandler:(void(^)(NSString *sendCode, NSError *error))completionHandler;

+ (void)newUserWithLoginName:(NSString *)loginName phoneNum:(NSString *)phoneNum unBindIfExist:(BOOL)trueOrFalse completionHandler:(void(^)(NSString *newUserCode , NSError *error))completionHandler;

+ (void)bindWithJmid:(NSString *)jmid phoneNum:(NSString *)phoneNum unBindIfExist:(BOOL)trueOrFalse completionHandler:(void(^)(NSString *stateCode , NSError *error))completionHandler;

+ (void)finisnInfoCompletionHandler:(void(^)(NSError *error))completionHandler;

+ (void)validDeviceByJmid:(NSString *)jmid completionHandler:(void(^)(NSString *stateCode , NSError *error))completionHandler;

/*---- 这里拿到返回的七牛云token  -----*/
+ (void)getUploadTokenWith:(NSString *)qiniuStr completionHandler:(void(^)(NSString *qiniuToken , NSError *error))completionHandler;

@end
