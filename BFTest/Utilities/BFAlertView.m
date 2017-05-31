//
//  BFAlertView.m
//  BFTest
//
//  Created by 伯符 on 17/3/25.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFAlertView.h"

@interface BFAlertView(){
    NSString *contentMesg;
    NSString *mainStr;
    NSString *otherStr;
    UIView *backview;
}

@end
@implementation BFAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, Screen_width - 70*ScreenRatio, 130*ScreenRatio);
        self.center = CGPointMake(Screen_width/2, Screen_height/2);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = BFColor(37, 38, 39, 1);
    }
    return self;
}

- (instancetype)initWithContent:(NSString *)mesg mainBtn:(NSString *)main otherBtn:(NSString *)other{
    if (self = [self initWithFrame:CGRectZero]) {
        contentMesg = mesg;
        mainStr = main;
        otherStr = other;
        [self configureUI];
    }
    return self;
}

+ (instancetype)alertViewWithContent:(NSString *)content mainBtn:(NSString *)main otherBtn:(NSString *)other{
    
    return [[self alloc]initWithContent:content mainBtn:main otherBtn:other];
}

- (void)configureUI{
    UILabel *meslabel = [[UILabel alloc]initWithFrame:CGRectMake(30*ScreenRatio, 10*ScreenRatio, self.width - 60*ScreenRatio, self.height - 55*ScreenRatio)];
    meslabel.numberOfLines = 0;
    meslabel.lineBreakMode = NSLineBreakByWordWrapping;
    meslabel.textAlignment = NSTextAlignmentCenter;
    
    meslabel.font = BFFontOfSize(15);
    meslabel.textColor = [UIColor whiteColor];
    [self addSubview:meslabel];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentMesg];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:13];
    paragraphStyle1.alignment = NSTextAlignmentCenter;
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentMesg length])];
    meslabel.attributedText = str;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(meslabel.frame)+10*ScreenRatio, self.width, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    if (otherStr && otherStr.length > 0) {
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, CGRectGetMaxY(line.frame), (self.width - 0.5)/2, 35*ScreenRatio);
        [btn setTitle:mainStr forState:UIControlStateNormal];
        [btn setTitleColor:BFThemeColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), CGRectGetMinY(btn.frame), 0.3, btn.height)];
        vline.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:vline];
        
        UIButton *sbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sbtn.frame = CGRectMake(CGRectGetMaxX(vline.frame), CGRectGetMaxY(line.frame), (self.width - 0.3)/2, 35*ScreenRatio);
        [sbtn setTitle:otherStr forState:UIControlStateNormal];
        [sbtn setTitleColor:BFThemeColor forState:UIControlStateNormal];
        [sbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sbtn];
        
    }else{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, CGRectGetMaxY(line.frame), self.width, 35*ScreenRatio);
        [btn setTitle:mainStr forState:UIControlStateNormal];
        [btn setTitleColor:BFThemeColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn{
    [self resignView];
    if (self.action) {
        self.action(btn);
    }

}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    backview = [[UIView alloc]initWithFrame:window.bounds];
    backview.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [backview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignView)]];
    [window addSubview:backview];
    [backview addSubview:self];
    
    self.alpha = 0;
    self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
    
}

- (void)resignView{
    
    if (self.action) {
        self.action(nil);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [backview removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

@end
