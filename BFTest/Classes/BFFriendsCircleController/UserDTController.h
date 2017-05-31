//
//  UserDTController.h
//  BFTest
//
//  Created by 伯符 on 17/2/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDTController : UIViewController

@property (nonatomic,strong) NSMutableArray *dataArray;
// 缓存数组
@property (nonatomic,strong) NSMutableArray *cachesArray;

@property (nonatomic,strong) UITableView *interestList;

@property (nonatomic, assign) BOOL isSmallScreen;

@property (nonatomic,strong) NSDictionary *userDic;

@property (nonatomic, assign) BOOL isSelf;

@end
