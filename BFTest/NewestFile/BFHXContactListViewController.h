//
//  BFHXContactViewController.h
//  BFTest
//
//  Created by JM on 2017/4/19.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BFHXDetailViewController.h"

@interface BFHXContactListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UILabel *followNumLabel;

@property (weak, nonatomic) IBOutlet UIView *fansView;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak) UIViewController *imVC;

//刷新数据
- (void)reloadTableViewDataFinishCallBack:(void(^)())callBack;

@end
