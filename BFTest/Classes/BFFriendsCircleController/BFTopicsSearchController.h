//
//  BFTopicsSearchController.h
//  BFTest
//
//  Created by 伯符 on 17/3/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFInterestSearchResultController.h"
#import "LLSearchResultDelegate.h"
#import "EditDongtaiController.h"
@interface BFTopicsSearchController : UIViewController<LLSearchResultDelegate>

@property (nonatomic,strong) EditDongtaiController *editvc;

@property (nonatomic,copy) NSString *topicStr;

@property (nonatomic,assign) BOOL canEnter;

@property (nonatomic, strong) BFInterestSearchResultController *searchViewController;

@end
