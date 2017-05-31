//
//  BFHXIMViewController.h
//  BFTest
//
//  Created by JM on 2017/4/19.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BFSegmentedControl.h"
#import "BFHXContactListViewController.h"
#import "BFHXConversationListViewController.h"


@interface BFHXIMViewController : UIViewController

@property (nonatomic,strong) BFHXConversationListViewController *conversationListVC;
@property (nonatomic,strong) BFHXContactListViewController *contactListVC;

@end


