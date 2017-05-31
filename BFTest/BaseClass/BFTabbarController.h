//
//  BFTabbarController.h
//  BFTest
//
//  Created by 伯符 on 16/5/3.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTabbar.h"
@interface BFTabbarController : UITabBarController
@property (nonatomic,strong)BFTabbar *tabbar;

- (void)setupUnreadMessageCount;

- (void)setupUntreatedApplyCount;

- (void)setupUnreadDTCount;

//- (void)playSoundAndVibration;

//- (void)showNotificationWithMessage:(EMMessage *)message;
@end
