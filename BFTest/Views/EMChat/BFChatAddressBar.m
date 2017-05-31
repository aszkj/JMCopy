//
//  BFChatAddressBar.m
//  BFTest
//
//  Created by 伯符 on 16/8/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFChatAddressBar.h"
@interface BFChatAddressBar (){
    UIButton *selectedBtn;
}
@end
@implementation BFChatAddressBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BFColor(242, 243, 244, 1);
        [self configureUI];

    }
    return self;
}

- (void)configureUI{
    NSArray *titleArray = @[@"好友",@"关注",@"粉丝"];
    // 中间分割线
    verLineOne = [[UIImageView alloc]init];
    verLineOne.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verLineOne];
    
    verLineTwo = [[UIImageView alloc]init];
    verLineTwo.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verLineTwo];
    
    bottomLine = [[UIImageView alloc]init];
    bottomLine.backgroundColor = BFColor(172, 173, 174, 1);
    [self addSubview:bottomLine];
    
    sliderLine = [[UIImageView alloc]init];
    sliderLine.backgroundColor = [UIColor blackColor];
    sliderLine.frame = CGRectMake(0, self.height - 2, Screen_width/3, 2);
    [self addSubview:sliderLine];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 99;
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = BFFontOfSize(15);
        [self addSubview:btn];
        [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self tapBtn:btn];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [self viewWithTag:i + 99];
        btn.frame = CGRectMake(i * Screen_width/3, 0, Screen_width/3, self.height);
    }
    verLineOne.frame = CGRectMake(Screen_width/3, 10, 0.5, self.height - 20);
    verLineTwo.frame = CGRectMake(Screen_width/3*2, 10, 0.5, self.height - 20);
    bottomLine.frame = CGRectMake(0, self.height - 2, Screen_width, 2);
}

- (void)tapBtn:(UIButton *)btn{
    [UIView animateWithDuration:0.1 animations:^{
        sliderLine.frame = CGRectMake(Screen_width/3*(btn.tag - 99), self.height - 2, Screen_width/3, 2);
    }];
    if ([self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:btn.tag];
    }
}

- (void)barItemsWith:(NSArray *)titles{
    
}

@end
