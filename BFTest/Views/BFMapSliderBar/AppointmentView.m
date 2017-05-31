//
//  AppointmentView.m
//  BFTest
//
//  Created by 伯符 on 17/1/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "AppointmentView.h"

@interface AppointmentView (){
    UILabel *applyL;
    UIImageView *imgview;
}
@property (nonatomic,strong) NSDictionary *appointDic;
@end
@implementation AppointmentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        applyL = [[UILabel alloc]init];
        applyL.numberOfLines = 0;
        applyL.textColor = [UIColor whiteColor];
        applyL.font = BFFontOfSize(15);
        applyL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:applyL];
        
        imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 125*ScreenRatio, 65*ScreenRatio)];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds = YES;
        [self addSubview:imgview];
        
        UIButton *agree = [UIButton buttonWithType:UIButtonTypeCustom];
        agree.tag = 99;
        [agree setTitle:@"确定" forState:UIControlStateNormal];
        agree.frame = CGRectMake(30*ScreenRatio, Screen_height - 160*ScreenRatio, Screen_width - 60*ScreenRatio, 40*ScreenRatio);
        agree.layer.cornerRadius = 3*ScreenRatio;
        agree.layer.masksToBounds = YES;
        [agree setBackgroundColor:[UIColor blackColor]];
        agree.titleLabel.font = BFFontOfSize(15);
        [agree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agree addTarget:self action:@selector(applyClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:agree];
        
        UIButton *refusebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        refusebtn.tag = 100;
        [refusebtn setTitle:@"拒绝" forState:UIControlStateNormal];
        refusebtn.frame = CGRectMake(30*ScreenRatio,CGRectGetMaxY(agree.frame)+20*ScreenRatio, Screen_width - 60*ScreenRatio, 40*ScreenRatio);
        refusebtn.layer.cornerRadius = 3*ScreenRatio;
        refusebtn.layer.masksToBounds = YES;
        [refusebtn setBackgroundColor:BFColor(199, 20, 29, 1)];
        refusebtn.titleLabel.font = BFFontOfSize(15);
        [refusebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refusebtn addTarget:self action:@selector(applyClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:refusebtn];
    }
    return self;
}


- (void)showWithDic:(NSDictionary *)appointDic{
    self.appointDic = appointDic;
    NSString *apply = @"小旭旭向您发起了到探鱼的约会邀请，是否同意?";
    applyL.text = apply;
    CGRect rect = [apply boundingRectWithSize:CGSizeMake(Screen_width - 40*ScreenRatio, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:BFFontOfSize(15)} context:nil];
    applyL.frame = CGRectMake(20*ScreenRatio, 120*ScreenRatio, rect.size.width, rect.size.height);
    imgview.center = CGPointMake(Screen_width/2, CGRectGetMaxY(applyL.frame)+ 120*ScreenRatio);
    if (appointDic[@"a2"]) {
        [imgview sd_setImageWithURL:appointDic[@"a2"]];
    }
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)applyClick:(UIButton *)btnclick{

    NSString *fridID = self.appointDic[@"a3"];
    NSString *url = [NSString stringWithFormat:@"http://59.110.48.243:8000/sendxg"];
    NSDictionary *para;
    if (btnclick.tag == 99) {
        para = @{@"a1":@"yes",@"tkname":fridID,@"message_type":@3,@"message":@"haha"};
    }else{
        para = @{@"a1":@"no",@"tkname":fridID,@"message_type":@3,@"message":@"haha"};

    }
    [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",accessDict);
        [self removeFromSuperview];
        if ([accessDict[@"err_msg"] isEqualToString:@"ok"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
