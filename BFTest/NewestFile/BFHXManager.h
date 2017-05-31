//
//  BFHXManager.h
//  BFTest
//
//  Created by JM on 2017/4/15.
//  Copyright © 2017年 bofuco. All rights reserved.
//

/*----  本类的功能是 -------
 
        1.初始化环信                 -> a.添加证书 b.设置环信的appkey c.以及其他的设置otherConfig
        2.设置环信所有的代理对象       ->
        3.快速构造消息               ->
        4.推送相关的设置             ->
        5.维护好友关系        服务器和环信双方的好友系统
 
 --------------------------*/


#import "BFHXDelegateManager.h"
#import <Foundation/Foundation.h>
#import "BFUserInfoModel.h"

//typedef NS_ENUM(NSInteger,ManagerListType){
//    ManagerListTypeFriend = 1,
//    ManagerListTypeFollow,
//    ManagerListTypeFans
//};
typedef NS_ENUM(NSInteger,AsMyShipType) {
    AsMyShipTypeStranger = 0,
    AsMyShipTypeFriend,
    AsMyShipTypeFollow,
    AsMyShipTypeFans,
    AsMyShipTypeError
};


@interface BFHXManager : NSObject

@property (nonatomic,strong)NSMutableArray *hx_friendsArrM;

@property (nonatomic,strong)NSMutableArray <BFUserInfoModel *>*friendsArrM;
@property (nonatomic,strong)NSMutableArray <BFUserInfoModel *>*followArrM;
@property (nonatomic,strong)NSMutableArray <BFUserInfoModel *>*fansArrM;
@property (nonatomic,strong)NSMutableArray <BFUserInfoModel *>*blackListArrM;
@property (nonatomic,strong)NSMutableArray <BFUserInfoModel *>*strangerArrM;

@property (nonatomic,strong)BFHXDelegateManager *delegateManager;



#pragma mark - settings

+ (instancetype)shareManager;

/**
 初始化环信的方法
 */
+ (instancetype)setupEMClientApplication:(UIApplication *)application
                    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                                           appkey:(NSString *)appkey
                                     apnsCertName:(NSString *)apnsCertName
                                      otherConfig:(NSDictionary *)otherConfig;


#pragma mark - 管理用户关系

/**
 从应用服务器加载所有用户关系
 */
+ (void)loadUserRelationshipsArrMWithJmid:(NSString *)jmid;

/**
 添加关注到其他用户
 */
+ (void)addFollowToOtherJmid:(NSString *)otherJmid asMyship:(AsMyShipType)shipType callBack:(void(^)(NSString *code))callBack;

/**
 移除粉丝 （解除其他用户对我的关注状态）
 */
+ (void)deleteFansFromOtherJmid:(NSString *)otherJmid asMyship:(AsMyShipType)shipType callBack:(void(^)(NSString *code))callBack;

/**
 取消关注到其他用户
 */
+ (void)deleteFollowToOtherJmid:(NSString *)otherJmid asMyship:(AsMyShipType)shipType callBack:(void(^)(NSString *code))callBack;
/**
 添加用户到黑名单
 */
+ (void)addBlackListWithOtherJmid:(NSString *)otherJmid callBack:(void(^)(NSString *code))callBack;

/**
 把用户从黑名单移除
 */
+ (void)deleteBlackListWithOtherJmid:(NSString *)otherJmid callBack:(void(^)(NSString *code))callBack;

/**
 登录成功后加载用户的朋友列表
 */
+ (void)loadFriendArrMWithJmid:(NSString *)jmid;

/**
 环信BFHXmanager 所有数组中移除对应otherJmid的用户信息
 */
//+ (void)removeUserInfoModelFromAllListWithJmid:(NSString *)otherJmid;

/**
 环信BFHXmanager 添加对应otherJmid的用户信息 到指定的list中
 */
//+ (void)addUserInfoModelWithJmid:(NSString *)otherJmid toList:(ManagerListType)listType;

/**
 判断对应的list是否包含此jmid
 */
//- (BOOL)containJmid:(NSString *)jmid inList:(NSArray *)list;

#pragma mark - 从当前用户列表中通过jmid获得其他用户的资料

+ (NSString *)getNameFromCurrentManagerListWithOtherJmid:(NSString *)otherJmid  callBack:(void(^)(NSString *name))callBack;

+ (BFUserInfoModel *)getUserInfoWithOtherJmid:(NSString *)otherJmid;

#pragma mark - send message

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendCmdMessage:(NSString *)action
                           to:(NSString *)to
                  messageType:(EMChatType)messageType
                   messageExt:(NSDictionary *)messageExt
                    cmdParams:(NSArray *)params;

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt;



@end
