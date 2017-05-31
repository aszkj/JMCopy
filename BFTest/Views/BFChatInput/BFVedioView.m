//
//  BFVedioView.m
//  BFTest
//
//  Created by 伯符 on 16/7/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFVedioView.h"

@interface BFVedioView ()

@property (nonatomic,strong) UIButton *recordButton;
@property (nonatomic,strong) UILabel  *recordLabel;

@property (nonatomic,strong) UIView *recordBack;

@property (nonatomic,strong) UIProgressView *recordProgress;
@property (nonatomic,assign) CGFloat time;
@property (nonatomic,strong) NSTimer *timer;


@end

@implementation BFVedioView

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self.timer invalidate];
    self.time = 0.0f;
    [_recordBack removeFromSuperview];
    
    _recordBack = nil;
    _recordLabel = nil;
}

- (UILabel *)recordLabel{
    if (!_recordLabel) {
        _recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20*ScreenRatio, 120*ScreenRatio, 15*ScreenRatio)];
        _recordLabel.center = CGPointMake(Screen_width/2, 35*ScreenRatio/2);
        _recordLabel.font = [UIFont boldSystemFontOfSize:14];
        _recordLabel.textColor = BFColor(250, 212, 0, 1);
        _recordLabel.backgroundColor = [UIColor clearColor];
        _recordLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _recordLabel;
}

- (UIView *)recordBack{
    if (!_recordBack) {
        _recordBack = [[UIView alloc]init];
        _recordBack.backgroundColor = BFColor(37, 38, 39, 1);
        _recordProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 35*ScreenRatio, Screen_width, 10)];
        _recordProgress.progressTintColor = BFColor(250, 212, 0, 1);
        _recordProgress.trackTintColor = [UIColor clearColor];
        _recordProgress.progress = 0.0f;
        [_recordBack addSubview:_recordProgress];
        [_recordBack addSubview:self.recordLabel];
        
    }
    return _recordBack;
}

- (UIButton *)recordButton{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_recordButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        [_recordButton sizeToFit];
        [_recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_recordButton addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
    }
    
    return _recordButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.time = 0.0f;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = BFColor(37, 38, 39, 1);
    [self addSubview:self.recordButton];
    [self addSubview:self.recordLabel];
}

- (void)recordButtonTouchDown{
    [self startProgress];
    [self addSubview:self.recordBack];
    if (_delegate && [_delegate respondsToSelector:@selector(recordStartedVoiceAction:)]) {
        [_delegate recordStartedVoiceAction:self];
    }
}

- (void)startProgress{
    NSTimer *myTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timerFired:)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
    self.timer = myTimer;
}

- (void)timerFired:(NSTimer *)timer{
    _recordProgress.progress += 1.0f/6000.0f;
    self.time += 0.01;
    if (self.time >= 60.0f) {
        [self.timer invalidate];
        self.time = 0.0f;
        _recordLabel.text = [NSString stringWithFormat:@"录制结束 %.1fs",self.time];
        
    }
    _recordLabel.text = [NSString stringWithFormat:@"上滑取消 %.1fs",self.time];
}

- (void)recordButtonTouchUpOutside{
    [_recordBack removeFromSuperview];
    [self.timer invalidate];
    self.time = 0.0f;
    
    _recordBack = nil;
    _recordLabel = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)])
    {
        [_delegate didCancelRecordingVoiceAction:self];
    }
}

- (void)recordButtonTouchUpInside{
    NSLog(@"recordButtonTouchUpInside");
    [_recordBack removeFromSuperview];
    [self.timer invalidate];
    
    _recordBack = nil;
    _recordLabel = nil;
    self.time = 0.0f;
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)])
    {
        [self.delegate didFinishRecoingVoiceAction:self];
    }
    
}

- (void)recordDragOutside{
    NSLog(@"recordDragOutside");
    //    if (self.timer.isValid == YES) {
    //        [self.timer setFireDate:[NSDate distantFuture]];
    //
    //    }
    _recordLabel.textColor = [UIColor redColor];
    _recordLabel.text = [NSString stringWithFormat:@"松开取消"];
    
}

- (void)recordDragInside{
    _recordLabel.textColor = BFColor(250, 212, 0, 1);
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _recordButton.frame = CGRectMake(0, 0, 75*ScreenRatio, 75*ScreenRatio);
    _recordButton.center = CGPointMake(Screen_width/2, self.height/2);
    _recordBack.frame = CGRectMake(0, - 35*ScreenRatio, Screen_width, 35*ScreenRatio);
}

@end
