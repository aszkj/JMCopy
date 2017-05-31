//
//  UserSettingController.h
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserBaseViewController.h"
#import "BFMapUserInfo.h"
@interface UserSettingController : UserBaseViewController
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) BFUserInfo *userItem;

@property (nonatomic,strong) UITableView *userList;

@property (nonatomic,copy) NSString *constellation;

@property (nonatomic,copy) NSString *birthday;

@end
