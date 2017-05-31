//
//  BFFriMediaClusterController.h
//  BFTest
//
//  Created by 伯符 on 16/12/15.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserBaseViewController.h"
#import "TWPhotoPickerController.h"
#import "BFTitleButton.h"
#import "BFInterestController.h"
@interface BFFriMediaClusterController : UserBaseViewController

@property (nonatomic,strong) TWPhotoPickerController *photovc;

@property (nonatomic,strong) BFTitleButton *titleBtn;

- (void)titleTapToAlbum:(UIButton *)btn;
@end
