//
//  UserHeaderView.m
//  BFTest
//
//  Created by 伯符 on 16/8/5.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView (){
    UIImageView *headerView;
    UIButton *dynamic;
    UIButton *interest;
    UIButton *fans;
    UIButton *editBtn;
    UILabel *dynamicL;
    UILabel *interestL;
    UILabel *fansL;
}

@property (nonatomic,strong) NSArray *userBtnArray;
@property (nonatomic,strong) NSArray *userLabelArray;
@end

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    headerView = [[UIImageView alloc]init];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.clipsToBounds = YES;
    [self addSubview:headerView];
    
    dynamic = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamic.tag = UserHeaderBtnDynamic;
    [dynamic setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dynamic addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dynamic];
    
    interest = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamic.tag = UserHeaderBtnInterest;
    [interest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [interest addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:interest];
    
    fans = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamic.tag = UserHeaderBtnFans;
    [fans setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fans addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fans];
    self.userBtnArray = @[dynamic,interest,fans];
    
    dynamicL = [[UILabel alloc]init];
    dynamicL.text = @"动态";
    dynamicL.textColor = [UIColor lightGrayColor];
    dynamicL.font = BFFontOfSize(12);
    dynamicL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dynamicL];
    
    interestL = [[UILabel alloc]init];
    interestL.text = @"关注";
    interestL.textColor = [UIColor lightGrayColor];
    interestL.font = BFFontOfSize(12);
    interestL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:interestL];
    
    fansL = [[UILabel alloc]init];
    fansL.text = @"粉丝";
    fansL.textColor = [UIColor lightGrayColor];
    fansL.font = BFFontOfSize(12);
    fansL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:fansL];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.tag = UserHeaderBtnEdit;
    [editBtn setTitle:@"编辑个人主页" forState:UIControlStateNormal];
    editBtn.titleLabel.font = BFFontOfSize(12);
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.masksToBounds = YES;
    [editBtn setBackgroundColor:[UIColor blackColor]];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setBackgroundColor:[UIColor blackColor]];
    [editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn];
    self.userLabelArray = @[dynamicL,interestL,fansL];
    
}

- (void)btnClick:(UIButton *)btn{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    headerView.frame = CGRectMake(10*ScreenRatio, 10*ScreenRatio, 35*ScreenRatio, 35*ScreenRatio);
    CGFloat spacing = (Screen_width - CGRectGetMaxX(headerView.frame) - 20*ScreenRatio - 30*ScreenRatio *3 - 20*ScreenRatio) / 2;
    for (int i = 0; i < 3; i ++ ) {
        UIButton *btn = self.userBtnArray[i];
        UILabel *label = self.userLabelArray[i];
        btn.frame = CGRectMake(CGRectGetMaxX(headerView.frame) + 40*ScreenRatio + (30*ScreenRatio + spacing - 15*ScreenRatio) * i, 10*ScreenRatio, 30*ScreenRatio, 16*ScreenRatio);
        label.frame = CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame)+ 2*ScreenRatio, 30*ScreenRatio, 16*ScreenRatio);
        if (i == 1) {
            editBtn.frame = CGRectMake(0, 0, 150*ScreenRatio, 28*ScreenRatio);
            editBtn.center = CGPointMake(btn.centerX, CGRectGetMaxY(label.frame) + 18*ScreenRatio);
            
        }
    }
    
    
    
}

- (void)setUserDic:(NSDictionary *)userDic{
    
    [dynamic setTitle:@"10" forState:UIControlStateNormal];
    [interest setTitle:@"9" forState:UIControlStateNormal];
    [fans setTitle:@"10" forState:UIControlStateNormal];
}

@end
