//
//  BFOriginNetWorkingTool+login.m
//  BFTest
//
//  Created by JM on 2017/3/30.
//  Copyright © 2017年 bofuco. All rights reserved.
//

//获得手机的唯一标识符
#define deviceUUID   [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#import "BFOriginNetWorkingTool+login.h"


@implementation BFOriginNetWorkingTool (login)

+ (void)loginByLoginName:(NSString *)loginName completionHandler:(void(^)(int code , NSError *error))completionHandler {
       NSDictionary *parameters = @{
                                 @"data":@{
                                         @"loginName":loginName ,
                                         @"phoneType":@"iPhone",
                                         @"device":deviceUUID
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JMLOGIN_URL parameters:parameters success:^(NSDictionary *responseObject) {
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        [manager setManagerWithLoginResponseDict:responseObject completionHandler:^(int code, NSError *error) {
            completionHandler(code,nil);
        }];
    } failure:^(NSError *error) {
        completionHandler(0,error);
    }];
}

+ (void)sendToPhoneNum:(NSString *)phoneNum completionHandler:(void(^)(NSString *sendCode, NSError *error))completionHandler{
    
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"phone":phoneNum ,
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JMSENDCODE_URL parameters:parameters success:^(NSDictionary *responseObject) {
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        [manager setManagerWithSendResponseDict:responseObject completionHandler:^(NSString *sendCode, NSError *error) {
            completionHandler(sendCode,nil);
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
    
    
}

+ (void)newUserWithLoginName:(NSString *)loginName phoneNum:(NSString *)phoneNum unBindIfExist:(BOOL)trueOrFalse completionHandler:(void(^)(NSString *newUserCode , NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"loginName":loginName,
                                         @"phone":phoneNum ,
                                         @"unBindIfExist":trueOrFalse == YES ? @"true" : @"false"
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JMNEWUSER_URL parameters:parameters success:^(NSDictionary *responseObject) {
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        [manager setManagerWithNewUserResponseDict:responseObject completionHandler:^(NSString *newUserCode, NSError *error) {
            completionHandler(newUserCode,nil);
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
    
}

+ (void)bindWithJmid:(NSString *)jmid phoneNum:(NSString *)phoneNum unBindIfExist:(BOOL)trueOrFalse completionHandler:(void(^)(NSString *stateCode , NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":jmid,
                                         @"phone":phoneNum,
                                         @"phoneType":@"iPhone",
                                         @"device":deviceUUID,
                                         @"unBindIfExist":trueOrFalse == YES ? @"true" : @"false"
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JMBINDPHONE_URL parameters:parameters success:^(NSDictionary *responseObject) {
        NSLog(@"绑定结果 ->%@",responseObject);
        [[BFUserLoginManager shardManager] setManagerWithBindResponseDict:responseObject completionHandler:^(NSString *bindCode, NSError *error) {
                completionHandler(bindCode,nil);
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)finisnInfoCompletionHandler:(void (^)(NSError *))completionHandler{
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":manager.jmId,
                                         @"photo":manager.photo,
                                         @"name":manager.name,
                                         @"sex":[manager.sex isEqualToString:@"男"]?@"0":@"1",
                                         @"birthday":manager.birthDay,
                                          @"device":deviceUUID,
                                         @"phoneType":@"iPhone"
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JMFINISNINFO_URL parameters:parameters success:^(NSDictionary *responseObject) {
         NSLog(@"上传用户资料结果 ->%@",responseObject);
        completionHandler(nil);
    } failure:^(NSError *error) {
        completionHandler(error);
    }];
}

+ (void)validDeviceByJmid:(NSString *)jmid completionHandler:(void(^)(NSString *stateCode , NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":jmid,
                                         @"device":deviceUUID
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JMVALIDDEVICE_URL parameters:parameters success:^(NSDictionary *responseObject) {
        NSLog(@"授信结果->%@",responseObject);
        [[BFUserLoginManager shardManager] setManagerWithValidDeviceResponseDict:responseObject completionHandler:^(NSString *stateCode, NSError *error) {
            completionHandler(stateCode,nil);
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)getUploadTokenWith:(NSString *)qiniuStr completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JMGETUPLOAD_URL parameters:parameters success:^(NSDictionary *responseObject) {
        NSLog(@"授信结果->%@",responseObject);
        [[BFUserLoginManager shardManager] setManagerWithGetUploadResponseDict:responseObject completionHandler:^(NSString *qiniuToken, NSError *error) {
            completionHandler(qiniuToken,nil);
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    } ];
}

@end
