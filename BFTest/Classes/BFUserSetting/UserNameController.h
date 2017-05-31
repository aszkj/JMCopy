//
//  UserNameController.h
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserBaseViewController.h"
#import "UserSettingController.h"
@interface UserNameController : UserBaseViewController

@property (nonatomic,strong) NSString *comeFrom;

@property (nonatomic,strong) NSString *placeholderStr;

@property (nonatomic,assign) NSInteger rowIndex;

@property (nonatomic,strong) UserSettingController *userSettingVC;
@end
