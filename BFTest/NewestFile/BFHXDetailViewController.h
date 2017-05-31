//
//  BFHXDetailViewController.h
//  BFTest
//
//  Created by JM on 2017/4/19.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,BFHXDetailVCType) {
    BFHXDetailVCTypeFans = 2,
    BFHXDetailVCTypeFollow,
    BFHXDetailVCTypeBlackList,
    BFHXDetailVCTypeSearchUser
};
@interface BFHXDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BFHXDetailVCType detailVCType;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *navTitle;

@property (nonatomic,weak) UIViewController *imVC;

@end
