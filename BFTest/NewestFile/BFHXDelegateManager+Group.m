//
//  BFHXDelegateManager+Group.m
//  BFTest
//
//  Created by JM on 2017/4/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXDelegateManager+Group.h"

@implementation BFHXDelegateManager (Group)

/*!
 *  \~chinese
 *  用户A邀请用户B入群,用户B接收到该回调
 *
 *  @param aGroupId    群组ID
 *  @param aInviter    邀请者
 *  @param aMessage    邀请信息
 *
 */
- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage{
    
}

/*!
 *  \~chinese
 *  用户B同意用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组实例
 *  @param aInvitee  被邀请者
 *
 */
- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee{
    
}

/*!
 *  \~chinese
 *  用户B拒绝用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组
 *  @param aInvitee  被邀请者
 *  @param aReason   拒绝理由
 *
 */
- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason{
    
}

/*!
 *  \~chinese
 *  SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
 *
 *  @param aGroup    群组实例
 *  @param aInviter  邀请者
 *  @param aMessage  邀请消息
 *
 */
- (void)didJoinGroup:(EMGroup *)aGroup
             inviter:(NSString *)aInviter
             message:(NSString *)aMessage{
    
}

/*!
 *  \~chinese
 *  离开群组回调
 *
 *  @param aGroup    群组实例
 *  @param aReason   离开原因
 *
 */
- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason{
    
}

/*!
 *  \~chinese
 *  群组的群主收到用户的入群申请，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     群组实例
 *  @param aApplicant 申请者
 *  @param aReason    申请者的附属信息
 *
 */
- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup
                              user:(NSString *)aUsername
                            reason:(NSString *)aReason{
    
}

/*!
 *  \~chinese
 *  群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    群组ID
 *  @param aReason     拒绝理由
 *
 */
- (void)joinGroupRequestDidDecline:(NSString *)aGroupId
                            reason:(NSString *)aReason{
    
}

/*!
 *  \~chinese
 *  群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   通过申请的群组
 *
 */
- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup{
    
}

/*!
 *  \~chinese
 *  群组列表发生变化
 *
 *  @param aGroupList  群组列表<EMGroup>
 *
 */
- (void)groupListDidUpdate:(NSArray *)aGroupList{
    
}



@end
