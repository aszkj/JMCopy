//
//  DTAlertViewController.h
//  BFTest
//
//  Created by 伯符 on 2017/4/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFInterestModelFrame.h"

@interface DTAlertViewController : UIViewController

@property (nonatomic,copy) NSString *nid;
@property (nonatomic,copy) NSString *reply_userid;
@property (nonatomic,strong) BFInterestModelFrame *modelFrame;
@property (nonatomic,strong) void (^ReplyBlock)(BFInterestModelFrame *modelframe);
@property (nonatomic,copy) NSDictionary *userDic;

@end
