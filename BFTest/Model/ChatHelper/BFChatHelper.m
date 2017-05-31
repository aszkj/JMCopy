//
//  BFChatHelper.m
//  BFTest
//
//  Created by 伯符 on 16/8/23.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFChatHelper.h"

#import "ApplyViewController.h"
@interface BFChatHelper ()
{
    NSTimer *_callTimer;
}
@end

static BFChatHelper *helper = nil;

@implementation BFChatHelper
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[BFChatHelper alloc] init];
    });
    return helper;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void)initHelper
{
//#ifdef REDPACKET_AVALABLE
//    [[RedPacketUserConfig sharedConfig] beginObserveMessage];
//#endif
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
//#if DEMO_CALL == 1
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
//#endif
}

// 接收信息
//- (void)didReceiveMessages:(NSArray *)aMessages
//{
//    
//    for(EMMessage *message in aMessages){
//        NSLog(@"%@-----%@------%@",message.ext[@"jmid"],message.ext[@"nikename"],message.ext[@"userIcon"]);
//        // 会话缓存
//        NSDictionary *usermsg = @{@"jmid":message.ext[@"jmid"],@"nikename":message.ext[@"nikename"],@"userIcon":message.ext[@"userIcon"]};
//
//        NSMutableArray *cacheschat = [BFChatHelper getDataArrayFromDB:@"ChatUserCaches"];
//        if (cacheschat) {
//            for (int i = 0; i < cacheschat.count; i ++) {
//                NSDictionary *userdic = cacheschat[i];
//                if ([userdic[@"jmid"] isEqualToString:usermsg[@"jmid"]]) {
//                    if (![userdic[@"nikename"] isEqualToString:usermsg[@"nikename"]] || ![userdic[@"userIcon"] isEqualToString:usermsg[@"userIcon"]]) {
//                        [cacheschat removeObject:userdic];
//                    }
//                }
//            }
//           
//            [cacheschat addObject:usermsg];
//            [BFChatHelper saveToLocalDB:cacheschat saveIdenti:@"ChatUserCaches"];
//            
//        }else{
//            NSMutableArray *ar = [NSMutableArray array];
//            [ar addObject:usermsg];
//            [BFChatHelper saveToLocalDB:ar saveIdenti:@"ChatUserCaches"];
//        }
//        
//        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
//
//        if (needShowNotification) {
//            
//#if !TARGET_IPHONE_SIMULATOR
//            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//            switch (state) {
//                case UIApplicationStateActive:
//                    [self.mainVC playSoundAndVibration];
//                    break;
//                case UIApplicationStateInactive:
//                    [self.mainVC playSoundAndVibration];
//                    break;
//                case UIApplicationStateBackground:
//                    [self.mainVC showNotificationWithMessage:message];
//                    break;
//                default:
//                    break;
//            }
//#endif
//        }
//        
//        [self _handleReceivedAtMessage:message];
//        if (self.conversationListVC) {
//            [_conversationListVC refresh];
//        }
//        [self.mainVC setupUnreadMessageCount];
//    }
//}

#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

- (void)_handleReceivedAtMessage:(EMMessage*)aMessage
{
    if (aMessage.chatType != EMChatTypeGroupChat || aMessage.direction != EMMessageDirectionReceive) {
        return;
    }
    
    NSString *loginUser = [EMClient sharedClient].currentUsername;
    NSDictionary *ext = aMessage.ext;
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:aMessage.conversationId type:EMConversationTypeGroupChat createIfNotExist:NO];
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


- (void)makeCall:(NSNotification*)notify
{
    if (notify.object) {
        NSLog(@"%@",notify.object);
        NSDictionary *user = (NSDictionary *)notify.object;
        
        [self makeCallWithUsername:[notify.object valueForKey:@"chatter"] isVideo:[[notify.object objectForKey:@"type"] boolValue] dicdata:user];
    }
}

- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo dicdata:(NSDictionary *)user
{
    if ([aUsername length] == 0) {
        return;
    }
    
    if (aIsVideo) {
        _callSession = [[EMClient sharedClient].callManager makeVideoCall:aUsername error:nil];
    }
    else{
        _callSession = [[EMClient sharedClient].callManager makeVoiceCall:aUsername error:nil];
    }
    
    if(_callSession){
        [self _startCallTimer];
        
        _callController = [[CallViewController alloc] initWithSession:_callSession isCaller:YES status:NSLocalizedString(@"call.connecting", @"Connecting...")];
        _callController.userdata = user;
        [_mainVC presentViewController:_callController animated:NO completion:nil];
    }
    else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.initFailed", @"Establish call failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        [alertView show];
    }
    
}

- (void)_startCallTimer
{
    _callTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_cancelCall) userInfo:nil repeats:NO];
}

- (void)_cancelCall
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.autoHangup", @"No response and Hang up") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}
- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self _stopCallTimer];
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.sessionId reason:aReason];
    }
    
    _callSession = nil;
    [_callController close];
    _callController = nil;
}
- (void)_stopCallTimer
{
    if (_callTimer == nil) {
        return;
    }
    
    [_callTimer invalidate];
    _callTimer = nil;
}

- (void)answerCall
{
    if (_callSession) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:_callSession.sessionId];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error.code == EMErrorNetworkUnavailable) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network.disconnection", @"Network disconnection") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    else{
                        [self hangupCallWithReason:EMCallEndReasonFailed];
                    }
                });
            }
        });
    }
}

- (void)didReceiveCallIncoming:(EMCallSession *)aSession
{
    if(_callSession && _callSession.status != EMCallSessionStatusDisconnected){
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonBusy];
    }
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
    }
    
    _callSession = aSession;
    if(_callSession){
        [self _startCallTimer];
        
        _callController = [[CallViewController alloc] initWithSession:_callSession isCaller:NO status:NSLocalizedString(@"call.finished", "Establish call finished")];
        _callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [_mainVC presentViewController:_callController animated:YES completion:nil];
        
        [_callController inviteVideo];
    }
}

- (void)didReceiveCallConnected:(EMCallSession *)aSession
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
//        _callController.statusLabel.text = NSLocalizedString(@"call.finished", "Establish call finished");
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
}

- (void)didReceiveCallAccepted:(EMCallSession *)aSession
{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
    }
    
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [self _stopCallTimer];
        
        NSString *connectStr = aSession.connectType == EMCallConnectTypeRelay ? @"Relay" : @"Direct";
//        _callController.statusLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"call.speak", @"Can speak..."), connectStr];
        _callController.timeLabel.hidden = NO;
        [_callController startTimer];
        [_callController startShowInfo];
        _callController.cancelButton.hidden = NO;
        _callController.rejectButton.hidden = YES;
        _callController.answerButton.hidden = YES;
        [_callController layview];

    }
}

- (void)didReceiveCallTerminated:(EMCallSession *)aSession
                          reason:(EMCallEndReason)aReason
                           error:(EMError *)aError
{
    
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [self _stopCallTimer];
        
        _callSession = nil;
        
//        [_callController close];
//        _callController = nil;
        
        if (aReason != EMCallEndReasonHangup) {
            NSString *reasonStr = @"";
            switch (aReason) {
                case EMCallEndReasonNoResponse:
                {
                    reasonStr = NSLocalizedString(@"call.noResponse", @"NO response");
                }
                    break;
                case EMCallEndReasonDecline:
                {
                    reasonStr = NSLocalizedString(@"call.rejected", @"Reject the call");
                }
                    break;
                case EMCallEndReasonBusy:
                {
                    reasonStr = NSLocalizedString(@"call.in", @"In the call...");
                }
                    break;
                case EMCallEndReasonFailed:
                {
                    reasonStr = NSLocalizedString(@"call.connectFailed", @"Connect failed");
                }
                    break;
                default:
                    break;
            }
            
            if (aError) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

- (void)didReceiveCallNetworkChanged:(EMCallSession *)aSession status:(EMCallNetworkStatus)aStatus
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [_callController setNetwork:aStatus];
    }
}


#pragma mark - EMContactManagerDelegate
//- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
//{
//    NSString *msgstr = [NSString stringWithFormat:@"%@同意了加好友申请", aUsername];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
//}
//
//- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
//{
//    NSString *msgstr = [NSString stringWithFormat:@"%@拒绝了加好友申请", aUsername];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
//}
//
//- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
//{
//    [self.conversationListVC reloadDataSource];
//
//}

//- (void)didReceiveAddedFromUsername:(NSString *)aUsername
//{
//    NSString *url;
//    if (UserwordMsg && JMTOKEN) {
//        url = [NSString stringWithFormat:@"%@/getUlikest?tkname=%@&tok=%@&likest=%@",ALI_BASEURL,UserwordMsg,JMTOKEN,aUsername];
//    }else{
//        
//        return ;
//    }
//    [BFNetRequest getWithURLString:url parameters:nil success:^(id responseObject) {
//        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSMutableArray *dataArray = accessDict[@"data"];
//        if (dataArray.count != 0) {
//            NSString *name = [[dataArray firstObject]objectForKey:@"name"];
////            NSString *str = @"http://101.201.101.125:8000/insertfriend";
//            NSString *str = [NSString stringWithFormat:@"%@/insertfriend",ALI_BASEURL];
//            NSDictionary *para = @{@"tkname":UserwordMsg,@"useridtwo":name,@"tok":JMTOKEN,@"version":@"1"};
//            [BFNetRequest postWithURLString:str parameters:para success:^(id responseObject) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@",dic);
//                if ([[dic objectForKey:@"s"]isEqualToString:@"t"]) {
//                    [self.conversationListVC reloadDataSource];
//                }
//            } failure:^(NSError *error) {
//                
//            }];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}

//- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
//                                       message:(NSString *)aMessage
//{
//    if (!aUsername) {
//        return;
//    }
//    
//    if (!aMessage) {
//        aMessage = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aUsername, @"username":aUsername, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
//    [[ApplyViewController shareController] addNewApply:dic];
//    if (self.mainVC) {
//        [self.mainVC setupUntreatedApplyCount];
//#if !TARGET_IPHONE_SIMULATOR
//        [self.mainVC playSoundAndVibration];
//        
//        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
//        if (!isAppActivity) {
//            //发送本地推送
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date]; //触发通知的时间
//            notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
//            notification.alertAction = NSLocalizedString(@"open", @"Open");
//            notification.timeZone = [NSTimeZone defaultTimeZone];
//        }
//#endif
//    }
//    [self.conversationListVC reloadApplyView];
//}

#pragma mark - EMChatroomManagerDelegate

- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    
}

- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    
}

+ (void)saveToLocalDB:(id)object saveIdenti:(NSString *)ident{
    NSString *dicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *dataPath = [dicPath stringByAppendingPathComponent:ident];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dataPath]) {
        BOOL result = [fileManager createDirectoryAtPath:dataPath
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:nil];
        NSLog(@"create dataPath:%d", result);
    }else{
        [fileManager removeItemAtPath:dataPath error:nil];
        
    }
    //    NSDictionary *dic = (NSDictionary *)object;
    if([object writeToFile:dataPath atomically:YES]){
        NSLog(@"存入成功");
    }else{
        NSLog(@"存入失败");
        [self saveToLocalDB:(id)object saveIdenti:ident];
    }
    
}

+ (id)getDataFromDB:(NSString *)ident{
    NSString *dicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *dataPath = [dicPath stringByAppendingPathComponent:ident];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dataPath]) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:dataPath];
        return dataDic;
    }
    return nil;
    
}

+ (void)remove:(NSString *)ident{
    NSString *dicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *dataPath = [dicPath stringByAppendingPathComponent:ident];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dataPath error:nil];
}

+ (id)getDataArrayFromDB:(NSString *)ident{
    NSString *dicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *dataPath = [dicPath stringByAppendingPathComponent:ident];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dataPath]) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:dataPath];
        return dataArray;
    }
    return nil;
}

+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory {
    NSString *path = [directory stringByAppendingPathComponent:folderName];
    NSURL *folderURL = [NSURL URLWithString:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (!error) {
            return folderURL;
        }else {
            NSLog(@"创建文件失败 %@", error.localizedFailureReason);
            return nil;
        }
        
    }
    return folderURL;
}

+ (NSString*)dataPath {
    static NSString *_dataPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    });
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:_dataPath]){
        [fm createDirectoryAtPath:_dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    return _dataPath;
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
//#if DEMO_CALL == 1
    [[EMClient sharedClient].callManager removeDelegate:self];
//#endif
}
@end
