//
//  BFHXContactCell.h
//  BFTest
//
//  Created by JM on 2017/4/20.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#import "BFUserInfoModel.h"
#import <UIKit/UIKit.h>

@interface BFHXContactCell : UITableViewCell

@property (nonatomic,strong) BFUserInfoModel *model;

@property (nonatomic,assign) BOOL isblackListCell;

@end
