//
//  BFSearchLocationController.h
//  BFTest
//
//  Created by 伯符 on 17/2/13.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFBaseTableVC.h"
#import "BFInterestSearchResultController.h"

@interface BFSearchLocationController : BFBaseTableVC
@property (nonatomic, strong) BFInterestSearchResultController *searchViewController;
@property (nonatomic,strong) NSMutableArray *data;

@end
