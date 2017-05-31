//
//  BFHXDelegateManager+call.h
//  BFTest
//
//  Created by JM on 2017/4/18.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXDelegateManager.h"

@interface BFHXDelegateManager (call) <EMCallManagerDelegate>

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;

//- (void)makeCall:(NSNotification*)notify;
//
//- (void)makeCallWithUsername:(NSString *)aUsername
//                        type:(EMCallType)aType;
//
//- (void)answerCall:(NSString *)aCallId;
//
//- (void)hangupCallWithReason:(EMCallEndReason)aReason;


@end
