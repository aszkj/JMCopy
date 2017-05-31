//
//  BFInterestCellImageView.m
//  BFTest
//
//  Created by 伯符 on 16/11/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFInterestCellImageView.h"
@interface BFInterestCellImageView ()

@property (nonatomic, weak) UIButton *playBtn;

@end
@implementation BFInterestCellImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    return self;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:play];
        _playBtn = play;
        __weak __typeof(&*self)weakSelf = self;
        [play mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.center.equalTo(weakSelf);
        }];
        [play addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)playBtnClick:(UIButton *)btn {
    if (self.homeTableCellVideoDidBeginPlayHandle) {
        self.homeTableCellVideoDidBeginPlayHandle(btn);
    }
}

@end
