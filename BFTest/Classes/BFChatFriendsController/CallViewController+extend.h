//
//  CallViewController+extend.h
//  BFTest
//
//  Created by JM on 2017/5/24.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "CallViewController.h"
#import "EMCallSession.h"
#import "EMError.h"

@interface CallViewController (extend)

- (void)closeCall:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
            error:(EMError *)aError;

@end
