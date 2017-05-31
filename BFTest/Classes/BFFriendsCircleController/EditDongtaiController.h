//
//  EditDongtaiController.h
//  BFTest
//
//  Created by 伯符 on 16/12/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDongtaiController : UITableViewController

@property (nonatomic,strong) UIImage *sendImage;

@property (nonatomic,strong) NSString *videoPath;

@property (nonatomic,assign) BOOL isImage;

@property (nonatomic,copy) NSString *topic;
@end
