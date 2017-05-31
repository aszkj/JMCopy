//
//  BFMapUserView.h
//  BFTest
//
//  Created by 伯符 on 16/9/18.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFUserInfoModel.h"
@protocol BFUserViewDelete <NSObject>

- (void)userDeleteClick:(id)object;

// 点击聊天
- (void)pushtoUserChatID:(NSString *)jmid nickname:(NSString *)name icon:(NSString *)iconname;
// 点击关注
- (void)focusUserID:(NSString *)jmid;
// 点击头像跳个人资料页
- (void)pushtoUserMain:(NSString *)jmid name:(NSString *)user;


@end

@interface BFMapUserView : UITableView

@property (nonatomic,strong) NSDictionary *sellDic;

@property (nonatomic,strong) BFUserInfoModel *model;

// 是否关注
@property (nonatomic,assign) BOOL hasfocus;

@property (nonatomic,assign) id<BFUserViewDelete> userDelegate;


- (void)showMapAlertView;

@end
