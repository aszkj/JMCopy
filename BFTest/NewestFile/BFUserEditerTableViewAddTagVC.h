//
//  BFUserEditerTableViewAddTagVC.h
//  BFTest
//
//  Created by JM on 2017/4/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFUserEditSelectedCell.h"
#import "BFUserInfoEditDataSourceManager.h"
#import "BFUserInfoModel.h"

@interface BFUserEditerTableViewAddTagVC : UITableViewController


/*---- 从一级编辑界面传过来的model  -----*/
@property (nonatomic,strong)BFUserInfoModel *model;

/*---- 通过segue从一级菜单传递过来的block 通过block的返回值 可以从BFUserInfoEditDataSourceManager单例拿到当前控制器的数据源  -----*/
@property (nonatomic,copy)NSIndexPath *(^callBack)(NSString *);

@end
