//
//  UserDTDetailController.h
//  BFTest
//
//  Created by 伯符 on 17/3/6.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDTDetailController : UIViewController
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *targetuid;
@property (nonatomic,assign) BOOL isSelf;

@property (nonatomic,strong) NSString *nid;
@end
