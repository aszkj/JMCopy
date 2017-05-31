//
//  BFChatHelper.h
//  BFTest
//
//  Created by 伯符 on 16/8/23.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMClient+Call.h"
#import "BFUsersListController.h"
#import "CallViewController.h"
#import "BFTabbarController.h"
@interface BFChatHelper : NSObject<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>

@property (nonatomic, weak) BFUsersListController *conversationListVC;

@property (strong, nonatomic) EMCallSession *callSession;

@property (strong, nonatomic) CallViewController *callController;
@property (nonatomic, weak) BFTabbarController *mainVC;

+ (instancetype)shareHelper;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;

+ (void)saveToLocalDB:(id)object saveIdenti:(NSString *)ident;

+ (id)getDataFromDB:(NSString *)ident;

+ (id)getDataArrayFromDB:(NSString *)ident;

+ (void)remove:(NSString *)ident;

+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory;

+ (NSString *)dataPath;

@end
