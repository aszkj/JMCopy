//
//  UserHeaderView.h
//  BFTest
//
//  Created by 伯符 on 16/8/5.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,UserHeaderBtnType) {
    UserHeaderBtnDynamic = 0, // 动态
    UserHeaderBtnInterest,    // 关注
    UserHeaderBtnFans,        // 粉丝
    UserHeaderBtnEdit,        // 编辑个人主页
};

@interface UserHeaderView : UIView

@property (nonatomic,strong) NSDictionary *userDic;

@end
