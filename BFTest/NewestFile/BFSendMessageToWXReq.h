//
//  BFSendMessageToWXReq.h
//  BFTest
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

static NSString *kLinkURL = JM_SETSHAREWX;
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
static NSString *kLinkTitle = @"上近脉生活，精彩生活圈从此开启！";
static NSString *kLinkDescription = @"";

@interface BFSendMessageToWXReq : NSObject

+ (void)shareAction ;

@end
