//
//  RBFUserOtherReportVC.h
//  BFTest
//
//  Created by JM on 2017/4/12.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFUserInfoModel.h"
#import "BFUserOthersSettingModel.h"

@interface BFUserOtherReportVC : UITableViewController

@property (nonatomic,strong)BFUserInfoModel *model;
@property (nonatomic,strong)BFUserOthersSettingModel *settingModel;

@end
