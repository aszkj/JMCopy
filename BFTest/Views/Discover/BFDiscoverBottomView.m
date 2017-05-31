//
//  BFDiscoverBottomView.m
//  BFTest
//
//  Created by 伯符 on 16/12/9.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFDiscoverBottomView.h"
@interface BFDiscoverBottomView (){
    UIView *back;
}
@end
@implementation BFDiscoverBottomView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = BFColor(37, 38, 39, 1);
    UIButton *dynamic = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamic.frame = CGRectMake(0, 0, 35*ScreenRatio, 35*ScreenRatio);
    dynamic.center = CGPointMake(Screen_width/4, 55*ScreenRatio);
    dynamic.tag = DiscoverButtonTypeDynamic;
    [dynamic setBackgroundImage:[UIImage imageNamed:@"dynamic"] forState:UIControlStateNormal];
    [dynamic addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dynamic];
    
    UILabel *dynamicLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dynamic.frame), CGRectGetMaxY(dynamic.frame)+5*ScreenRatio, CGRectGetWidth(dynamic.frame), 20*ScreenRatio)];
    dynamicLabel.text = @"动态";
    dynamicLabel.textAlignment = NSTextAlignmentCenter;
    dynamicLabel.textColor = [UIColor whiteColor];
    dynamicLabel.font = BFFontOfSize(15);
    [self addSubview:dynamicLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(Screen_width/2, 20*ScreenRatio, 1.0, self.height - 55*ScreenRatio)];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
    
    UIButton *live = [UIButton buttonWithType:UIButtonTypeCustom];
    live.frame = CGRectMake(0, 0, 43*ScreenRatio, 35*ScreenRatio);
    live.center = CGPointMake(Screen_width/4 * 3, 55*ScreenRatio);
    live.tag = DiscoverButtonTypeLive;
    [live setBackgroundImage:[UIImage imageNamed:@"livebtn"] forState:UIControlStateNormal];
    [live addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:live];
    
    UILabel *liveLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(live.frame), CGRectGetMaxY(live.frame)+5*ScreenRatio, CGRectGetWidth(live.frame), 20*ScreenRatio)];
    liveLabel.text = @"直播";
    liveLabel.textAlignment = NSTextAlignmentCenter;
    liveLabel.textColor = [UIColor whiteColor];
    liveLabel.font = BFFontOfSize(15);
    [self addSubview:liveLabel];
    
    UIButton *cha = [UIButton buttonWithType:UIButtonTypeCustom];
    cha.frame = CGRectMake(0, 0, 17*ScreenRatio, 17*ScreenRatio);
    cha.center = CGPointMake(Screen_width/2, CGRectGetMaxY(line.frame)+19*ScreenRatio);
    cha.tag = DiscoverButtonTypeCha;
    [cha setBackgroundImage:[UIImage imageNamed:@"discha"] forState:UIControlStateNormal];
    [cha addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cha];
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(discoverViewClick:)]) {
        [self.delegate discoverViewClick:btn];
    }
}

- (void)show{
    back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    back.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:back];
    [window bringSubviewToFront:self];
    [back addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)]];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, Screen_height - self.height, Screen_width, self.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)resign{
    UITabBarController *tabvc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabvc.tabBar.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, Screen_height, Screen_width, self.height);
    } completion:^(BOOL finished) {
        [back removeFromSuperview];
    }];
}

@end
