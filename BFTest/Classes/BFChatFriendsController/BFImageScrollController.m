//
//  BFImageScrollController.m
//  BFTest
//
//  Created by 伯符 on 16/5/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFImageScrollController.h"
#import "BFInfinitScrollView.h"
@implementation BFImageScrollController

- (NSMutableArray *)imgArray{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initScrollView];
}

- (void)initScrollView{
    
    CGRect scrRect = CGRectMake(0, NavigationBar_Height, Screen_width, Screen_height - NavigationBar_Height - 64);
    BFInfinitScrollView *scroll = [BFInfinitScrollView adScrollViewWithFrame:scrRect imageLinkURL:self.imgArray placeHoderImageName:nil pageControlShowStyle:UIPageControlShowStyleNone currentIndex:self.currentIndex];
    [self.view addSubview:scroll];
}

@end
