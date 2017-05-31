//
//  AppDelegate+Register.h
//  BFTest
//
//  Created by JM on 2017/3/30.
//  Copyright © 2017年 bofuco. All rights reserved.
//

/**
 文件中有改动的部分：
 1.将原先继承的BFRegisterController的类私有属性改为非私有属性  原先两个私有方法该为非私有方法
 2.将原JinMaimMainController中的手机点击事件接口变更

  */
#import "AppDelegate.h"
#import "BFUserLoginManager.h"
#import "BFOriginNetWorkingTool+login.h"

@interface AppDelegate (Register)

/* 在分类中生成取值方法 拿到当前的根控制器（NavigationController）*/
//@property (nonatomic,readonly,weak)UINavigationController *currentNavigationController;

- (void)receiveToken:(NSString *)token from:(JM_TokenType )type;


@end
