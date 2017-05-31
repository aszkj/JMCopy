//
//  BFScrollSelctView.m
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFScrollSelctView.h"

@implementation BFScrollSelctView

- (void)setImgSelected:(BOOL)imgSelected{
    _imgSelected = imgSelected;
    self.uprightBtn.selected = _imgSelected;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self configureBtn];
        [self registerRecognize];
        
    }
    return self;
}

- (void)configureBtn{
    UIButton *uprightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uprightBtn.frame = CGRectMake(self.width - 20*ScreenRatio, 5*ScreenRatio, 15*ScreenRatio, 15*ScreenRatio);
    [uprightBtn setBackgroundImage:[UIImage imageNamed:@"norbutton"] forState:UIControlStateNormal];
    [uprightBtn setBackgroundImage:[UIImage imageNamed:@"selbutton"] forState:UIControlStateSelected];
    [uprightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:uprightBtn];
    self.uprightBtn = uprightBtn;
}

- (void)registerRecognize{
    UIGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPicture:)];
    [self addGestureRecognizer:tapRec];
}

- (void)tapPicture:(UIGestureRecognizer *)tap{
    // 点击图片，跳转到图片大图浏览
    NSLog(@"tapPicture");
}

- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.imgSelected = btn.selected;
    if( self.imgSelectBlock(self.image) == NO){
        btn.selected = !btn.selected;
        self.imgSelected = btn.selected;
    }
}

- (void)selectedImg:(SelectImgBlock)block{
    self.imgSelectBlock = block;
}

@end
