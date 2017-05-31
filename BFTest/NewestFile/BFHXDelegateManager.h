//
//  BFHXDelegateManager.h
//  BFTest
//
//  Created by JM on 2017/4/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//

// 这个类作为环信所有模块的代理 需要使用时导入对应功能的分类即可


#import "EaseUI.h"
#import "EMSDKFull.h"

#import "ChatUIDefine.h"
#import "ConversationListController.h"
#import "BFChatViewController.h"

#import <UserNotifications/UserNotifications.h>
#import "CallViewController.h"
#import "CallViewController+extend.h"
#import <Foundation/Foundation.h>

@class BFHXManager;

@interface BFHXDelegateManager : NSObject

@property (nonatomic, weak) BFChatViewController *chatVC;

@property (nonatomic, weak) ConversationListController *conversationListVC;

@property (nonatomic, weak) UIViewController *mainVC;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property (nonatomic) BOOL isShowingimagePicker;



@property (strong, nonatomic) NSObject *callLock;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) EMCallSession *currentSession;

@property (strong, nonatomic) CallViewController *currentController;

@property (strong, nonatomic) NSTimer *callTimer;

+ (instancetype)shareDelegateManager;



@end





































/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the magical animal protecting
 *　　　　　　　　　┃　　　┃ +
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */
