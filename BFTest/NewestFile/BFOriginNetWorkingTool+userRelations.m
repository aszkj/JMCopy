//
//  BFOriginNetWorkingTool+userRelations.m
//  BFTest
//
//  Created by JM on 2017/4/12.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFOriginNetWorkingTool+userRelations.h"
#import "YYModel.h"
#import "BFUserInfoModel.h"

@implementation BFOriginNetWorkingTool (userRelations)

//拿到用户之间的关系
+ (void)getuserRelationsModelWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void (^)(BFUserOthersSettingModel *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JM_USER_GETUSERRELATIONS parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *data = responseObject[@"data"];
        if(data.allKeys.count < 1){
            NSLog(@"用户关系返回数据为空！");
            return ;
        }
        BFUserOthersSettingModel *model = [BFUserOthersSettingModel yy_modelWithDictionary:data];
       
        completionHandler(model,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

//改备注名称
+ (void)setRemarkNameWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid remarkName:(NSString *)remarkName completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid,
                                         @"remarkName":remarkName
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_SETREMARKNAME parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = (NSDictionary *)responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}


+ (void)getNickNameWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid  completionHandler:(void(^)(NSString *code,NSString *nickName,NSString *remarkName, NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid,
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_GETNICKNAME parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = (NSDictionary *)responseObject[@"meta"];
        NSDictionary *data = responseObject[@"data"];
        NSString *code = meta[@"code"];
        NSString *nickName = [data[@"nickName"]isKindOfClass:[NSString class]]?data[@"nickName"]:nil;
        NSString *remarkName = [data[@"remarkName"] isKindOfClass:[NSString class]]?data[@"remarkName"]:nil;
        completionHandler(code,nickName,remarkName,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,nil,nil,error);
    }];

}

+ (void)deleteFansWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid,
                                         @"relationId":@"1"
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_DELFANS parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
        //用户关系改变时 刷新内存中的好友列表
        [self getFriendWithJmid:selfJmid completionHandler:^(NSString *code, NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)addFollowWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void(^)(NSString *code , NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JM_USER_ADDFOLLOW parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
        //用户关系改变时 刷新内存中的好友列表
        [self getFriendWithJmid:selfJmid completionHandler:^(NSString *code, NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)deleteFollowWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_DELFOLLOW parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
        //用户关系改变时 刷新内存中的好友列表
        [self getFriendWithJmid:selfJmid completionHandler:^(NSString *code, NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)delBlackListWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_DELBLACKLIST parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    } ];
}


+ (void)addBlackListWithSelfJmid:(NSString *)selfJmid otherJmid:(NSString *)otherJmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":selfJmid,
                                         @"relationJmid":otherJmid
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_ADDBLACKLIAT parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}


+ (void)complainWithJmid:(NSString *)jmid complainJmid:(NSString *)complainJmid reasonId:(NSString *)reasonId reason:(NSString *)reason completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":jmid,
                                         @"complainJmid":complainJmid,
                                         @"causeId":reasonId,
                                         @"complainJmid":reason
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_COMPLAIN parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)getFriendWithJmid:(NSString *)jmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    NSDictionary *parameters =@{
                                @"data":@{
                                        @"jmid":jmid,
                                        }
                                };
    [BFOriginNetWorkingTool postWithURLString:JM_USER_GETFRIEND parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSDictionary *data = responseObject[@"data"];
        NSArray *listFriend = data[@"listFriend"];
        NSString *code = meta[@"code"];
        if(code.intValue == 200){
            BFHXManager *manager = [BFHXManager shareManager];
            [manager.friendsArrM removeAllObjects];
            for(NSDictionary *dict in listFriend){
                BFUserInfoModel *model = [BFUserInfoModel yy_modelWithDictionary:dict];
                [manager.friendsArrM addObject:model];
            }
        }
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)getFollowWithJmid:(NSString *)jmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    static int pageNum = 1;
    static BOOL haveNextPage = YES;
    
        NSDictionary *parameters =@{
                                    @"data":@{
                                            @"jmid":jmid,
                                            @"pageNum":@(pageNum).stringValue
                                            }
                                    };
        
        [BFOriginNetWorkingTool postWithURLString:JM_USER_GETFOLLOWS parameters:parameters success:^(NSDictionary *responseObject) {
            NSDictionary *meta = responseObject[@"meta"];
            NSDictionary *data = responseObject[@"data"];
            NSString *_haveNextPage = data[@"haveNextPage"];
            haveNextPage = _haveNextPage.intValue;
            
            NSArray *followList = data[@"followList"];
            NSString *code = meta[@"code"];
            
            if(code.intValue == 200){
                NSMutableArray *followArrM = [NSMutableArray array];
                for(NSDictionary *dict in followList){
                    BFUserInfoModel *model = [BFUserInfoModel yy_modelWithDictionary:dict];
                    [followArrM addObject:model];
                }
                [BFHXManager shareManager].followArrM = [followArrM mutableCopy];
                
                if(haveNextPage == YES){
                    pageNum ++;
                    [self getFollowWithJmid:jmid completionHandler:^(NSString *code, NSError *error) {}];
                }else{
                    pageNum = YES;
                    pageNum = 1;
                }
                
            }
            completionHandler(code,nil);
        } failure:^(NSError *error) {
            completionHandler(nil,error);
        }];
}

+ (void)getFansWithJmid:(NSString *)jmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    
    static int pageNum = 1;
    static BOOL haveNextPage = YES;
    
    NSDictionary *parameters =@{
                                @"data":@{
                                        @"jmid":jmid,
                                        @"pageNum":@(pageNum).stringValue
                                        }
                                };
    [BFOriginNetWorkingTool postWithURLString:JM_USER_GETFANS parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSDictionary *data = responseObject[@"data"];
        
        NSString *_haveNextPage = data[@"haveNextPage"];
        haveNextPage = _haveNextPage.intValue;

        
        NSArray *fansList = data[@"fansList"];
        NSString *code = meta[@"code"];
        if(code.intValue == 200){
            NSMutableArray *fansArrM = [NSMutableArray array];
            for(NSDictionary *dict in fansList){
                BFUserInfoModel *model = [BFUserInfoModel yy_modelWithDictionary:dict];
                [fansArrM addObject:model];
            }
            [BFHXManager shareManager].fansArrM = [fansArrM mutableCopy];
            
            if(haveNextPage == YES){
                pageNum ++;
                [self getFansWithJmid:jmid completionHandler:^(NSString *code, NSError *error) {}];
            }else{
                pageNum = YES;
                pageNum = 1;
            }
        }
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)getBlackListWithJmid:(NSString *)jmid completionHandler:(void (^)(NSString *, NSError *))completionHandler{
    
    static int pageNum = 1;
    static BOOL haveNextPage = YES;

    
    NSDictionary *parameters =@{
                                @"data":@{
                                        @"jmid":jmid,
                                        @"pageNum":@(pageNum).stringValue
                                        }
                                };
    [BFOriginNetWorkingTool postWithURLString:JM_USER_GETBLACKLIST parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSDictionary *data = responseObject[@"data"];
        
        NSString *_haveNextPage = data[@"haveNextPage"];
        haveNextPage = _haveNextPage.intValue;

        
        NSArray *blackList = data[@"blackList"];
        NSString *code = meta[@"code"];
        if(code.intValue == 200){
            NSMutableArray *blackListArrM = [NSMutableArray array];
            for(NSDictionary *dict in blackList){
                BFUserInfoModel *model = [BFUserInfoModel yy_modelWithDictionary:dict];
                [blackListArrM addObject:model];
            }
             [BFHXManager shareManager].blackListArrM = [blackListArrM mutableCopy];
            
            if(haveNextPage == YES){
                pageNum ++;
                [self getBlackListWithJmid:jmid completionHandler:^(NSString *code, NSError *error) {}];
            }else{
                pageNum = YES;
                pageNum = 1;
            }
        }
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
    
}

@end
