//
//  BFVoiceIndicatorView.m
//  BFTest
//
//  Created by JM on 2017/4/27.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFVoiceIndicatorView.h"

@interface BFVoiceIndicatorView ()

@property (nonatomic,strong) UIImage *onImage;
@property (nonatomic,strong) UIImage *offImage;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *indicatorLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *indicatorView;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) void(^callBack)();

@end

static int currentTime = 0;

@implementation BFVoiceIndicatorView

- (instancetype)initWithStateOnImage:(UIImage *)imageOn stateOffImage:(UIImage *)imageOff  timeFullCallBack:(void (^)())callback{
    if(self == [super init]){
        self.callBack = callback;
        self.onImage = imageOn;
        self.offImage = imageOff;
        [self setupUI];
        [self setupTimer];
    }
    return self;
}
- (void)setupUI{
    
    UIImageView *imageV = [[UIImageView alloc]init];
    UILabel *timeLabel = [[UILabel alloc]init];
    UIView *indicatorView = [[UIView alloc]init];
    UILabel *indicatorLabel = [[UILabel alloc]init];
    UIView *backView = [[UIView alloc]init];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    indicatorView.layer.cornerRadius = 5;
    indicatorView.hidden = YES;
    
    backView.backgroundColor = BFColor(0, 0, 0, 0.3);
    indicatorView.backgroundColor = BFColor(226, 43, 36, 1);
    
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = self.offImage;
    
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    
    indicatorLabel.font = [UIFont systemFontOfSize:13];
    indicatorLabel.textColor = [UIColor whiteColor];
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.text = @"手指上滑，取消发送";
    
    self.imageView = imageV;
    self.timeLabel = timeLabel;
    self.indicatorLabel = indicatorLabel;
    self.indicatorView = indicatorView;
    self.backView = backView;
    
    [self addSubview:backView];
    [self addSubview:imageV];
    [self addSubview:timeLabel];
    [self addSubview:indicatorView];
    [self addSubview:indicatorLabel];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-40);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.equalTo(self);
        make.right.equalTo(self).offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*ScreenRatio);
        make.bottom.equalTo(self).offset(-8*ScreenRatio);
        make.width.equalTo(self).offset(-20*ScreenRatio);
        make.height.mas_equalTo(20);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.indicatorLabel);
    }];
    
}

- (void)setPowerLevel:(NSInteger)powerLevel{
    if(self.indicatorView.hidden == NO){
        return;
    }
    _powerLevel = powerLevel > 5 ? 5:powerLevel;
    
    NSLog(@"----------powerLevel ------ %zd",_powerLevel);
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"powerLevel_%zd",_powerLevel]];
}

- (void)setupTimer{
    
     __weak BFVoiceIndicatorView *weakSelf = self;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {

        if(currentTime < 60){

                self.timeLabel.text = [NSString stringWithFormat:@"%zd S",currentTime++];

        }else{
            weakSelf.callBack();
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            currentTime = 0;
        }
    }];
    
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}

- (void)showCancelStateOn:(BOOL)YESOrNO{
    self.indicatorView.hidden = !YESOrNO;
    self.indicatorLabel.text = YESOrNO ? @"松开手指，取消发送" : @"手指上滑，取消发送";
    if(self.indicatorView.hidden == NO){
        self.imageView.image = self.onImage ;
    }
    self.timeLabel.hidden = YESOrNO;
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self.timer invalidate];
    self.timer = nil;
    currentTime = 0;
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    currentTime = 0;
}

@end
