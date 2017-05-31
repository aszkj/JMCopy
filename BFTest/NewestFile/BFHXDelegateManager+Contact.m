//
//  BFHXDelegateManager+contact.m
//  BFTest
//
//  Created by JM on 2017/4/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXDelegateManager+Contact.h"

@implementation BFHXDelegateManager (Contact)

/*!
 *  \~chinese
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    
}

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    
}

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 */
- (void)friendshipDidRemoveByUser:(NSString *)aUsername{
    
     NSLog(@"环信收到了来自%@的好友关系设置的回调！ - message: %@ ",aUsername,@"删除用户");
    //此时是对方要把我变为他的陌生人  他是我的朋友  我要把他从朋友列表删除
    [self makeFriendToBeFansWithOtherJmid:aUsername];
}

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 *
 */
- (void)friendshipDidAddByUser:(NSString *)aUsername{
    
}

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    
    
    if([aMessage containsString:@"Fans->Friend"]){
        //此时是对方要把我变为他的好友  我已经关注了他 我要从关注列表删除他 加入朋友列表
        [self makeFansToBeFriendWithOtherJmid:aUsername message:aMessage];
    }else if([aMessage containsString:@"None->Follow"]){
        //此时是对方要把我变为他关注的人  我和他是陌生人 我要把他加入粉丝列表
        [self makeNoneToBeFollowWithOtherJmid:aUsername message:aMessage];
    }else if([aMessage containsString:@"Fans->None"]){
        //此时是对方要把我变为他的陌生人  我已经关注了他 我要把他从关注列表移除
        [self makeFansToBeNoneWithOtherJmid:aUsername message:aMessage];
    }else if([aMessage containsString:@"Follow->None"]){
        //此时是对方要把我变为他的陌生人  他是我的粉丝   我要把他从粉丝列表移除
        [self makeFollowToBeNoneWithOtherJmid:aUsername message:aMessage];
    }else{
 NSLog(@"环信收到了来自%@的好友关系设置的回调！ - message: %@ ",aUsername,aMessage);
    }
    
}


#pragma  mark - 环信 关于收到其他用户设置好友关系的回调处理

- (void)makeFansToBeFriendWithOtherJmid:(NSString *)otherJmid message:(NSString *)message{
    
    NSLog(@"环信收到了来自%@的关注！（收到好友申请） - message: %@ ",otherJmid,message);
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:otherJmid completion:^(NSString *aUsername, EMError *aError) {
        if(aError){
            NSLog(@"环信接受%@关注失败！（同意好友申请失败）- message: %@",otherJmid,message);
        }else{
            NSLog(@"环信接受%@关注成功！（同意好友申请成功）- message: %@",otherJmid,message);
            
//            [BFHXManager addUserInfoModelWithJmid:aUsername toList:ManagerListTypeFriend];
        }
    }];
}

- (void)makeNoneToBeFollowWithOtherJmid:(NSString *)otherJmid message:(NSString *)message{
    
    NSLog(@"环信收到了来自%@的关注！（收到关注） - message: %@ ",otherJmid,message);
    
//    [BFHXManager addUserInfoModelWithJmid:otherJmid toList:ManagerListTypeFans];
}

- (void)makeFansToBeNoneWithOtherJmid:(NSString *)otherJmid message:(NSString *)message{
    
    NSLog(@"环信收到了来自%@的删除粉丝！（被删除粉丝） - message: %@ ",otherJmid,message);
    
//    [BFHXManager removeUserInfoModelFromAllListWithJmid:otherJmid];
}

- (void)makeFollowToBeNoneWithOtherJmid:(NSString *)otherJmid message:(NSString *)message{
    
    NSLog(@"环信收到了来自%@的取消关注！（被移除关注） - message: %@ ",otherJmid,message);
//    [BFHXManager removeUserInfoModelFromAllListWithJmid:otherJmid];
}

- (void)makeFriendToBeFansWithOtherJmid:(NSString *)otherJmid {
    
    NSLog(@"环信收到了来自%@的取消关注！(被删除好友)",otherJmid);
    
//    [BFHXManager addUserInfoModelWithJmid:otherJmid toList:ManagerListTypeFollow];
}

- (void)makeFriendToBeFollowWithOtherJmid:(NSString *)otherJmid {
    
    NSLog(@"环信收到了来自%@的移除粉丝！(被删除好友)",otherJmid);
    
    //    [BFHXManager addUserInfoModelWithJmid:otherJmid toList:ManagerListTypeFollow];
}



@end
