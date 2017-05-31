//
//  BFLeftController.m
//  BFTest
//
//  Created by 伯符 on 16/6/14.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFLeftController.h"
#import "BFNavigationController.h"

@interface BFLeftController ()

@end

@implementation BFLeftController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xback"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemClick:(UIBarButtonItem *)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
