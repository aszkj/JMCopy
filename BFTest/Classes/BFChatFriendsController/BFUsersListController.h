//
//  BFUsersListController.h
//  BFTest
//
//  Created by 伯符 on 16/8/16.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "EaseUsersListViewController.h"

@interface BFUsersListController : EaseUsersListViewController

- (void)refresh;

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//群组变化时，更新群组页面
- (void)reloadGroupView;

//好友个数变化时，重新获取数据
- (void)reloadDataSource;

//添加好友的操作被触发
- (void)addFriendAction;

@end
