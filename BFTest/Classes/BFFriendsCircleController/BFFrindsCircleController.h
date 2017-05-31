//
//  BFFrindsCircleController.h
//  BFTest
//
//  Created by 伯符 on 16/6/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFInterestSearchResultController.h"
#import "LLSearchResultDelegate.h"
@interface BFFrindsCircleController : UIViewController<LLSearchResultDelegate>

@property (nonatomic, strong) BFInterestSearchResultController *searchViewController;

@end
