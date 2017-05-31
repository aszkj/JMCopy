//
//  DTEdittingVideoController.m
//  BFTest
//
//  Created by 伯符 on 17/2/17.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "DTEdittingVideoController.h"
#import "EditDongtaiController.h"
@interface DTEdittingVideoController ()

@end

@implementation DTEdittingVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 40, 18);
    [back setTitle:@"取消" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:back];
    [back addTarget:self action:@selector(backpush:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBar;
    
    self.playerView.frame = CGRectMake(0, NavBar_Height, Screen_width, Screen_width);
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(0, 0, 40, 18);
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *saveBtem = [[UIBarButtonItem alloc]initWithCustomView:save];
    [save addTarget:self action:@selector(saveUserMsg:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = saveBtem;
}

- (void)backpush:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap{
    [self.playerView play];
}

- (void)saveUserMsg:(UIButton *)save{
    [self.playerView pause];
    [self.deleteBtn removeFromSuperview];
    EditDongtaiController *editvc = [[EditDongtaiController alloc]init];
    editvc.videoPath = self.videoPath;
    editvc.isImage = NO;
    editvc.sendImage = self.image;
    [self.navigationController pushViewController:editvc animated:YES];
}

@end
