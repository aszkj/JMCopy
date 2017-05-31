//
//  BFOriginNetWorkingTool+userRelations.h
//  BFTest
//
//  Created by JM on 2017/4/12.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFOriginNetWorkingTool.h"
#import "BFUserOthersSettingModel.h"

@interface BFOriginNetWorkingTool (userRelations)

+ (void)getuserRelationsModelWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid  completionHandler:(void(^)(BFUserOthersSettingModel *model , NSError *error))completionHandler;

+ (void)setRemarkNameWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid  remarkName:(NSString *)remarkName completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)getNickNameWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid  completionHandler:(void(^)(NSString *code,NSString *nickName,NSString *remarkName, NSError *error))completionHandler;

+ (void)deleteFansWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)addFollowWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)deleteFollowWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)addBlackListWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)delBlackListWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)complainWithJmid:(NSString *)jmid complainJmid:(NSString *)complainJmid reasonId:(NSString *)reasonId reason:(NSString *)reason completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)getFriendWithJmid:(NSString *)jmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)getFollowWithJmid:(NSString *)jmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)getFansWithJmid:(NSString *)jmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

+ (void)getBlackListWithJmid:(NSString *)jmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler;

@end
