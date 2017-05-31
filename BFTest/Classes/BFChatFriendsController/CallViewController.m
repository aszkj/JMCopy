/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "CallViewController.h"
//#import "BFChatHelper.h"
#import "BFHXDelegateManager+call.h"
#import "ANBlurredImageView.h"
#import "BFOriginNetWorkingTool+userInfo.h"
@interface CallViewController ()
{
    __weak EMCallSession *_callSession;
    BOOL _isCaller;
    NSString *_status;
    int _timeLength;
    
    NSString * _audioCategory;
    ANBlurredImageView *view;

    
    //视频属性显示区域
    UIView *_propertyView;
    UILabel *_sizeLabel;
    UILabel *_timedelayLabel;
    UILabel *_framerateLabel;
    UILabel *_lostcntLabel;
    UILabel *_remoteBitrateLabel;
    UILabel *_localBitrateLabel;
    NSTimer *_propertyTimer;
    //弱网检测
    UILabel *_networkLabel;
    UIImageView *_backImageView;
    UIView *_backView;
}

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation CallViewController

- (instancetype)initWithSession:(EMCallSession *)session
                       isCaller:(BOOL)isCaller
                         status:(NSString *)statusString
{
    self = [super init];
    if (self) {
        _callSession = session;
        _isCaller = isCaller;
        _timeLabel.text = @"";
        _timeLength = 0;
        _status = statusString;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([ud valueForKey:kLocalCallBitrate] && _callSession.type == EMCallTypeVideo) {
            [session setVideoBitrate:[[ud valueForKey:kLocalCallBitrate] intValue]];
        }
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self showAlertViewTitle:@"视频已结束" message:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)achieveUserMsg{
    [BFOriginNetWorkingTool getUserInfoByJmid:[BFUserLoginManager shardManager].jmId otherJmid:_callSession.remoteUsername completionHandler:^(BFUserInfoModel *model, NSError *error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           
           [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"appuserlogo"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   if(image){
                       _backImageView.image = [self coreBlurImage:image withBlurNumber:6];
                   }
               });
           }];
           _nameLabel.text = model.name == nil ? @"陌生人":model.name;
       });
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:self.tapRecognizer];
    [self _setupSubviews];
    
    _nameLabel.text = _callSession.remoteUsername;
    _statusLabel.text = _status;
    if (_isCaller) {
        self.rejectButton.hidden = YES;
        self.answerButton.hidden = YES;
        self.cancelButton.hidden = NO;
        _silenceButton.hidden = YES;
        _silenceLabel.hidden = YES;
        _speakerOutButton.hidden = YES;
        _speakerOutLabel.hidden = YES;
    }
    else{
        self.cancelButton.hidden = YES;
        self.rejectButton.hidden = NO;
        self.answerButton.hidden = NO;
        _silenceButton.hidden = YES;
        _silenceLabel.hidden = YES;
        _speakerOutButton.hidden = YES;
        _speakerOutLabel.hidden = YES;
    }
    
    if (_callSession.type == EMCallTypeVideo) {
        [self _initializeVideoView];
        
        [self.view bringSubviewToFront:_topView];
        [self.view bringSubviewToFront:_actionView];
    }
    [self achieveUserMsg];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (BOOL)isShowCallInfo
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"showCallInfo"];
    return [object boolValue];
}

#pragma makr - property

- (UITapGestureRecognizer *)tapRecognizer
{
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    }
    
    return _tapRecognizer;
}

#pragma mark - subviews

- (void)_setupSubviews
{
    UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    UIView *maskView = [[UIView alloc]initWithFrame:backImageView.bounds];
    
    [backImageView addSubview:maskView];
    
    backView.backgroundColor = [UIColor blackColor];
    
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.image = [self coreBlurImage:[UIImage imageNamed:@"appuserlogo"] withBlurNumber:6];
    backImageView.alpha = 1;
    
    maskView.alpha = 0.7;
    maskView.backgroundColor = [UIColor blackColor];
    
    _backImageView = backImageView;
    _backView = backView;
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.navigationBarHidden = YES;
    
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 150)];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_statusLabel.frame), _topView.frame.size.width, 15)];
    
    _timeLabel.size = CGSizeMake(Screen_width, 30);
    _timeLabel.center = CGPointMake(Screen_width/2, Screen_height/2 + 30*ScreenRatio);
    _timeLabel.font = [UIFont systemFontOfSize:17.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_timeLabel];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*ScreenRatio, 60, 70, 70)];
    _headerImageView.layer.cornerRadius = _headerImageView.width/2;
    _headerImageView.layer.masksToBounds = YES;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.userdata[@"userIcon"]]];
    [_topView addSubview:_headerImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame)+9*ScreenRatio, CGRectGetMinY(_headerImageView.frame)+5, _topView.frame.size.width, 25)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [_topView addSubview:_nameLabel];
    
    waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame)+9*ScreenRatio, CGRectGetMaxY(_nameLabel.frame), _topView.frame.size.width, 25)];
    waitLabel.font = [UIFont systemFontOfSize:15.0];
    waitLabel.backgroundColor = [UIColor clearColor];
    waitLabel.textColor = [UIColor whiteColor];
    waitLabel.textAlignment = NSTextAlignmentLeft;
    waitLabel.text = @"正在等待对方接受邀请...";
    [_topView addSubview:waitLabel];
    
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, Screen_width, 260)];
    _actionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_actionView];
    
    CGFloat tmpWidth = _actionView.frame.size.width / 2;
    
    _silenceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    _silenceButton.center = CGPointMake(Screen_width/4, 260 - 150);
    _silenceButton.layer.cornerRadius = _silenceButton.width/2;
    _silenceButton.layer.masksToBounds = YES;
    [_silenceButton setImage:[UIImage imageNamed:@"jingyin"] forState:UIControlStateNormal];
    [_silenceButton setImage:[UIImage imageNamed:@"jingyin_h"] forState:UIControlStateSelected];
    [_silenceButton addTarget:self action:@selector(silenceAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_silenceButton];
    
    _silenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _silenceLabel.center = CGPointMake(Screen_width/4, CGRectGetMaxY(_silenceButton.frame)+20);
    
    _silenceLabel.backgroundColor = [UIColor clearColor];
    _silenceLabel.textColor = [UIColor whiteColor];
    _silenceLabel.font = [UIFont systemFontOfSize:13.0];
    _silenceLabel.textAlignment = NSTextAlignmentCenter;
    _silenceLabel.text = @"静音";
        [_actionView addSubview:_silenceLabel];
    
    _speakerOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    _speakerOutButton.center = CGPointMake(Screen_width/4*3, 260-150);
    _speakerOutButton.layer.cornerRadius = _silenceButton.width/2;
    _speakerOutButton.layer.masksToBounds = YES;
    [_speakerOutButton setImage:[UIImage imageNamed:@"mianti"] forState:UIControlStateNormal];
    [_speakerOutButton setImage:[UIImage imageNamed:@"mianti_h"] forState:UIControlStateSelected];
    [_speakerOutButton addTarget:self action:@selector(speakerOutAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_speakerOutButton];
    
    _speakerOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _speakerOutLabel.center = CGPointMake(Screen_width/4*3, CGRectGetMaxY(_speakerOutButton.frame)+20);
    _speakerOutLabel.backgroundColor = [UIColor clearColor];
    _speakerOutLabel.textColor = [UIColor whiteColor];
    _speakerOutLabel.font = [UIFont systemFontOfSize:13.0];
    _speakerOutLabel.textAlignment = NSTextAlignmentCenter;
    _speakerOutLabel.text = @"免提";
        [_actionView addSubview:_speakerOutLabel];
    
    
    _rejectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _rejectButton.layer.cornerRadius = _rejectButton.width/2;
    _rejectButton.layer.masksToBounds = YES;
    [_rejectButton setBackgroundImage:[UIImage imageNamed:@"callbtnred.png"] forState:UIControlStateNormal];

    [_rejectButton addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_rejectButton];
    
    _answerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"answercall.png"] forState:UIControlStateNormal];
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_answerButton];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _cancelButton.center = CGPointMake(Screen_width/2, 260 - 150);
    _cancelButton.layer.cornerRadius = _cancelButton.width/2;
    _cancelButton.layer.masksToBounds = YES;
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"callbtnred.png"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_cancelButton];
    
    _cancelbtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40*ScreenRatio, 17*ScreenRatio)];
    _cancelbtnLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(_cancelButton.frame)+ 17*ScreenRatio);
    _cancelbtnLabel.textAlignment = NSTextAlignmentCenter;
    _cancelbtnLabel.textColor = [UIColor whiteColor];
    _cancelbtnLabel.font = BFFontOfSize(16);
    [_actionView addSubview:_cancelbtnLabel];
    _cancelbtnLabel.text = @"取消";
    
    
    _switchCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _switchCameraButton.hidden = YES;
    _silenceButton.hidden = YES;
    _speakerOutButton.hidden = YES;
    
    _switchCameraButton.layer.cornerRadius = _switchCameraButton.width/2;
    _switchCameraButton.layer.masksToBounds = YES;
    [_switchCameraButton setBackgroundImage:[UIImage imageNamed:@"switchcamera"] forState:UIControlStateNormal];
    [_switchCameraButton addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
    _switchCameraButton.userInteractionEnabled = YES;
    [_actionView addSubview:_switchCameraButton];
    
    switchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenRatio, 17*ScreenRatio)];
    switchLabel.hidden = YES;
    switchLabel.center = CGPointMake(Screen_width/4*3, CGRectGetMaxY(_switchCameraButton.frame)+ 17*ScreenRatio);
    switchLabel.textAlignment = NSTextAlignmentCenter;
    switchLabel.textColor = [UIColor whiteColor];
    switchLabel.font = BFFontOfSize(16);
    [_actionView addSubview:switchLabel];
    switchLabel.text = @"切换摄像头";
    
    if (_callSession.type == EMCallTypeVoice) {
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view insertSubview:backView atIndex:0];
        [self.view insertSubview:backImageView atIndex:1];
    });
    }

    if (_callSession.type == EMCallTypeVideo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view insertSubview:backView atIndex:2];
            [self.view insertSubview:backImageView atIndex:3];
        });

        
        _switchCameraButton.hidden = YES;
        _silenceButton.hidden = YES;
        _speakerOutButton.hidden = YES;
        switchLabel.hidden = YES;
        _silenceButton.hidden = YES;
        _silenceLabel.hidden = YES;
        _speakerOutButton.hidden = YES;
        _speakerOutLabel.hidden = YES;
    }
    
    /*
    if (_callSession.type == EMCallTypeVideo) {
        CGFloat tmpWidth = _actionView.frame.size.width / 3;
        _recordButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth-40)/2, 20, 40, 40)];
        _recordButton.layer.cornerRadius = 20.f;
        [_recordButton setTitle:@"录制" forState:UIControlStateNormal];
        [_recordButton setTitle:@"停止播放" forState:UIControlStateSelected];
        [_recordButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_recordButton setBackgroundColor:[UIColor grayColor]];
        [_recordButton addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_recordButton];
        _videoButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, 20, 40, 40)];
        _videoButton.layer.cornerRadius = 20.f;
        [_videoButton setTitle:@"视频开启" forState:UIControlStateNormal];
        [_videoButton setTitle:@"视频中断" forState:UIControlStateSelected];
        [_videoButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_videoButton setBackgroundColor:[UIColor grayColor]];
        [_videoButton addTarget:self action:@selector(videoPauseAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_videoButton];
        _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth * 2 + (tmpWidth - 40) / 2, 20, 40, 40)];
        _voiceButton.layer.cornerRadius = 20.f;
        [_voiceButton setTitle:@"音视开启" forState:UIControlStateNormal];
        [_voiceButton setTitle:@"音视中断" forState:UIControlStateSelected];
        [_voiceButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_voiceButton setBackgroundColor:[UIColor grayColor]];
        [_voiceButton addTarget:self action:@selector(voicePauseAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_voiceButton];
    }
     */
}

- (void)_initializeVideoView
{
    //1.对方窗口
    _callSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_callSession.remoteVideoView];
    
    //2.自己窗口
    CGFloat width = 80;
    CGFloat height = self.view.frame.size.height / self.view.frame.size.width * width;
//    _callSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, CGRectGetMaxY(_statusLabel.frame), width, height - 20)];
    _callSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];


    [self.view addSubview:_callSession.localVideoView];
//    [self.view insertSubview:_backView atIndex:2];
    
    //3、属性显示层
    _propertyView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(_actionView.frame) - 90, self.view.frame.size.width - 20, 90)];
    _propertyView.backgroundColor = [UIColor clearColor];
    _propertyView.hidden = ![self isShowCallInfo];
    [self.view addSubview:_propertyView];
    
    width = (CGRectGetWidth(_propertyView.frame) - 20) / 2;
    height = CGRectGetHeight(_propertyView.frame) / 3;
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _sizeLabel.backgroundColor = [UIColor clearColor];
    _sizeLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_sizeLabel];
    
    _timedelayLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    _timedelayLabel.backgroundColor = [UIColor clearColor];
    _timedelayLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_timedelayLabel];
    
    _framerateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, width, height)];
    _framerateLabel.backgroundColor = [UIColor clearColor];
    _framerateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_framerateLabel];
    
    _lostcntLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, height, width, height)];
    _lostcntLabel.backgroundColor = [UIColor clearColor];
    _lostcntLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_lostcntLabel];
    
    _localBitrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height * 2, width, height)];
    _localBitrateLabel.backgroundColor = [UIColor clearColor];
    _localBitrateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_localBitrateLabel];
    
    _remoteBitrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, height * 2, width, height)];
    _remoteBitrateLabel.backgroundColor = [UIColor clearColor];
    _remoteBitrateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_remoteBitrateLabel];
}

#pragma mark - private

- (void)_reloadPropertyData
{
    if (_callSession) {
        _sizeLabel.text = [NSString stringWithFormat:@"%@%i/%i", NSLocalizedString(@"call.videoSize", @"Width/Height: "), [_callSession getVideoWidth], [_callSession getVideoHeight]];
        _timedelayLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoTimedelay", @"Timedelay: "), [_callSession getVideoTimedelay]];
        _framerateLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoFramerate", @"Framerate: "), [_callSession getVideoFramerate]];
        _lostcntLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoLostcnt", @"Lostcnt: "), [_callSession getVideoLostcnt]];
        _localBitrateLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoLocalBitrate", @"Local Bitrate: "), [_callSession getVideoLocalBitrate]];
        _remoteBitrateLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoRemoteBitrate", @"Remote Bitrate: "), [_callSession getVideoRemoteBitrate]];
    }
}

- (void)_beginRing
{
    [_ringPlayer stop];
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)_stopRing
{
    [_ringPlayer stop];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        if(s > 9){
            _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"00:0%i", s];
        }
    }
}

#pragma mark - UITapGestureRecognizer

- (void)viewTapAction:(UITapGestureRecognizer *)tap
{
    _topView.hidden = !_topView.hidden;
    _actionView.hidden = !_actionView.hidden;
}

#pragma mark - action

- (void)switchCameraAction
{
    [_callSession setCameraBackOrFront:_switchCameraButton.selected];
    _switchCameraButton.selected = !_switchCameraButton.selected;
}

- (void)recordAction
{
    _recordButton.selected = !_recordButton.selected;
    if (_recordButton.selected) {
        NSString *recordPath = NSHomeDirectory();
        recordPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer",recordPath];
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:recordPath]){
            [fm createDirectoryAtPath:recordPath
          withIntermediateDirectories:YES
                           attributes:nil
                                error:nil];
        }
        [_callSession startVideoRecord:recordPath];
    } else {
        NSString *tempPath = [_callSession stopVideoRecord];
        if (tempPath.length > 0) {
//            NSURL *videoURL = [NSURL fileURLWithPath:tempPath];
//            MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
//            [moviePlayerController.moviePlayer prepareToPlay];
//            moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//            [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
        }
    }
}

- (void)videoPauseAction
{
    _videoButton.selected = !_videoButton.selected;
    if (_videoButton.selected) {
        [[EMClient sharedClient].callManager pauseVideoTransfer:_callSession.sessionId];
    } else {
        [[EMClient sharedClient].callManager resumeVideoTransfer:_callSession.sessionId];
    }
}

- (void)voicePauseAction
{
    _voiceButton.selected = !_voiceButton.selected;
    if (_voiceButton.selected) {
        [[EMClient sharedClient].callManager pauseVoiceAndVideoTransfer:_callSession.sessionId];
    } else {
        [[EMClient sharedClient].callManager resumeVoiceAndVideoTransfer:_callSession.sessionId];
    }
}

- (void)silenceAction
{
    _silenceButton.selected = !_silenceButton.selected;
    [[EMClient sharedClient].callManager markCallSession:_callSession.sessionId isSilence:_silenceButton.selected];
}

- (void)speakerOutAction
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (_speakerOutButton.selected) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    [audioSession setActive:YES error:nil];
    _speakerOutButton.selected = !_speakerOutButton.selected;
}

// 接听
- (void)answerAction
{
//#if DEMO_CALL == 1
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view insertSubview:_backView atIndex:0];
        [self.view insertSubview:_backImageView atIndex:1];
    });
    
    [self _stopRing];
    switchLabel.text = @"切换摄像头";

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    _audioCategory = audioSession.category;
    if(![_audioCategory isEqualToString:AVAudioSessionCategoryPlayAndRecord]){
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(_callSession.type == EMCallTypeVideo){
                _speakerOutButton.selected = NO;
                [self speakerOutAction];
            }
        });
        [audioSession setActive:YES error:nil];
    }
    
    [[BFHXDelegateManager shareDelegateManager]  answerCall];
    if (_callSession.type == EMCallTypeVoice) {
        
        _cancelbtnLabel.hidden = NO;
        _cancelbtnLabel.font = BFFontOfSize(13);
        _cancelbtnLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(_cancelButton.frame)+ 17*ScreenRatio);
        switchLabel.hidden = YES;
        waitLabel.text = @"";
        
        _headerImageView.center = CGPointMake(Screen_width/2, Screen_height/2-40*ScreenRatio);
        _nameLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(_headerImageView.frame)+25);
        _nameLabel.textAlignment = NSTextAlignmentCenter;

    }
//#endif
}

- (void)hangupAction
{
//#if DEMO_CALL == 1
    [_timeTimer invalidate];
    [self _stopRing];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:_audioCategory error:nil];
    [audioSession setActive:YES error:nil];
    
    [[BFHXDelegateManager shareDelegateManager] hangupCallWithReason:EMCallEndReasonHangup];
//#endif
}

- (void)rejectAction
{
//#if DEMO_CALL == 1
    [_timeTimer invalidate];
    [self _stopRing];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:_audioCategory error:nil];
    [audioSession setActive:YES error:nil];
    
    [[BFHXDelegateManager shareDelegateManager] hangupCallWithReason:EMCallEndReasonDecline];
//#endif
}

#pragma mark - public

+ (BOOL)canVideo
{
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if(!([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized)){\
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"No camera permissions" message:@"Please open in \"Setting\"-\"Privacy\"-\"Camera\"." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alt show];
            return NO;
        }
    }
    
    return YES;
}

+ (void)saveBitrate:(NSString*)value
{
    NSScanner* scan = [NSScanner scannerWithString:value];
    int val;
    if ([scan scanInt:&val] && [scan isAtEnd]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:value forKey:kLocalCallBitrate];
        [ud synchronize];
    }
}

- (void)startTimer
{
    _timeLength = 0;
    _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)startShowInfo
{
    [self.view sendSubviewToBack:_backImageView];
    [self.view sendSubviewToBack:_backView];
    if (_callSession.type == EMCallTypeVideo && [self isShowCallInfo]) {
        [self _reloadPropertyData];
        _propertyTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(_reloadPropertyData) userInfo:nil repeats:YES];
    }
}

- (void)setNetwork:(EMCallNetworkStatus)status
{
    switch (status) {
        case EMCallNetworkStatusNormal:
        {
            _networkLabel.text = @"";
            _networkLabel.hidden = YES;
        }
            break;
        case EMCallNetworkStatusUnstable:
        {
            _networkLabel.text = @"当前网络不稳定";
            _networkLabel.hidden = NO;
        }
            break;
        case EMCallNetworkStatusNoData:
        {
            _networkLabel.text = @"没有通话数据";
            _networkLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)close
{
    _callSession.remoteVideoView.hidden = YES;
    _callSession = nil;
    _propertyView = nil;
    
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    
    if (_propertyTimer) {
        [_propertyTimer invalidate];
        _propertyTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}



- (void)layview{
    if (_callSession.type == EMCallTypeVideo) {
        _switchCameraButton.hidden = NO;
        switchLabel.hidden = NO;
        _nameLabel.hidden = NO;
        waitLabel.hidden = YES;
        _cancelButton.center = CGPointMake(Screen_width/4, 260 - 150);
        _cancelbtnLabel.center = CGPointMake(Screen_width/4, CGRectGetMaxY(_cancelButton.frame)+ 17*ScreenRatio);
        _switchCameraButton.center = CGPointMake(Screen_width/4*3, 260 - 150);
        switchLabel.center = CGPointMake(Screen_width/4*3, CGRectGetMaxY(_switchCameraButton.frame)+ 17*ScreenRatio);
        
        CGFloat width = 80;
        CGFloat height = self.view.frame.size.height / self.view.frame.size.width * width;
        _callSession.localVideoView.frame = CGRectMake(self.view.frame.size.width - 90, CGRectGetMaxY(_statusLabel.frame), width, height - 20);
    }else{
        
        _cancelButton.frame = CGRectMake(0, 0, 55, 55);
        _cancelButton.layer.cornerRadius = 55/2;
        _cancelButton.center = CGPointMake(Screen_width/2, 260 - 150);

        _cancelbtnLabel.font = BFFontOfSize(13);
        _cancelbtnLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(_cancelButton.frame)+ 17*ScreenRatio);
        _silenceButton.hidden = NO;
        _silenceLabel.hidden = NO;
        _speakerOutButton.hidden = NO;
        _speakerOutLabel.hidden = NO;
        waitLabel.hidden = YES;
        _nameLabel.hidden = NO;
        _headerImageView.center = CGPointMake(Screen_width/2, 300);
        _nameLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(_headerImageView.frame)+25);
        _nameLabel.textAlignment = NSTextAlignmentCenter;

    }
    

}

- (void)inviteVideo{
   
    _nameLabel.hidden = NO;
    if (_callSession.type == EMCallTypeVideo) {
        
        [self.view insertSubview:_backImageView atIndex:3];
        [self.view insertSubview:_backView atIndex:2];
        waitLabel.text = @"邀请您视频聊天";
    }else{
        waitLabel.text = @"邀请您语音聊天";

    }
    _rejectButton.center = CGPointMake(Screen_width/4, 260 - 150);
    _cancelbtnLabel.center = CGPointMake(Screen_width/4, CGRectGetMaxY(_rejectButton.frame)+ 17*ScreenRatio);

    _answerButton.center = CGPointMake(Screen_width/4*3, 260 - 150);
    switchLabel.center = CGPointMake(Screen_width/4*3, CGRectGetMaxY(_answerButton.frame)+ 17*ScreenRatio);
    switchLabel.hidden = NO;
    switchLabel.text = @"接听";

}


- (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
   
    CGRect extent = CGRectInset(filter.outputImage.extent, 0 , 0);
    CGImageRef outImage = [context createCGImage:result fromRect:extent];
    
//    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}


@end
