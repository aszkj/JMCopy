//
//  DTCommentViewController.h
//  BFTest
//
//  Created by 伯符 on 17/2/28.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFInterestModelFrame.h"
@interface DTCommentViewController : UIViewController
@property (nonatomic,copy) NSString *nid;
@property (nonatomic,copy) NSString *reply_userid;
@property (nonatomic,strong) BFInterestModelFrame *modelFrame;
@property (nonatomic,strong) void (^ReplyBlock)(BFInterestModelFrame *modelframe);
@property (nonatomic,copy) NSDictionary *userDic;

@end
