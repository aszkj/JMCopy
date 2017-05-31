//
//  BFHXDelegateManager+Chatroom.m
//  BFTest
//
//  Created by JM on 2017/4/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXDelegateManager+Chatroom.h"

@implementation BFHXDelegateManager (Chatroom)

/*!
 *  \~chinese
 *  有用户加入聊天室
 *
 *  @param aChatroom    加入的聊天室
 *  @param aUsername    加入者
 *
 */
- (void)userDidJoinChatroom:(EMChatroom *)aChatroom
                       user:(NSString *)aUsername{
    
}

/*!
 *  \~chinese
 *  有用户离开聊天室
 *
 *  @param aChatroom    离开的聊天室
 *  @param aUsername    离开者
 *
 */
- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom
                        user:(NSString *)aUsername{
    
}

/*!
 *  \~chinese
 *  被踢出聊天室
 *
 *  @param aChatroom    被踢出的聊天室
 *  @param aReason      被踢出聊天室的原因
 *
 */
- (void)didDismissFromChatroom:(EMChatroom *)aChatroom
                        reason:(EMChatroomBeKickedReason)aReason{
    
}


@end
