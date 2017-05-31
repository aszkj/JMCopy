//
//  CallViewController+extend.m
//  BFTest
//
//  Created by JM on 2017/5/24.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "CallViewController+extend.h"

static NSString *EMCallEndReasonNoResponseErrorStr = @"对方没有响应";
static NSString *EMCallEndReasonDeclineErrorStr    = @"对方拒接";
static NSString *EMCallEndReasonBusyErrorStr       = @"对方占线中..";
static NSString *EMCallEndReasonOfflineErrorStr    = @"对方不在线";
static NSString *EMCallEndReasonFaliedErrorStr     = @"通话连接错误";

@implementation CallViewController (extend)

- (void)closeCall:(EMCallSession *)aSession
           reason:(EMCallEndReason)aReason
            error:(EMError *)aError
{
    
        NSString *reasonStr = nil;
        if (aReason != EMCallEndReasonHangup) {
            switch (aReason) {
//                case EMCallEndReasonNoResponse:
//                {
//                    reasonStr = EMCallEndReasonNoResponseErrorStr;
//                }
//                    break;
//                case EMCallEndReasonDecline:
//                {
//                    reasonStr = EMCallEndReasonDeclineErrorStr;
//                }
//                    break;
//                case EMCallEndReasonBusy:
//                {
//                    reasonStr = EMCallEndReasonBusyErrorStr;
//                }
                    break;
                case EMCallEndReasonFailed:
                {
                    if (aError.code == EMErrorCallRemoteOffline) {
                        reasonStr = EMCallEndReasonOfflineErrorStr;
                    }else {
//                        reasonStr = EMCallEndReasonFaliedErrorStr;
                    }
                }
                    break;
                default:
                    break;
            }

        }
    if (reasonStr) {
        [self performSelector:@selector(showErrorStr:) withObject:reasonStr afterDelay:3.0f];
    }else {
        [self close];
    }
}

- (void)showErrorStr:(NSString *)errorStr {
    [self showAlertViewTitle:nil message:errorStr sureAction:^{
        [self close];
    }];
}


@end
