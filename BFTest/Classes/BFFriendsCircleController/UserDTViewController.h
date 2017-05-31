//
//  UserDTViewController.h
//  BFTest
//
//  Created by 伯符 on 17/2/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFInterestModel.h"
@interface UserDTViewController : UIViewController

@property (nonatomic,assign) BOOL isSelf;

@property (nonatomic,strong) BFInterestModel *interestModel;

@property (nonatomic,strong) NSDictionary *userDic;

@property (nonatomic,strong) NSString *useruid;

@end
