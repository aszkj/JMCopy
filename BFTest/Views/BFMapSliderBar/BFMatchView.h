//
//  BFMatchView.h
//  BFTest
//
//  Created by 伯符 on 17/1/5.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHCardItemModel;

@protocol BFMatchViewDelete <NSObject>

- (void)matchDeleteClick:(id)object;

- (void)pushToSettingVC;

- (void)achieveMoreData;
// 跳转聊天
- (void)pushtoUserChatID:(NSString *)jmid nickname:(NSString *)name icon:(NSString *)iconname;

@end
@interface BFMatchView : UIView

@property (nonatomic,copy) NSString *tinktext;

@property (nonatomic,strong) UIButton *settingBtn;

@property (nonatomic,assign) id<BFMatchViewDelete> delegate;
- (void)startedRadarScan:(NSString *)imgstr;

- (void)showMatchUserview:(NSMutableArray *)data;

- (void)matchSuccessView:(NSDictionary *)dic userModel:(CHCardItemModel *)model;
@end
