//
//  BFWelcomController.m
//  BFTest
//
//  Created by 伯符 on 16/5/31.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFWelcomController.h"
#import "BFNavigationController.h"
#import "JinMaimMainController.h"
@interface BFWelcomController (){
    UIScrollView *welcomeView;
    UIButton * btn;
    UIPageControl *pageControl;
}

@end

@implementation BFWelcomController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureScrollview];
    [self configurePagecontrol];
}

- (void)configureScrollview{
    welcomeView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    welcomeView.backgroundColor = [UIColor yellowColor];
    welcomeView.delegate =self;
    [self.view addSubview:welcomeView];
    //关闭水平方向上的滚动条
    welcomeView.showsHorizontalScrollIndicator = NO;
    welcomeView.showsVerticalScrollIndicator = NO;
    //是否可以整屏滑动
    welcomeView.pagingEnabled =YES;
    welcomeView.bounces = NO;
    welcomeView.contentSize =CGSizeMake(Screen_width * 4, Screen_height);
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_width * i, 0,Screen_width, Screen_height)];
        NSString *imgName = [NSString stringWithFormat:@"bfwelcome_%i.jpg",i];
        imageView.image = [UIImage imageNamed:imgName];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [welcomeView addSubview:imageView];
        if (i == 3) {
            imageView.userInteractionEnabled = YES;
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 90, 30);
            btn.layer.cornerRadius = 7;
            btn.alpha = 0.0f;
            btn.center = CGPointMake(Screen_width/2, Screen_height - 60);
            btn.titleLabel.font = BFFontOfSize(15);
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            btn.backgroundColor = BFColor(253, 185, 44, 1);
            [btn setTitleColor:BFColor(46, 42, 40, 1) forState:UIControlStateNormal];
            [imageView addSubview:btn];
            [btn addTarget:self action:@selector(enterMainView:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)configurePagecontrol{
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    pageControl.center = CGPointMake(Screen_width/2, Screen_height - 20);
    pageControl.numberOfPages = 4;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = BFColor(253, 185, 44, 1);
    [self.view addSubview:pageControl];
}

#pragma mark - scrollViewDelegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl.currentPage = scrollView.contentOffset.x / Screen_width;
    if (pageControl.currentPage == 3) {
        [UIView animateWithDuration:0.8 animations:^{
            btn.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)enterMainView:(UIButton *)btn{
    JinMaimMainController *main = [[JinMaimMainController alloc]init];
    BFNavigationController *nv = [[BFNavigationController alloc]initWithRootViewController:main];
    [UIView animateWithDuration:0.7 animations:^{
        welcomeView.alpha = 0.3;
    } completion:^(BOOL finished) {
        [UIApplication sharedApplication].keyWindow.rootViewController = nv;
    }];
}

@end
