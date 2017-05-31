//
//  BFJubaoView.m
//  BFTest
//
//  Created by 伯符 on 17/3/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFJubaoView.h"
#import "YYWebImage.h"
@interface BFJubaoView (){
    UIButton *selectBtn;
    UIView *backview;
}

@end
@implementation BFJubaoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //
        self.frame = CGRectMake(0, Screen_height, Screen_width, 120*ScreenRatio);
        self.backgroundColor = BFColor(37, 38, 39, 1);
        [self configureUI];
    }
    
    return self;
}

- (void)configureUI{
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 99 + i;
        btn.frame = CGRectMake(5*ScreenRatio, 15*ScreenRatio + (10*ScreenRatio + 35*ScreenRatio)*i, Screen_width - 10*ScreenRatio, 35 * ScreenRatio);
        NSString *btnstr = i == 0 ? @"举报" : @"取消";
        [btn setTitle:btnstr forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:BFThemeColor] forState:UIControlStateHighlighted];

        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = BFFontOfSize(15);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1.0;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    backview = [[UIView alloc]initWithFrame:window.bounds];
    backview.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [backview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeback:)]];
    [window addSubview:backview];
    [backview addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, - 120*ScreenRatio);
    } completion:^(BOOL finished) {
        //
    }];
    
}

- (void)btnclick:(UIButton *)btn{
    if (btn != selectBtn) {
        selectBtn.selected = NO;
        btn.selected = YES;
        selectBtn = btn;
    }
    NSString *btnstr = btn.titleLabel.text;
    if ([btnstr isEqualToString:@"取消"]) {
        [self resignView:nil];

    }else if ([btnstr isEqualToString:@"举报"]){
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //
            [self showDetailView];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, - 250*ScreenRatio);
                
            }completion:^(BOOL finished) {
                
            }];
        }];

    }else{
        [self resignView:btnstr];

    }
    
}


- (void)showDetailView{
    for (UIButton *btn in self.subviews) {
        [btn removeFromSuperview];
    }
    self.frame = CGRectMake(0, Screen_height, Screen_width, 250*ScreenRatio);
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 99 + i + 2;
        btn.frame = CGRectMake(5*ScreenRatio, 15*ScreenRatio + (10*ScreenRatio + 35*ScreenRatio)*i, Screen_width - 10*ScreenRatio, 35 * ScreenRatio);
        NSString *btnstr ;
        if (i == 0) {
            btnstr = @"广告欺诈";
        }else if (i == 1){
            btnstr = @"淫秽色情";
        }else if (i == 2){
            btnstr = @"骚扰谩骂";
        }else if (i == 3){
            btnstr = @"反动政治";
        }else if (i == 4){
            btnstr = @"取消";
        }
        [btn setTitle:btnstr forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:BFThemeColor] forState:UIControlStateHighlighted];

        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = BFFontOfSize(15);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1.0;
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (void)resignView:(NSString *)mesg{
    if (!mesg) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //
            if (finished) {
                [backview removeFromSuperview];
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //
            if (finished) {
                [backview removeFromSuperview];
            }
            self.block(mesg);

        }];
    }
}

- (void)removeback:(UITapGestureRecognizer *)recg{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //
        if (finished) {
            [backview removeFromSuperview];
        }
    }];
}

@end
