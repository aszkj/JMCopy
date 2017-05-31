//
//  BFHXDelegateManager+call.m
//  BFTest
//
//  Created by JM on 2017/4/18.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXDelegateManager+call.h"
#import "EMCallViewController.h"

@implementation BFHXDelegateManager (call)





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
        self.currentSession = [[EMClient sharedClient].callManager makeVideoCall:aUsername error:nil];
    }
    else{
        self.currentSession = [[EMClient sharedClient].callManager makeVoiceCall:aUsername error:nil];
    }
    
    if(self.currentSession){
        [self _startCallTimer];
        
        self.currentController = [[CallViewController alloc] initWithSession:self.currentSession isCaller:YES status:NSLocalizedString(@"call.connecting", @"Connecting...")];
        self.currentController.userdata = user;
        [self.mainVC presentViewController:self.currentController animated:NO completion:nil];
    }
    else{
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.initFailed", @"Establish call failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        //        [alertView show];
    }
    
}

- (void)_startCallTimer
{
    self.callTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_cancelCall) userInfo:nil repeats:NO];
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
    
    if (self.currentSession) {
        [[EMClient sharedClient].callManager endCall:self.currentSession.sessionId reason:aReason];
    }
    
    self.currentSession = nil;
    [self.currentController close];
    self.currentController = nil;
}
- (void)_stopCallTimer
{
    if (self.callTimer == nil) {
        return;
    }
    
    [self.callTimer invalidate];
    self.callTimer = nil;
}

- (void)answerCall
{
    if (self.currentSession) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:self.currentSession.sessionId];
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


/*****************************************************************************************/
/*!
 *  \~chinese
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 *
 */



- (void)callDidReceive:(EMCallSession *)aSession{
    //用户A拨打用户B，用户B会收到这个回调

        if(self.currentSession && self.currentSession.status != EMCallSessionStatusDisconnected){
            [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonBusy];
        }
        
        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
            [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
        }
        
        self.currentSession = aSession;
        if(self.currentSession){
            [self _startCallTimer];
            
            self.currentController = [[CallViewController alloc] initWithSession:self.currentSession isCaller:NO status:NSLocalizedString(@"call.finished", "Establish call finished")];
            self.currentController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.mainVC presentViewController:self.currentController animated:YES completion:nil];
            
            [self.currentController inviteVideo];
        }
}

/*!
 *  \~chinese
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 *
 */
- (void)callDidConnect:(EMCallSession *)aSession{
    
    //通话通道建立完成，用户A和用户B都会收到这个回调
 
        if ([aSession.sessionId isEqualToString:self.currentSession.sessionId]) {
            //        self.currentController.statusLabel.text = NSLocalizedString(@"call.finished", "Establish call finished");
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [audioSession setActive:YES error:nil];
        }
}

/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 *
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    //用户B同意用户A拨打的通话后，用户A会收到这个回调

        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
            [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
        }
        
        if ([aSession.sessionId isEqualToString:self.currentSession.sessionId]) {
            [self _stopCallTimer];
            
            NSString *connectStr = aSession.connectType == EMCallConnectTypeRelay ? @"Relay" : @"Direct";
            //        self.currentController.statusLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"call.speak", @"Can speak..."), connectStr];
            self.currentController.timeLabel.hidden = NO;
            [self.currentController startTimer];
            [self.currentController startShowInfo];
            self.currentController.cancelButton.hidden = NO;
            self.currentController.rejectButton.hidden = YES;
            self.currentController.answerButton.hidden = YES;
            [self.currentController layview];
            
        }
    
}

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 *
 */
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError{
    // 1. 用户A或用户B结束通话后，对方会收到该回调
    //*  2. 通话出现错误，双方都会收到该回调

        if ([aSession.sessionId isEqualToString:self.currentSession.sessionId]) {
            [self _stopCallTimer];
            
            self.currentSession = nil;
                        

//                    [self.currentController close];
            [self.currentController closeCall:aSession reason:aReason error:aError];
            self.currentController = nil;
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
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                    [alertView show];
                }
            }
        }

}

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A暂停或者恢复数据流传输时，用户B会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aType     改变类型
 *
 */
- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType{
    
}

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aStatus   当前状态
 *
 */
- (void)callNetworkStatusDidChange:(EMCallSession *)aSession
                            status:(EMCallNetworkStatus)aStatus{
    // 用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调

        if ([aSession.sessionId isEqualToString:self.currentSession.sessionId]) {
            [self.currentController setNetwork:aStatus];
        }
}
//
//#pragma mark - NSNotification
//
//- (void)makeCall:(NSNotification*)notify
//{
//    if (notify.object) {
//        EMCallType type = (EMCallType)[[notify.object objectForKey:@"type"] integerValue];
//        [self makeCallWithUsername:[notify.object valueForKey:@"chatter"] type:type];
//    }
//}
//
//
//- (void)makeCallWithUsername:(NSString *)aUsername
//                        type:(EMCallType)aType
//{
//    if ([aUsername length] == 0) {
//        return;
//    }
//    
//    __weak typeof(self) weakSelf = self;
//    void (^completionBlock)(EMCallSession *, EMError *) = ^(EMCallSession *aCallSession, EMError *aError){
//        BFHXDelegateManager *strongSelf = weakSelf;
//        if (strongSelf) {
//            if (aError || aCallSession == nil) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"call.initFailed", @"Establish call failure") message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                [alertView show];
//                return;
//            }
//            NSString *reUserName = aCallSession.remoteUsername;
//            NSString *userName = aCallSession.username;
//            
//            @synchronized (self.callLock) {
//                strongSelf.currentSession = aCallSession;
//                strongSelf.currentController = [[EMCallViewController alloc] initWithCallSession:strongSelf.currentSession];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (strongSelf.currentController) {
//                        [strongSelf.mainVC presentViewController:self.currentController animated:NO completion:nil];
//                    }
//                });
//            }
//            
//            [self _startCallTimer];
//        }
//        else {
//            [[EMClient sharedClient].callManager endCall:aCallSession.sessionId reason:EMCallEndReasonNoResponse];
//        }
//    };
//    
//    [[EMClient sharedClient].callManager startVideoCall:aUsername completion:^(EMCallSession *aCallSession, EMError *aError) {
//        NSLog(@"testStr sessionID ->%@",aCallSession.sessionId);
//        completionBlock(aCallSession, aError);
//    }];
//    
//    
//}






#pragma mark - private timer
/*
- (void)_timeoutBeforeCallAnswered
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.autoHangup", @"No response and Hang up") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)_startCallTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_timeoutBeforeCallAnswered) userInfo:nil repeats:NO];
}

- (void)_stopCallTimer
{
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}
- (void)_clearCurrentCallViewAndData
{
    @synchronized (self.callLock) {
        self.currentSession = nil;
        
        self.currentController.isDismissing = YES;
        [self.currentController clearData];
        [self.currentController dismissViewControllerAnimated:NO completion:nil];
        self.currentController = nil;
    }
}

- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self _stopCallTimer];
    
    if (self.currentSession) {
        [[EMClient sharedClient].callManager endCall:self.currentSession.sessionId reason:aReason];
    }
    [self _clearCurrentCallViewAndData];
}

- (void)answerCall:(NSString *)aCallId
{
    if (!self.currentSession || ![self.currentSession.sessionId isEqualToString:aCallId]) {
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:weakSelf.currentSession.sessionId];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == EMErrorNetworkUnavailable) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network.disconnection", @"Network disconnection") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else{
                    [weakSelf hangupCallWithReason:EMCallEndReasonFailed];
                }
            });
        }
    });
}
 */





@end
