//
//  BFHXManager.m
//  BFTest
//
//  Created by JM on 2017/4/15.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#import "BFHXDelegateManager+Client.h"
#import "BFHXDelegateManager+call.h"
#import "BFHXDelegateManager+Chat.h"
#import "BFHXDelegateManager+Group.h"
#import "BFHXDelegateManager+Contact.h"
#import "BFHXDelegateManager+Chatroom.h"


#import "BFOriginNetWorkingTool+userRelations.h"
#import "BFOriginNetWorkingTool+userInfo.h"

#import "IEMCallManager.h"

#import "BFHXManager.h"


static BOOL showJmidList = NO;


@interface BFHXManager ()



@end

@implementation BFHXManager
#pragma  mark - 懒加载用户关系数组
- (NSMutableArray<BFUserInfoModel *> *)fansArrM{
    if(_fansArrM == nil){
        _fansArrM = [[NSMutableArray alloc]init];
    }
    return _fansArrM;
}

-(NSMutableArray<BFUserInfoModel *> *)followArrM{
    if(_followArrM == nil){
        _followArrM = [[NSMutableArray alloc]init];
    }
    return _followArrM;
}

- (NSMutableArray<BFUserInfoModel *> *)friendsArrM{
    if(_friendsArrM == nil){
        _friendsArrM = [[NSMutableArray alloc]init];
    }
    return _friendsArrM;
}
- (NSMutableArray<BFUserInfoModel *> *)blackListArrM{
    if(_blackListArrM == nil){
        _blackListArrM = [[NSMutableArray alloc]init];
    }
    return _blackListArrM;
}
- (NSMutableArray<BFUserInfoModel *> *)strangerArrM{
    if(_strangerArrM == nil){
        _strangerArrM = [[NSMutableArray alloc]init];
    }
    return _strangerArrM;
}


#pragma mark - 配置环信
+ (instancetype)setupEMClientApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appkey:(NSString *)appkey apnsCertName:(NSString *)apnsCertName otherConfig:(NSDictionary *)otherConfig{
    
    BFHXManager *manager = [self shareManager];
    
    //初始化环信
    [manager hyphenateApplication:application
    didFinishLaunchingWithOptions:launchOptions
                           appkey:appkey
                     apnsCertName:apnsCertName
                      otherConfig:otherConfig];
    
    //配置环信EMClient的代理
    [manager setupDelegateManagerForEMClient];
    
    
    return manager;
}


#pragma mark - 加载用户关系


/**
 从应用服务器加载所有用户关系
 */
+ (void)loadUserRelationshipsArrMWithJmid:(NSString *)jmid{
    [self loadFriendArrMWithJmid:jmid];
    [self loadFollowArrMWithJmid:jmid];
    [self loadFansArrMWithJmid:jmid];
    [self loadBlackListArrMWithJmid:jmid];
}

/**
 登录成功后加载用户的朋友列表
 */
+ (void)loadFriendArrMWithJmid:(NSString *)jmid{
    [BFOriginNetWorkingTool getFriendWithJmid:jmid completionHandler:^(NSString *code, NSError *error) {
        if(code.intValue == 200){
            NSLog(@"获取用户好友信息成功！");
            BFHXManager *manager = [BFHXManager shareManager];
            if(manager.fansArrM.count + manager.friendsArrM.count + manager.followArrM.count + manager.blackListArrM.count >= 4){
                [manager logCurrentRelationship];
            }
        }else{
            NSLog(@"获取用户好友信息失败！");
        }
    }];
}

/**
 登录成功后加载用户的关注列表
 */
+ (void)loadFollowArrMWithJmid:(NSString *)jmid{
    [BFOriginNetWorkingTool getFollowWithJmid:jmid completionHandler:^(NSString *code, NSError *error) {
        if(code.intValue == 200){
            NSLog(@"获取用户关注信息成功！");
            BFHXManager *manager = [BFHXManager shareManager];
            if(manager.fansArrM.count + manager.friendsArrM.count + manager.followArrM.count + manager.blackListArrM.count >= 4){
                [manager logCurrentRelationship];
            }
        }else{
            NSLog(@"获取用户关注信息失败！");
        }
    }];
    
}

/**
 登录成功后加载用户的粉丝列表
 */
+ (void)loadFansArrMWithJmid:(NSString *)jmid{
    [BFOriginNetWorkingTool getFansWithJmid:jmid completionHandler:^(NSString *code, NSError *error) {
        if(code.intValue == 200){
            NSLog(@"获取用户粉丝信息成功！");
            BFHXManager *manager = [BFHXManager shareManager];
            if(manager.fansArrM.count + manager.friendsArrM.count + manager.followArrM.count + manager.blackListArrM.count >= 4){
                [manager logCurrentRelationship];
            }
        }else{
            NSLog(@"获取用户粉丝信息失败！");
        }
    }];
    
}

/**
 登录成功后加载用户的黑名单列表
 */
+ (void)loadBlackListArrMWithJmid:(NSString *)jmid{
    [BFOriginNetWorkingTool getBlackListWithJmid:jmid completionHandler:^(NSString *code, NSError *error) {
        if(code.intValue == 200){
            NSLog(@"获取用户黑名单信息成功！");
            BFHXManager *manager = [BFHXManager shareManager];
            if(manager.fansArrM.count + manager.friendsArrM.count + manager.followArrM.count + manager.blackListArrM.count >= 4){
                [manager logCurrentRelationship];
            }
        }else{
            NSLog(@"获取用户黑名单信息失败！");
        }
    }];
    
}


#pragma mark - 改变用户关系

/**
 添加关注到其他用户
 */
+ (void)addFollowToOtherJmid:(NSString *)otherJmid asMyship:(AsMyShipType)shipType callBack:(void(^)(NSString *))callBack{
    
    BFHXManager *manager = [self shareManager];
    switch (shipType) {
        case AsMyShipTypeFans:
            [manager makeFansToFirendWithJmid:otherJmid callBack:callBack];
            break;
        case AsMyShipTypeStranger:
            [manager makeNoneToFollowWithJmid:otherJmid callBack:callBack];
            break;
        default:
            break;
    }
}

/**
 移除粉丝 从其他用户
 */
+ (void)deleteFansFromOtherJmid:(NSString *)otherJmid asMyship:(AsMyShipType)shipType callBack:(void(^)(NSString *))callBack{
    BFHXManager *manager = [self shareManager];
    
    switch (shipType) {
        case AsMyShipTypeFans:
            [manager makeFansToNoneWithJmid:otherJmid callBack:callBack];
            break;
        case AsMyShipTypeFriend:
            [manager makeFriendToFollowWithJmid:otherJmid callBack:callBack];
            break;
            
        default:
            break;
    }
}

/**
 添加用户到黑名单
 */
+ (void)addBlackListWithOtherJmid:(NSString *)otherJmid callBack:(void(^)(NSString *))callBack{
//    BFHXManager *manager = [self shareManager];
//    BOOL inBlackList = [manager containJmid:otherJmid inList:manager.blackListArrM];
//    if(inBlackList == YES){
//        NSLog(@"黑名单不包含->黑名单不同步！！！");
//    }
    EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:otherJmid relationshipBoth:YES];
    if(error){
        NSLog(@"环信添加黑名单失败！");
    }else{
        NSLog(@"环信添加黑名单成功！");
    [BFOriginNetWorkingTool addBlackListWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
        
        if(code.intValue == 200){
            NSLog(@"后台接口添加至黑名单成功！");
        }else{
            NSLog(@"后台接口添加至黑名单失败！");;
        }
        if(callBack){
            callBack(code);
        }

    }];
   }
}

/**
 把用户从黑名单移除
 */
+ (void)deleteBlackListWithOtherJmid:(NSString *)otherJmid callBack:(void(^)(NSString *))callBack{
//    BFHXManager *manager = [self shareManager];
//    BOOL inBlackList = [manager containJmid:otherJmid inList:manager.blackListArrM];
//    if(inBlackList == NO){
//        NSLog(@"黑名单不包含->黑名单不同步！！！");
//    }
    EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:otherJmid];
    
    if(error){
        NSLog(@"环信从黑名单移除失败！");
    }else{
        NSLog(@"环信从黑名单移除成功！");
        [BFOriginNetWorkingTool delBlackListWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
            
            if(code.intValue == 200){
                NSLog(@"后台接口从黑名单移除成功！");
            }else{
                NSLog(@"后台接口从黑名单移除失败！");;
            }
            if(callBack){
                callBack(code);
            }
        }];
    }
}
    
    
    

/**
 取消关注到其他用户
 */
+ (void)deleteFollowToOtherJmid:(NSString *)otherJmid asMyship:(AsMyShipType)shipType callBack:(void(^)(NSString *))callBack{
    
    BFHXManager *manager = [self shareManager];
    
    switch (shipType) {
        case AsMyShipTypeFollow:
            [manager makeFollowToNoneWithJmid:otherJmid callBack:callBack];
            break;
        case AsMyShipTypeFriend:
            [manager makeFriendToFansWithJmid:otherJmid callBack:callBack];
            break;
        default:
            break;
    }
}



- (void)makeFansToFirendWithJmid:(NSString *)otherJmid  callBack:(void(^)(NSString *))callBack{
    
    NSString *selfJmid = [BFUserLoginManager shardManager].jmId;
    NSString *message = [NSString stringWithFormat:@"Fans->Friend_From%@To%@",selfJmid,otherJmid];
    //同步队列 会引起线程阻塞
    EMError *error = [[EMClient sharedClient].contactManager addContact:otherJmid message:message];
    if(error){
        NSLog(@"环信添加关注失败！%@",message);
    }else{
        NSLog(@"环信添加关注成功！%@",message);
        [BFOriginNetWorkingTool addFollowWithSelfJmid:selfJmid otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
            if(callBack){
              callBack(code);
            }
            if(code.intValue == 200){
                NSLog(@"后台接口关注成功！%@",message);
                [BFHXManager loadUserRelationshipsArrMWithJmid:[BFUserLoginManager shardManager].jmId];
                
            }else{
                NSLog(@"后台接口关注失败！%@",message);
            }
        }];
    }
}



- (void)makeNoneToFollowWithJmid:(NSString *)otherJmid callBack:(void(^)(NSString *))callBack{
    
    NSString *selfJmid = [BFUserLoginManager shardManager].jmId;
    NSString *message = [NSString stringWithFormat:@"None->Follow_From%@To%@",selfJmid,otherJmid];
    //同步队列 会引起线程阻塞
    EMError *error = [[EMClient sharedClient].contactManager addContact:otherJmid message:message];
    if(error){
        NSLog(@"环信添加关注失败！%@",message);
    }else{
        NSLog(@"环信添加关注成功！%@",message);
        [BFOriginNetWorkingTool addFollowWithSelfJmid:selfJmid otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
            if(callBack){
                callBack(code);
            }
            if(code.intValue == 200){
                NSLog(@"后台接口关注成功！%@",message);
                
            }else{
                NSLog(@"后台接口关注失败！%@",message);
            }
        }];
    }
}

- (void)makeFansToNoneWithJmid:(NSString *)otherJmid callBack:(void(^)(NSString *))callBack{
    
    NSString *selfJmid = [BFUserLoginManager shardManager].jmId;
    NSString *message = [NSString stringWithFormat:@"Fans->None_From%@To%@",selfJmid,otherJmid];
    //同步队列 会引起线程阻塞
    EMError *error = [[EMClient sharedClient].contactManager addContact:otherJmid message:message];
    if(error){
        NSLog(@"环信移除粉丝失败！%@",message);
    }else{
        NSLog(@"环信移除粉丝成功！%@",message);
        [BFOriginNetWorkingTool deleteFansWithSelfJmid:selfJmid otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                if(callBack){
                    callBack(code);
                }
                NSLog(@"后台接口移除粉丝成功！%@",message);
//                [BFHXManager removeUserInfoModelFromAllListWithJmid:otherJmid];
            }else{
                NSLog(@"后台接口移除粉丝失败！%@",message);
            }
        }];
    }
}

- (void)makeFollowToNoneWithJmid:(NSString *)otherJmid callBack:(void(^)(NSString *))callBack{
    
    NSString *selfJmid = [BFUserLoginManager shardManager].jmId;
    NSString *message = [NSString stringWithFormat:@"Follow->None_From%@To%@",selfJmid,otherJmid];
    //同步队列 会引起线程阻塞
    EMError *error = [[EMClient sharedClient].contactManager addContact:otherJmid message:message];
    if(error){
        NSLog(@"环信取消关注失败！%@",message);
    }else{
        NSLog(@"环信取消关注成功！%@",message);
        [BFOriginNetWorkingTool deleteFollowWithSelfJmid:selfJmid otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                if(callBack){
                    callBack(code);
                }
                NSLog(@"后台接口取消关注成功！%@",message);
//                [BFHXManager removeUserInfoModelFromAllListWithJmid:otherJmid];
            }else{
                NSLog(@"后台接口取消关注失败！%@",message);
            }
        }];
    }
}

- (void)makeFriendToFansWithJmid:(NSString *)otherJmid callBack:(void(^)(NSString *))callBack{
    
    NSString *selfJmid = [BFUserLoginManager shardManager].jmId;
    NSString *message = [NSString stringWithFormat:@"Friend->Fans_From%@To%@",selfJmid,otherJmid];
    //同步队列 会引起线程阻塞
    EMError *error = [[EMClient sharedClient].contactManager deleteContact:otherJmid];
    if(error){
        NSLog(@"环信删除好友失败！%@",message);
    }else{
        NSLog(@"环信删除好友成功！%@",message);
        [BFOriginNetWorkingTool deleteFollowWithSelfJmid:selfJmid otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                if(callBack){
                    callBack(code);
                }
                NSLog(@"后台接口删除好友成功！%@",message);
//                [BFHXManager addUserInfoModelWithJmid:otherJmid toList:ManagerListTypeFans];
            }else{
                NSLog(@"后台接口删除好友失败！%@",message);
            }
        }];
    }
}
- (void)makeFriendToFollowWithJmid:(NSString *)otherJmid callBack:(void(^)(NSString *))callBack{
    
    NSString *selfJmid = [BFUserLoginManager shardManager].jmId;
    NSString *message = [NSString stringWithFormat:@"Friend->Follow_From%@To%@",selfJmid,otherJmid];
    //同步队列 会引起线程阻塞
    EMError *error = [[EMClient sharedClient].contactManager deleteContact:otherJmid];
    if(error){
        NSLog(@"环信删除好友失败！%@",message);
    }else{
        NSLog(@"环信删除好友成功！%@",message);
        [BFOriginNetWorkingTool deleteFansWithSelfJmid:selfJmid otherJmid:otherJmid completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                if(callBack){
                    callBack(code);
                }
                NSLog(@"后台接口删除好友成功！%@",message);
                //                [BFHXManager addUserInfoModelWithJmid:otherJmid toList:ManagerListTypeFans];
            }else{
                NSLog(@"后台接口删除好友失败！%@",message);
            }
        }];
    }
}




///**
// 环信BFHXmanager 所有数组中移除对应otherJmid的用户信息
// */
//+ (void)removeUserInfoModelFromAllListWithJmid:(NSString *)otherJmid {
//    BFHXManager *manager = [BFHXManager shareManager];
//    
//    BFUserInfoModel *targetModel = nil;
//    for(BFUserInfoModel *model in manager.fansArrM){
//        if([model.jmid isEqualToString:otherJmid]){
//            targetModel = model;
//        }
//    }
//    [manager.fansArrM removeObject:targetModel];
//    
//    targetModel = nil;
//    for(BFUserInfoModel *model in manager.followArrM){
//        if([model.jmid isEqualToString:otherJmid]){
//            targetModel = model;
//        }
//    }
//    [manager.followArrM removeObject:targetModel];
//    
//    targetModel = nil;
//    for(BFUserInfoModel *model in manager.friendsArrM){
//        if([model.jmid isEqualToString:otherJmid]){
//            targetModel = model;
//        }
//    }
//    [manager.friendsArrM removeObject:targetModel];
//}


/**
 环信BFHXmanager 添加对应otherJmid的用户信息 到指定的list中
 */
//+ (void)addUserInfoModelWithJmid:(NSString *)otherJmid toList:(ManagerListType)listType{
//    
//    //先从列表中移除
//    [self removeUserInfoModelFromAllListWithJmid:otherJmid];
//    //再从网络重新拉取用户数据 然后再添加到指定列表
//    [BFOriginNetWorkingTool getUserInfoByJmid:[BFUserLoginManager shardManager].jmId otherJmid:otherJmid completionHandler:^(BFUserInfoModel *model, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if(error){
//                NSLog(@"拉取用户信息失败 所在方法 -> addUserInfoModelWithJmid_ %@",error);
//            }else{
//                BFHXManager *manager = [BFHXManager shareManager];
//                switch (listType) {
//                    case ManagerListTypeFriend:
//                        [manager.friendsArrM addObject:model];
//                        break;
//                    case ManagerListTypeFollow:
//                        [manager.followArrM addObject:model];
//                        break;
//                    case ManagerListTypeFans:
//                        [manager.fansArrM addObject:model];
//                        break;
//                        
//                    default:
//                        break;
//                }
//            }
//        });
//    }];
//}


/**
 判断jmid在用户关系列表中的那个表中
 */
//- (ContainedByList)getOwnerListByJmid:(NSString *)jmid{
//    
//    ContainedByList containList = ContainedByListNone;
//    BOOL friendContain = [self containJmid:jmid inList:self.friendsArrM];
//    BOOL fansContain = [self containJmid:jmid inList:self.fansArrM];
//    BOOL followContain = [self containJmid:jmid inList:self.followArrM];
//    //当多个列表包含该用户时 返回错误枚举
//    if( friendContain + fansContain + followContain > 1){
//        NSLog(@"当前用户三个列表信息有误！");
//        return ContainedByListError;
//    }
//    
//    if(friendContain){
//        containList = ContainedByListFriendList;
//    }
//    if(fansContain){
//        containList = ContainedByListFansList;
//    }
//    if(followContain){
//        containList = ContainedByListFollowList;
//    }
//    return containList;
//}

//- (BOOL)containJmid:(NSString *)jmid inList:(NSArray *)list{
//    BOOL isContain = NO;
//    for(BFUserInfoModel *currentModel in list){
//        
//        if([currentModel.jmid isEqualToString:jmid]){
//            isContain = YES;
//        }
//    }
//    return isContain;
//}


#pragma mark - 初始化manager的方法

+ (instancetype)shareManager{
    static BFHXManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BFHXManager alloc] init];
        manager.delegateManager = [BFHXDelegateManager shareDelegateManager];
    });
    return manager;;
}

//设置环信的代理
- (void)setupDelegateManagerForEMClient{
    
    [[EMClient sharedClient] addDelegate:self.delegateManager];
    [[EMClient sharedClient].chatManager addDelegate:self.delegateManager];
    [[EMClient sharedClient].groupManager addDelegate:self.delegateManager];
    [[EMClient sharedClient].contactManager addDelegate:self.delegateManager];
    [[EMClient sharedClient].roomManager addDelegate:self.delegateManager];
    
    [[EMClient sharedClient].callManager addDelegate:self.delegateManager];
    
    BFHXDelegateManager *delegaterManager = self.delegateManager;
    [[NSNotificationCenter defaultCenter] addObserver:delegaterManager selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
    
    [EMClient sharedClient].pushOptions.displayStyle = EMPushDisplayStyleMessageSummary;
}

- (void)dealloc{
    [[EMClient sharedClient] removeDelegate:self.delegateManager];
    [[EMClient sharedClient].groupManager removeDelegate:self.delegateManager];
    [[EMClient sharedClient].contactManager removeDelegate:self.delegateManager];
    [[EMClient sharedClient].roomManager removeDelegate:self.delegateManager];
    [[EMClient sharedClient].chatManager removeDelegate:self.delegateManager];

    [[NSNotificationCenter defaultCenter] removeObserver:self.delegateManager name:KNOTIFICATION_CALL object:nil];
}



#pragma mark - 从当前用户列表中通过jmid获得用户名

+ (NSString *)getNameFromCurrentManagerListWithOtherJmid:(NSString *)otherJmid  callBack:(void(^)(NSString *))callBack{
    BFHXManager *manager = [BFHXManager shareManager];
    NSString *otherJmidName = nil;
    for(BFUserInfoModel *model in manager.fansArrM){
        if([model.jmid isEqualToString:otherJmid]){
            otherJmidName = showJmidList ? [NSString stringWithFormat:@"粉丝%@",model.name] : model.name;
            callBack(otherJmidName);
            return otherJmidName;
        }
    }
    for(BFUserInfoModel *model in manager.friendsArrM){
        if([model.jmid isEqualToString:otherJmid]){
            otherJmidName = showJmidList ? [NSString stringWithFormat:@"好友%@",model.name] : model.name;
            callBack(otherJmidName);
            return otherJmidName;
        }
    }
    for(BFUserInfoModel *model in manager.followArrM){
        if([model.jmid isEqualToString:otherJmid]){
            otherJmidName = showJmidList ? [NSString stringWithFormat:@"关注%@",model.name] : model.name;
            callBack(otherJmidName);
            return otherJmidName;
        }
    }
    for(BFUserInfoModel *model in manager.strangerArrM){
        if([model.jmid isEqualToString:otherJmid]){
            otherJmidName = showJmidList ? [NSString stringWithFormat:@"陌生人%@",model.name] : model.name;
            callBack(otherJmidName);
            return otherJmidName;
        }
    }
        
        if( otherJmidName == nil){
        [BFOriginNetWorkingTool getUserInfoByJmid:[BFUserLoginManager shardManager].jmId otherJmid:otherJmid completionHandler:^(BFUserInfoModel *model, NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               if(error){
                   NSLog(@"error ->%@",error);
               }else{
                   [manager.strangerArrM addObject:model];
                   callBack( model.name);
               }
           });
        }];
    }
    return @"";
    
}

+ (BFUserInfoModel *)getUserInfoWithOtherJmid:(NSString *)otherJmid{
    BFHXManager *manager = [BFHXManager shareManager];
    for(BFUserInfoModel *model in manager.fansArrM){
        if([model.jmid isEqualToString:otherJmid]){
            
            return model;
        }
    }
    for(BFUserInfoModel *model in manager.friendsArrM){
        if([model.jmid isEqualToString:otherJmid]){
            
            return model;
        }
    }
    for(BFUserInfoModel *model in manager.followArrM){
        if([model.jmid isEqualToString:otherJmid]){
            
            return model;
        }
    }
    for(BFUserInfoModel *model in manager.strangerArrM){
        if([model.jmid isEqualToString:otherJmid]){
            
            return model;
        }
    }
    //如果四个数组里面都没有对应的用户信息 则从网络加载 并且储存到陌生人数组里
    [BFOriginNetWorkingTool getUserInfoByJmid:[BFUserLoginManager shardManager].jmId otherJmid:otherJmid completionHandler:^(BFUserInfoModel *model, NSError *error) {
            [manager.strangerArrM addObject: model];
    }];
    TimeStar
    int i = 1;
    static int timeCount = 1;
    do{
        TimeEnd(i++)
        [NSThread sleepForTimeInterval:0.1];
                
    }while ([manager isContainedByStrangerArrMWithOtherJmid:otherJmid] == nil && timeCount++ < 5 );
    timeCount = 1;
    
    return [manager isContainedByStrangerArrMWithOtherJmid:otherJmid];
}

- (BFUserInfoModel *)isContainedByStrangerArrMWithOtherJmid:(NSString *)otherJmid{
    
    for(BFUserInfoModel *model in self.strangerArrM){
        if([model.jmid isEqualToString:otherJmid]){
            return model;
        }
    }
    return nil;
}

#pragma mark - init Hyphenate

- (void)hyphenateApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                      appkey:(NSString *)appkey
                apnsCertName:(NSString *)apnsCertName
                 otherConfig:(NSDictionary *)otherConfig
{
    [self _setupAppDelegateNotifications];
    [self _registerRemoteNotification];
    
    EMOptions *options = [EMOptions optionsWithAppkey:appkey];
    options.apnsCertName = apnsCertName;
    options.isAutoAcceptGroupInvitation = NO;
    if ([otherConfig objectForKey:kSDKConfigEnableConsoleLogger]) {
        options.enableConsoleLog = YES;
    }
    
    BOOL sandBox = [otherConfig objectForKey:@"easeSandBox"] && [[otherConfig objectForKey:@"easeSandBox"] boolValue];
    if (!sandBox) {
        [[EMClient sharedClient] initializeSDKWithOptions:options];
    }
}

#pragma mark - app delegate notifications

- (void)_setupAppDelegateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)appDidEnterBackgroundNotif:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}

#pragma mark - register apns

- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}



#pragma mark - send message

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)toUser
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt

{
    NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:willSendText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendCmdMessage:(NSString *)action
                           to:(NSString *)to
                  messageType:(EMChatType)messageType
                   messageExt:(NSDictionary *)messageExt
                    cmdParams:(NSArray *)params
{
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:action];
    if (params) {
        body.params = params;
    }
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt
{
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithLatitude:latitude longitude:longitude address:address];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:@"image.png"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    return [self sendImageMessageWithImageData:data to:to messageType:messageType messageExt:messageExt];
}

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:localPath displayName:@"audio"];
    body.duration = (int)duration;
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithLocalPath:[url path] displayName:@"video.mp4"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

- (void)logCurrentRelationship{
    NSMutableString *strM = [NSMutableString string];
    static int index = 1;
    [strM appendString:@"\n\n好友列表：\n"];
    for(BFUserInfoModel *model in self.friendsArrM){
        [strM appendString:[NSString stringWithFormat:@"%zd 、%@ \n",index++ ,model.name]];
    }
    index = 1;
    [strM appendString:@"\n\n关注列表：\n"];
    for(BFUserInfoModel *model in self.fansArrM){
        [strM appendString:[NSString stringWithFormat:@"%zd 、%@ \n",index++ ,model.name]];
    }
    index = 1;
    [strM appendString:@"\n\n粉丝列表：\n"];
    for(BFUserInfoModel *model in self.fansArrM){
        [strM appendString:[NSString stringWithFormat:@"%zd 、%@ \n",index++ ,model.name]];
    }
    index = 1;
    [strM appendString:@"\n\n黑名单列表：\n"];
    for(BFUserInfoModel *model in self.blackListArrM){
        [strM appendString:[NSString stringWithFormat:@"%zd 、%@ \n",index++ ,model.name]];
    }
    
    index = 1;
    NSLog(@"%@",strM);
}

@end


