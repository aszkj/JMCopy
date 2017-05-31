//
//  BFOriginNetWorkingTool+userInfo.h
//  BFTest
//
//  Created by JM on 2017/4/5.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFOriginNetWorkingTool.h"
#import "BFUserInfoModel.h"

@interface BFOriginNetWorkingTool (userInfo)

+ (void)getUserInfoByJmid:(NSString *)jmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(BFUserInfoModel *model , NSError *error))completionHandler;

+ (void)updateUserInfoByUserInfoModel:(BFUserInfoModel *)model completionHandler:(void (^)(NSString *code, NSError *error))completionHandler;

+ (void)searchUserByJmid:(NSString *)jmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(NSMutableArray <BFUserInfoModel *>*arrM , NSError *error))completionHandler;

@end


