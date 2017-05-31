//
//  BFFriMediaClusterController.m
//  BFTest
//
//  Created by 伯符 on 16/12/15.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFFriMediaClusterController.h"
#import "FridTakePhotoController.h"
#import "FridVideoController.h"
#import "DTPhotoViewController.h"
#import "BFNavigationController.h"
#import "DTEdittingVideoController.h"
#import "UIImage+PKShortVideoPlayer.h"
@interface BFFriMediaClusterController ()<FridVideoDelegate>{
    UIButton *selectedBtn;
    UIView *bottomView;
    UIScrollView *scrollview;
}
@property (nonatomic,strong) NSArray *vcArray;

@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) DTPhotoViewController *dtvc;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) FridVideoController *videovc;

@end

@implementation BFFriMediaClusterController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleBtn = [[BFTitleButton alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 20*ScreenRatio)];
    [self.titleBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [self.titleBtn setImage:[UIImage imageNamed:@"albums-arrow"] forState:UIControlStateNormal];
    self.titleBtn.titleLabel.textColor = [UIColor whiteColor];
    self.titleBtn.titleLabel.font = BFFontOfSize(16);
    [self.titleBtn setBackgroundColor:[UIColor clearColor]];
    [self.titleBtn addTarget:self action:@selector(titleTapToAlbum:) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn.selected = NO;
    self.navigationItem.titleView = self.titleBtn;
    [self configureUI];
}


- (DTPhotoViewController *)dtvc{
    if (!_dtvc) {
        _dtvc = [[DTPhotoViewController alloc]init];
        _dtvc.fridmediaVC = self;
        [self addChildViewController:_dtvc];
        [self.view addSubview:_dtvc.view];
        
    }
    return _dtvc;
}

- (void)titleTapToAlbum:(UIButton *)btn{
    UIImageView *arrow = btn.imageView;
    if (!btn.selected) {
        self.rightBar.hidden = YES;
        self.dtvc.view.frame = CGRectMake(0, Screen_height, Screen_width, Screen_height - NavBar_Height);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            arrow.transform = CGAffineTransformMakeRotation(M_PI - 0.001);
            self.dtvc.view.frame = CGRectMake(0, 0, Screen_width, Screen_height - NavBar_Height);
            self.dtvc.titleBtn = btn;
        } completion:^(BOOL finished) {
            btn.selected = !btn.selected;
        }];
    }else{
        self.rightBar.hidden = NO;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            arrow.transform = CGAffineTransformIdentity;
            self.dtvc.view.frame = CGRectMake(0, Screen_height, Screen_width, Screen_height - NavBar_Height);
                
        } completion:^(BOOL finished) {
            btn.selected = !btn.selected;
            [_dtvc.view removeFromSuperview];
            [_dtvc removeFromParentViewController];
            _dtvc = nil;
        }];
    }

}



- (void)configureUI{
    self.rightStr = @"继续";
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_height - 45*ScreenRatio - NavBar_Height, Screen_width, 45*ScreenRatio)];
    bottomView.backgroundColor = BFColor(28, 29, 30, 1);
    [self.view addSubview:bottomView];
    self.titleArr = @[@"图片",@"拍照",@"视频"];
    for (int i = 0; i < 3; i ++ ) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_width/3*i, 0, Screen_width/3, 45*ScreenRatio)];
        btn.tag = 99 + i;
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        btn.clipsToBounds = YES;
        [btn setTitleColor:BFColor(183, 184, 185, 1) forState:UIControlStateNormal];
        [btn setTitleColor:BFColor(244, 214, 12, 1) forState:UIControlStateSelected];
        if (i == 0) {
            self.titleBtn.hidden = NO;
            btn.selected = YES;
            selectedBtn = btn;
        }else{
            btn.selected = NO;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
    }
    
    self.photovc = [[TWPhotoPickerController alloc] init];
    self.photovc.cropBlock = ^(UIImage *image) {
        NSLog(@"This is the image you choose %@",image);
        //do something
    };
//    BFPhotoSelectController *photovc = [[BFPhotoSelectController alloc]init];
    [self addChildViewController:self.photovc];
//    [self.view addSubview:self.photovc.view];
    
//    FridTakePhotoController *takephotovc = [[FridTakePhotoController alloc]init];
//    [self addChildViewController:takephotovc];
//    [self.view addSubview:takephotovc.view];
    
    self.videovc = [[FridVideoController alloc]init];
    self.videovc.delegate = self;
    self.videovc.clusterVC = self;
    [self addChildViewController:self.videovc];
    [self.view addSubview:self.videovc.view];
    
    self.vcArray = @[self.photovc,self.videovc];
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 45*ScreenRatio)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollview.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.scrollEnabled = YES;
    scrollview.bounces = NO;
    scrollview.contentSize = CGSizeMake(Screen_width * 2, Screen_height - 45*ScreenRatio);
    self.photovc.view.frame = CGRectMake(0, 0, scrollview.width, scrollview.height);
    self.videovc.view.frame = CGRectMake(Screen_width, 0, scrollview.width, scrollview.height);
    [scrollview addSubview:self.photovc.view];
    [scrollview addSubview:self.videovc.view];

    [self.view addSubview:scrollview];
    [self.view bringSubviewToFront:bottomView];
}

- (void)btnClick:(UIButton *)btn{
    if (btn != selectedBtn) {
        selectedBtn.selected =  NO;
        btn.selected = YES;
        selectedBtn = btn;
    }
    if (btn.tag - 99 == 0) {
        self.rightBar.hidden = NO;
        self.navigationItem.titleView = self.titleBtn;

    }else{
        if (![self canRecord]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewTitle:@"请打开相机访问权限" message:nil];
                
            });
        }
        
        if (![self openMicroph]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewTitle:@"请打开麦克风访问权限" message:nil];
            });
        }

        self.currentIndex = 1;
        self.rightBar.hidden = YES;
        self.navigationItem.titleView = nil;
        self.title = self.titleArr[btn.tag - 99];
    }
    if (btn.tag - 99 == 2) {
        self.currentIndex = 2;
        [scrollview setContentOffset:CGPointMake(Screen_width, 0) animated:NO];
        [self.videovc.scrollview setContentOffset:CGPointMake(Screen_width, 0) animated:NO];
    }else{
        [scrollview setContentOffset:CGPointMake(Screen_width * (btn.tag - 99), 0) animated:NO];
        [self.videovc.scrollview setContentOffset:CGPointMake(0, 0) animated:NO];

    }
    [self.view bringSubviewToFront:bottomView];
    
}

- (void)backpush:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.currentIndex == 2) {
        [self.videovc.deleteBtn removeFromSuperview];
    }
}


- (void)saveUserMsg:(UIButton *)save{
    if (selectedBtn.tag - 99 == 0) {
        TWPhotoPickerController *vc = self.vcArray[selectedBtn.tag - 99];
        vc.maskView.hidden = YES;
        [vc cropAction];
    }
    if (self.currentIndex == 2) {
        [self.videovc pushVC:^(NSString *imgPath) {
            UIImage *image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:imgPath]];
            DTEdittingVideoController *vc = [[DTEdittingVideoController alloc] initWithVideoPath:imgPath previewImage:image];
            vc.deleteBtn = self.videovc.deleteBtn;
            [self.videovc.navigationController pushViewController:vc animated:YES];
            
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentIndex = scrollView.contentOffset.x / scrollview.frame.size.width;
    
    if (currentIndex == self.currentIndex) {
        
    }
    self.currentIndex = currentIndex;
    NSArray *btnsArray = [bottomView subviews];
    for (UIButton *btn in btnsArray) {
        if (self.currentIndex == btn.tag - 99) {
            if (btn != selectedBtn) {
                selectedBtn.selected =  NO;
                btn.selected = YES;
                selectedBtn = btn;
            }
            if (btn.tag - 99 == 0) {
                self.rightBar.hidden = NO;
                self.navigationItem.titleView = self.titleBtn;
                
            }else{
                if (![self canRecord]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlertViewTitle:@"请打开相机访问权限" message:nil];

                    });
                }
                
                if (![self openMicroph]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlertViewTitle:@"请打开麦克风访问权限" message:nil];
                    });
                }
                
                self.rightBar.hidden = YES;
                self.navigationItem.titleView = nil;
                self.title = self.titleArr[btn.tag - 99];
            }

        }
    }
    
}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)scrollviewDidScroll:(NSInteger)index{
    if (index == 1) {
        if (![self canRecord]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewTitle:@"请打开相机访问权限" message:nil];
                
            });
        }
        
        if (![self openMicroph]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewTitle:@"请打开麦克风访问权限" message:nil];
            });
        }
        NSArray *btnsArray = [bottomView subviews];
        UIButton *thirdbtn = btnsArray[2];
        if (thirdbtn != selectedBtn) {
            selectedBtn.selected =  NO;
            thirdbtn.selected = YES;
            selectedBtn = thirdbtn;
        }
        self.rightBar.hidden = YES;
        self.navigationItem.titleView = nil;
        self.title = self.titleArr[2];
    }else{
        NSArray *btnsArray = [bottomView subviews];
        UIButton *thirdbtn = btnsArray[1];
        if (thirdbtn != selectedBtn) {
            selectedBtn.selected =  NO;
            thirdbtn.selected = YES;
            selectedBtn = thirdbtn;
        }
        self.rightBar.hidden = YES;
        self.navigationItem.titleView = nil;
        self.title = self.titleArr[1];
    }
}

@end
