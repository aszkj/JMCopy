//
//  EditDTFirstSearchController.h
//  BFTest
//
//  Created by 伯符 on 17/3/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditDongtaiController.h"

typedef void(^selectTopicBlock)(NSString *str);

@interface EditDTFirstSearchController : UIViewController

@property (nonatomic,copy) selectTopicBlock selectTopicBlock;

@property (nonatomic,strong) EditDongtaiController *editvc;
@end
