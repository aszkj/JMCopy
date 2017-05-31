//
//  BFHXDelegateManager+Chat.m
//  BFTest
//
//  Created by JM on 2017/4/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXDelegateManager+Chat.h"

@implementation BFHXDelegateManager (Chat)


//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";



/*!
 *  \~chinese
 *  会话列表发生变化
 *
 *  @param aConversationList  会话列表<EMConversation>
 *
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList{
    
    NOTIFY_POST(kSetupUnreadMessageCount);
    
    if (self.conversationListVC) {
        [self.conversationListVC refreshDataSource];
    }
}


#pragma mark - Message

/*!
 *  \~chinese
 *  收到消息
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 */
- (void)messagesDidReceive:(NSArray *)aMessages{
    BOOL isRefreshCons = YES;
    for(EMMessage *message in aMessages){
        //根据消息的类型判断是否需要显示通知
        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
            switch (state) {
                case UIApplicationStateActive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
#endif
        }
        self.chatVC = nil;
        //从导航控制器的栈内查找是否有聊天控制器
        if (self.chatVC == nil) {
            self.chatVC = [self _getCurrentChatView];
        }
        BOOL isChatting = NO;
        if (self.chatVC) {
            isChatting = [message.conversationId isEqualToString:self.chatVC.conversation.conversationId];
        }
        //如果 当前导航控制器的栈内没有聊天控制器 或者 有聊天控制器但是收到的消息不属于这个聊天控制器 或者 应用处于后台运行状态 则进入
        if (self.chatVC == nil || !isChatting || state == UIApplicationStateBackground) {
            
            //处理收到的message
            [self _handleReceivedAtMessage:message];
            //如果会话列表存在 则刷新列表
            if (self.conversationListVC) {
                
                [self.conversationListVC refresh];
            }
            //应用通知中心 发送未读消息数
            NOTIFY_POST(kSetupUnreadMessageCount);
            return;
        }
        //导航控制器的栈中没有对应本消息的聊天控制器
        if (isChatting) {
            //将是否刷新会话列表 设置为不刷新
            isRefreshCons = NO;
        }
    }
    
    if (isRefreshCons) {
        //刷新会话列表
        if (self.conversationListVC) {
            [self.conversationListVC refresh];
        }
        NOTIFY_POST(kSetupUnreadMessageCount);
    }
    
}


/*!
 *  \~chinese
 *  收到Cmd消息
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
    
    EMMessage *cmdMessage = aCmdMessages.lastObject;
    EMCmdMessageBody *body = (EMCmdMessageBody *)cmdMessage.body;//    (EMCommandMessageBody *)aCmdMessages.messageBodies.lastObject;
    NSLog(@"收到的ext是 -- %@",cmdMessage.ext);
    if ([body.action isEqualToString:@"news"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadDTCount" object:nil];
    }

    
    
}

/*!
 *  \~chinese
 *  收到已读回执
 *
 *  @param aMessages  已读消息列表<EMMessage>
 *
 */
- (void)messagesDidRead:(NSArray *)aMessages{
    
}

/*!
 *  \~chinese
 *  收到消息送达回执
 *
 *  @param aMessages  送达消息列表<EMMessage>
 *
 */
- (void)messagesDidDeliver:(NSArray *)aMessages{
    
}

/*!
 *  \~chinese
 *  消息状态发生变化
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 *
 */
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError{
    
}

/*!
 *  \~chinese
 *  消息附件状态发生改变
 *
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 *
 */
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError{
    
}

#pragma mark - private

- (void)_handleReceivedAtMessage:(EMMessage*)aMessage
{
    NSDictionary *testMessageLog = @{
                                     @"conversationId":aMessage.conversationId,
                                     @"from":aMessage.from,
                                     @"to":aMessage.to,
                                     @"ext":aMessage.ext,
                                     @"direction":@(aMessage.direction)
                                     };
    NSLog(@"receivedTestMessage -> %@",testMessageLog);
    
    if (aMessage.chatType != EMChatTypeGroupChat || aMessage.direction != EMMessageDirectionReceive) {
        return;
    }
    
    NSString *loginUser = [EMClient sharedClient].currentUsername;
    NSDictionary *ext = aMessage.ext;
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:aMessage.conversationId type:EMConversationTypeGroupChat createIfNotExist:YES];
    if (loginUser && conversation && ext && [ext objectForKey:kGroupMessageAtList]) {
        id target = [ext objectForKey:kGroupMessageAtList];
        if ([target isKindOfClass:[NSString class]] && [(NSString*)target compare:kGroupMessageAtAll options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSNumber *atAll = conversation.ext[kHaveUnreadAtMessage];
            if ([atAll intValue] != kAtAllMessage) {
                NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
                [conversationExt removeObjectForKey:kHaveUnreadAtMessage];
                [conversationExt setObject:@kAtAllMessage forKey:kHaveUnreadAtMessage];
                conversation.ext = conversationExt;
            }
        }
        else if ([target isKindOfClass:[NSArray class]]) {
            if ([target containsObject:loginUser]) {
                if (conversation.ext[kHaveUnreadAtMessage] == nil) {
                    NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
                    [conversationExt setObject:@kAtYouMessage forKey:kHaveUnreadAtMessage];
                    conversation.ext = conversationExt;
                }
            }
        }
    }
}

- (BFChatViewController*)_getCurrentChatView
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.mainVC.navigationController.viewControllers];
    BFChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[BFChatViewController class]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    return chatViewContrller;
}

- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}
- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMError *error = nil;
    EMPushOptions *options = [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    if(error){
        NSLog(@"环信全局配置 error.code ->%zd",error.code);
    }
    NSString *alertBody = nil;
    //这里根据环信的推送设置 来决定推送消息是否显示详情
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        __block NSString *OtherName = nil;
        NSString *title = nil;
        do {
            //设置本地推送中显示的消息来源的用户名
            title = [BFHXManager getNameFromCurrentManagerListWithOtherJmid:message.from callBack:^(NSString *name) {
                OtherName = name;
            }];
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (!(OtherName || title));
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


@end
