//
//  BFOriginNetWorkingTool+userInfo.m
//  BFTest
//
//  Created by JM on 2017/4/5.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#import "YYModel.h"
#import "BFOriginNetWorkingTool+userInfo.h"

@implementation BFOriginNetWorkingTool (userInfo)

/**
 拉取用户信息
 */
+ (void)getUserInfoByJmid:(NSString *)jmid otherJmid:(NSString *)otherJmid completionHandler:(void (^)(BFUserInfoModel *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":jmid,
                                        @"otherJmid":otherJmid
                                          }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JM_USER_GETUSERINFO parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *data = responseObject[@"data"];
        BFUserInfoModel *model = [BFUserInfoModel yy_modelWithDictionary:data];
        if ([jmid isEqualToString:otherJmid]){
            BFUserLoginManager *manager = [BFUserLoginManager shardManager];
            manager.name = model.name;
            manager.photo = model.photo;
            manager.signature = model.signature;
            [manager saveUserInfo];
        }
        completionHandler(model,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}
+ (void)searchUserByJmid:(NSString *)jmid otherJmid:(NSString *)otherJmid completionHandler:(void (^)(NSMutableArray<BFUserInfoModel *> *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":jmid,
                                         @"searchJmid":otherJmid
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JM_USER_SEARCHUSERBYJMID parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSArray *list = data[@"list"];
        NSMutableArray *arrM = [NSMutableArray array];
        for(NSDictionary *dict in list){
            BFUserInfoModel *model = [BFUserInfoModel yy_modelWithDictionary:dict];
            model ? [arrM addObject:model] : nil;
        }
        completionHandler(arrM,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];

}

+ (void)updateUserInfoByUserInfoModel:(BFUserInfoModel *)model completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":model.jmid,
                                         @"name":model.name,
                                         @"birthday":model.birthday,
                                         @"single":model.single,
                                         @"fromArea":model.fromArea,
                                         @"industry":model.industry,
                                         @"occupation":model.occupation,
                                         @"school":model.school,
                                         @"signature":model.signature,
                                         @"datePlace":model.datePlace,
                                         @"photo":model.photo,
                                         @"listUserPhotos":model.listUserPhotos
                                         }
                                 };
    BFUserLoginManager * manager = [BFUserLoginManager shardManager];
    manager.name = model.name;
    manager.photo = model.photo;
    manager.birthDay = model.birthday;
    manager.signature = model.signature;
    
    [manager saveUserInfo];

    [BFOriginNetWorkingTool postWithURLString:JM_USER_UPDATEUSERINFO parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
    
}

@end












