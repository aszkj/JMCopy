//
//  BFButtonView.m
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFButtonView.h"

@interface BFButtonView (){
    BFChatInputBar *_inputBar;
}

@end

@implementation BFButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initViewImage:(NSString *)img imgframe:(CGRect)frame text:(NSString *)title{
    self = [self initWithFrame:frame];
    self.backgroundColor = BFColor(29, 29, 29, 1);
    UIImageView *centerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15*ScreenRatio, 15*ScreenRatio)];
    centerImg.center = CGPointMake(self.width/2, self.height/2 - 6*ScreenRatio);
    centerImg.contentMode = UIViewContentModeScaleAspectFill;
    centerImg.clipsToBounds = YES;
    centerImg.image = [UIImage imageNamed:img];
    [self addSubview:centerImg];
    if (title != nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 29*ScreenRatio, 15)];
        titleLabel.center = CGPointMake(self.width/2, CGRectGetMaxY(centerImg.frame)+10);
        titleLabel.text = title;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = BFFontOfSize(11);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    
    UIButton *pressBtn = [[UIButton alloc]initWithFrame:self.bounds];
    pressBtn.backgroundColor = [UIColor clearColor];
    [pressBtn addTarget:self action:@selector(pressClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pressBtn];
    
    return self;
}

- (instancetype)initViewImage:(NSString *)img imgframe:(CGRect)frame inputBar:(BFChatInputBar *)inputbar btntag:(NSInteger)tag{
    self = [self initWithFrame:frame];
    _inputBar = inputbar;
    UIImageView *centerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18*ScreenRatio, 18*ScreenRatio)];
    centerImg.userInteractionEnabled = YES;
    centerImg.center = CGPointMake(ChatInputBarHeight/2, ChatInputBarHeight/4);

    if (tag == BFFunctionViewShowVoice) {
        centerImg.center = CGPointMake(ChatInputBarHeight/4, ChatInputBarHeight/4);

    }
    centerImg.contentMode = UIViewContentModeScaleAspectFill;
    centerImg.clipsToBounds = YES;
    centerImg.image = [UIImage imageNamed:img];
    [self addSubview:centerImg];
    self.centerImg = centerImg;
    
    UIButton *pressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, ChatInputBarHeight/2)];
    pressBtn.backgroundColor = [UIColor clearColor];
    pressBtn.tag = tag;
    [pressBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pressBtn];
    self.pressBtn = pressBtn;
    
    return self;
}

- (instancetype)initViewImage:(NSString *)imgstr frame:(CGRect)frame imgframe:(CGRect)imgFrame btntag:(NSInteger)tag selectedimg:(NSString *)selectimg{
    self = [self initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.centerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgFrame.size.width, imgFrame.size.height)];
        self.centerImg.center = CGPointMake(self.width/2, self.height/2 + imgFrame.origin.y);
        self.centerImg.contentMode = UIViewContentModeScaleAspectFit;
        self.centerImg.clipsToBounds = YES;
        self.centerImg.image = [UIImage imageNamed:imgstr];
        self.centerImg.highlightedImage = [UIImage imageNamed:selectimg];
        [self addSubview:self.centerImg];
        
        UIButton *pressBtn = [[UIButton alloc]initWithFrame:self.bounds];
        pressBtn.tag = tag;
        pressBtn.backgroundColor = [UIColor clearColor];
        [pressBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pressBtn];
        self.pressBtn = pressBtn;
    }
    return self;
}

- (instancetype)initButtonFrame:(CGRect)buttonrect imgRect:(CGRect)imgrec img:(NSString *)imgstr btntag:(NSInteger)tag{
    self = [self initWithFrame:buttonrect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectImgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgrec.size.width, imgrec.size.height)];
        self.selectImgview.center = CGPointMake(self.width/2, self.height/2);
        self.selectImgview.contentMode = UIViewContentModeScaleAspectFit;
        self.selectImgview.clipsToBounds = YES;
        self.selectImgview.image = [UIImage imageNamed:imgstr];
        self.selectImgview.highlightedImage = [UIImage imageNamed:@"zanselect"];
        self.selectImgview.highlighted = NO;
        [self addSubview:self.selectImgview];
        
        self.pressBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.pressBtn.frame = buttonrect;
        self.pressBtn.tag = tag;
        self.tag = self.pressBtn.tag;
        self.pressBtn.selected = NO;
        self.pressBtn.backgroundColor = [UIColor clearColor];
        [self.pressBtn addTarget:self action:@selector(dongtaiClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pressBtn];
    }
    return self;
}


- (void)btnClick:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(bfButtonSelected:btnimg:)]) {
        [self.delegate bfButtonSelected:btn btnimg:self];
    }
}

- (void)buttonAction:(UIButton *)btn{
    [_inputBar buttonAction:btn];
}

- (void)pressClick:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PhotoCameraClick" object:nil userInfo:@{@"buttonViewType":@(self.btnViewType)}];
}

- (void)dongtaiClick:(UIButton *)btn{
    
    if (btn.tag == 999 + 2) {
        if (!self.selectImgview.highlighted) {
            self.selectImgview.highlighted = YES;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.selectImgview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
            } completion:^(BOOL finished) {
                self.selectImgview.transform = CGAffineTransformIdentity;
                if ([self.delegate respondsToSelector:@selector(dongtaiButton:btnimg:)]) {
                    [self.delegate dongtaiButton:self.selectImgview btnimg:self];
                }
            }];
            
            
        }else{
            self.selectImgview.highlighted = NO;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.selectImgview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
            } completion:^(BOOL finished) {
                self.selectImgview.transform = CGAffineTransformIdentity;
                if ([self.delegate respondsToSelector:@selector(dongtaiButton:btnimg:)]) {
                    [self.delegate dongtaiButton:self.selectImgview btnimg:self];
                }
            }];
        }
    }else if(btn.tag == 999 + 3){
        if ([self.delegate respondsToSelector:@selector(dongtaiButton:btnimg:)]) {
            [self.delegate dongtaiButton:self.selectImgview btnimg:self];
        }
    }else if (btn.tag == 999 + 4){
        // 举报
        if ([self.delegate respondsToSelector:@selector(dongtaiButton:btnimg:)]) {
            [self.delegate dongtaiButton:self.selectImgview btnimg:self];
        }
    }
    
}

- (void)setIsSelected:(BOOL)isSelected{
    self.centerImg.highlighted = isSelected;
}

- (void)setIsZan:(BOOL)isZan{
    self.selectImgview.highlighted = isZan;
}
@end
