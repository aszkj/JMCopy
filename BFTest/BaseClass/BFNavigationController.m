//
//  BFNavigationController.m
//  BFTest
//
//  Created by 伯符 on 16/5/3.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFNavigationController.h"
#import "UINavigationBar+RONavigationBar.h"
@interface BFNavigationController ()

@end

@implementation BFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 取消隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

/*
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    viewController.navigationController.navigationBar.hidden = NO;

    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 1) {
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
//        viewController.navigationItem.leftBarButtonItem = item;
    }
}
 */

- (void)backClick:(UIBarButtonItem *)backItem{
    [self popViewControllerAnimated:YES];
}

+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor blackColor];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
