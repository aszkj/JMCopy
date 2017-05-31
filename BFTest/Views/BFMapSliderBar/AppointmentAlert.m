//
//  AppointmentAlert.m
//  BFTest
//
//  Created by 伯符 on 17/1/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "AppointmentAlert.h"

@interface AppointmentAlert (){
    UILabel *titleLabel;
    dispatch_source_t _timer;
    
}
@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UIView *back;

@end

@implementation AppointmentAlert

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self configureUI];
        
    }
    return self;
}

- (UIView *)back{
    if (!_back) {
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        _back = [[UIView alloc]initWithFrame:win.bounds];
        _back.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    }
    return _back;
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60*ScreenRatio, 60*ScreenRatio)];
        _timeLabel.center = CGPointMake(self.width/2, self.height/2 + 20*ScreenRatio);
        _timeLabel.textColor = BFColor(245, 213, 22, 1);
        _timeLabel.font = BFFontOfSize(26);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (void)configureUI{
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    titleLabel = [[UILabel alloc]init];
//    titleLabel.center = self.center;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = BFFontOfSize(17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    
}

- (void)showAlert:(AppointmentAlertType)type{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    self.center = win.center;
    
    switch (type) {
        case AppointmentAlertTypeWaitting:{
            [win addSubview:self.back];
            [win addSubview:self];
            [self addSubview:self.timeLabel];
            titleLabel.frame = CGRectMake(0, 20*ScreenRatio, self.width, 20*ScreenRatio);
            titleLabel.text = @"等待对方确认中...";
            [self resumeTime];
        }
           
            break;
        case AppointmentAlertTypeNoresponse:{
            dispatch_cancel(_timer);
            NSString *str = @"对方没有作出回应,请重新选择约会对象";
            titleLabel.frame = CGRectMake(15*ScreenRatio, 20*ScreenRatio, self.width - 30*ScreenRatio, 50*ScreenRatio);
            titleLabel.text = str;
            [self.timeLabel removeFromSuperview];
            self.timeLabel = nil;
            
            [self removeSelf];
        }
            
            break;
        case AppointmentAlertTypeRefuse:{
            dispatch_cancel(_timer);
            NSString *str = @"对方已拒绝您的约会邀请,请重新选择约会对象";
            titleLabel.frame = CGRectMake(15*ScreenRatio, 20*ScreenRatio, self.width - 30*ScreenRatio, 50*ScreenRatio);
            titleLabel.text = str;
            [self.timeLabel removeFromSuperview];
            self.timeLabel = nil;
            [self removeSelf];

        }
            
            break;
        case AppointmentAlertTypeAgree:{
            dispatch_cancel(_timer);
            NSString *str = @"对方已同意您的约会邀请,请完成订单";
            titleLabel.frame = CGRectMake(15*ScreenRatio, 20*ScreenRatio, self.width - 30*ScreenRatio, 50*ScreenRatio);
            titleLabel.text = str;
            [self.timeLabel removeFromSuperview];
            self.timeLabel = nil;
            [self removeSelf];

        }
            
            break;
            
        default:
            break;
    }
}

- (void)resumeTime{
    __block int timeout = 20;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:AppointmentAlertTypeNoresponse];
            });
        }else{
            
            int seconds = timeout;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%is",seconds];
                self.timeLabel.text = str;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)removeSelf{
    
    __block int timeout = 2;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.back removeFromSuperview];
                [self removeFromSuperview];
            });
        }
        timeout--;

    });
    dispatch_resume(timer);
}

@end
