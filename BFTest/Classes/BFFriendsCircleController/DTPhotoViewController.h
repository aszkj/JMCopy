//
//  DTPhotoViewController.h
//  BFTest
//
//  Created by 伯符 on 16/12/29.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BFFriMediaClusterController;

@interface DTPhotoViewController : UITableViewController
@property (nonatomic,strong) BFFriMediaClusterController *fridmediaVC;
@property (nonatomic,strong) UIButton *titleBtn;
@end
