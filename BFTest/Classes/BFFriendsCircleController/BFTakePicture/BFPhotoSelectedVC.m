//
//  BFPhotoSelectedVC.m
//  BFTest
//
//  Created by 伯符 on 17/2/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFPhotoSelectedVC.h"
#import "EditDongtaiController.h"
#import "TWImageScrollView.h"
@interface BFPhotoSelectedVC ()
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) TWImageScrollView *imageScrollView;

@end

@implementation BFPhotoSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightStr = @"继续";

    self.view.backgroundColor = [UIColor whiteColor];
    if (_postImage) {
        [self.view addSubview:self.topView];
    }
    
}

- (UIView *)topView {
    if (_topView == nil) {
        CGRect rect = CGRectMake(0, 0, Screen_width, Screen_width);
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.center = self.view.center;
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.backgroundColor = [UIColor blackColor];
        self.topView.clipsToBounds = YES;
        
        self.imageScrollView = [[TWImageScrollView alloc] initWithFrame:self.topView.bounds];
        [self.topView addSubview:self.imageScrollView];
        [self.topView sendSubviewToBack:self.imageScrollView];
        [self.imageScrollView displayImage:_postImage];
        
        self.maskView = [[UIImageView alloc] initWithFrame:rect];
        self.maskView.image = [UIImage imageNamed:@"straighten-grid"];
        [self.topView insertSubview:self.maskView aboveSubview:self.imageScrollView];
    }
    return _topView;
}

- (void)saveUserMsg:(UIButton *)save{
    EditDongtaiController *editvc = [[EditDongtaiController alloc]init];
    editvc.isImage = YES;
    if (self.imageScrollView.capture) {
        editvc.sendImage = self.imageScrollView.capture;
        [self.navigationController pushViewController:editvc animated:YES];
    }else{
        
    }
    
}
@end
