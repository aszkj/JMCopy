//
//  PKShortVideoViewController.m
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "FridVideoController.h"
#import "PKShortVideoRecorder.h"
#import "PKShortVideoProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import "PKFullScreenPlayerViewController.h"
#import "UIImage+PKShortVideoPlayer.h"

#import "ZFProgressView.h"
#import "SCCommon.h"
#import "BFPhotoSelectedVC.h"
#import "DTEdittingVideoController.h"
#define CAMERA_TOPVIEW_HEIGHT   44  //title

static CGFloat PKOtherButtonVarticalHeight = 0;
static CGFloat PKRecordButtonVarticalHeight = 0;
static CGFloat PKPreviewLayerHeight = 0;

static CGFloat const PKRecordButtonWidth = 90;

@interface FridVideoController() <FridVideoDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSString *outputFilePath;
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, strong) UIColor *themeColor;

@property (strong, nonatomic) NSTimer *stopRecordTimer;
@property (nonatomic, assign) CFAbsoluteTime beginRecordTime;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *playButton;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) PKShortVideoProgressBar *progressBar;
@property (nonatomic, strong) PKShortVideoRecorder *recorder;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) ZFProgressView *progress;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) UIProgressView *recordProgress;
@property (nonatomic,assign) CGFloat time;
//@property (nonatomic,strong) NSTimer *timer;

@end

@implementation FridVideoController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.progress removeProgressLayer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

#pragma mark - Init

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize themeColor:(UIColor *)themeColor {
    self = [super init];
    if (self) {
        _themeColor = themeColor;
        _outputFilePath = outputFilePath;
        _outputSize = outputSize;
        _videoMaximumDuration = 108;
        _videoMinimumDuration = 1;
    }
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    PKPreviewLayerHeight = ceilf(3/4.0 * Screen_width);
    CGFloat spaceHeight = ceilf( (Screen_height - 44 - PKPreviewLayerHeight)/3 );
    PKRecordButtonVarticalHeight = ceilf( Screen_height - 2 * spaceHeight );
    PKOtherButtonVarticalHeight = ceilf( Screen_height - spaceHeight );
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(5, 10, 33, 33);
    [cancelBtn setImage:[UIImage imageNamed:@"PK_Delete"] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelShoot) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flexible = [UIButton buttonWithType:UIButtonTypeCustom];
    flexible.frame = CGRectMake(Screen_width - 5 - 40, 10, 40, 40);
    [flexible setImage:[UIImage imageNamed:@"PK_Camera_Turn"] forState:UIControlStateNormal];
    [self.view addSubview:flexible];
    [flexible addTarget:self action:@selector(swapCamera) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [NSProcessInfo processInfo].globallyUniqueString;
    NSString *path = [paths[0] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"video_mp4"]];
    //创建视频录制对象
    self.recorder = [[PKShortVideoRecorder alloc] initWithOutputFilePath:path outputSize:CGSizeMake(Screen_width, Screen_width)];
    //通过代理回调
    self.recorder.delegate = self;
    self.session = self.recorder.captureSession;
    
    //录制时需要获取预览显示的layer，根据情况设置layer属性，显示在自定义的界面上
    AVCaptureVideoPreviewLayer *previewLayer = [self.recorder previewLayer];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = CGRectMake(0, 0, Screen_width, Screen_width);
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
//    self.progress = [[ZFProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.progress.center = CGPointMake(Screen_width/2, Screen_height - 180);
//    [self.view addSubview:self.progress];
//    self.progress.timeDuration = 8.0f;
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(previewLayer.frame), Screen_width, Screen_height - CGRectGetMaxY(previewLayer.frame) - Tabbar_Height)];
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.scrollEnabled = YES;
    self.scrollview.bounces = NO;
    self.scrollview.contentSize = CGSizeMake(Screen_width * 2, Screen_height - CGRectGetMaxY(previewLayer.frame)- Tabbar_Height);
    [self.view addSubview:self.scrollview];
    
    CGFloat cameraBtnLength = 80;
    [self buildButton:CGRectMake((Screen_width - cameraBtnLength)/2, 20*ScreenRatio, cameraBtnLength, cameraBtnLength)
         normalImgStr:@"takephotoicon.png"
      highlightImgStr:@"takevideoicon.png"
       selectedImgStr:@""
               action:@selector(takePictureBtnPressed:)
           parentView:self.scrollview];
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake((Screen_width - cameraBtnLength)/2 + Screen_width, 20*ScreenRatio, cameraBtnLength, cameraBtnLength);
    [self.recordButton setImage:[UIImage imageNamed:@"takevideoicon.png"] forState:UIControlStateNormal];
    [self recordButtonAction];
    [self.scrollview addSubview:self.recordButton];
    
    _recordProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(Screen_width, 0, Screen_width, 10)];
    _recordProgress.progressTintColor = BFColor(250, 212, 0, 1);
    _recordProgress.trackTintColor = [UIColor clearColor];
    _recordProgress.progress = 0.0f;
    [self.scrollview addSubview:_recordProgress];
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//    //开始预览摄像头工作
    [self.recorder startRunning];
//        });
}

#pragma mark ---- 拍照
//拍照页面，拍照按钮
- (void)takePictureBtnPressed:(UIButton*)sender {
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"设备不支持拍照功能T_T"];
        return;
    }
#endif
    
    sender.userInteractionEnabled = NO;
    
    //    [self showCameraCover:YES];
    
    __block UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actiView.center = CGPointMake(self.view.center.x, self.view.center.y - CAMERA_TOPVIEW_HEIGHT);
    [actiView startAnimating];
    [self.view addSubview:actiView];
    
//    WEAKSELF_SC
    [self.recorder takePicture:^(UIImage *stillImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [SCCommon saveImageToPhotoAlbum:stillImage];//存至本机
        });
        
        [actiView stopAnimating];
        [actiView removeFromSuperview];
        actiView = nil;
        
        double delayInSeconds = 2.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            sender.userInteractionEnabled = YES;
            //            [weakSelf_SC showCameraCover:NO];
        });
        
        //your code 0
        BFPhotoSelectedVC *con = [[BFPhotoSelectedVC alloc] init];
        con.postImage = stillImage;
        [self.navigationController pushViewController:con animated:YES];
        
    }];
}

- (void)takeVideoBtnPressed:(UIButton*)sender {
    
    [self toggleRecording];
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
                  action:(SEL)action
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btn];
    
    return btn;
}


/**
 *  session
 */
- (void)addSession {
    AVCaptureSession *tmpSession = [[AVCaptureSession alloc] init];
    self.session = tmpSession;
    //设置质量
    //  _session.sessionPreset = AVCaptureSessionPresetPhoto;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



#pragma mark - Private

- (void)cancelShoot {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swapCamera {
    //切换前后摄像头
    [self.recorder swapFrontAndBackCameras];
}

- (void)recordButtonAction {
    [self.recordButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [self.recordButton addTarget:self action:@selector(toggleRecording) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(buttonStopRecording) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)sendButtonAction  {
    [self.recordButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
//    [self.recordButton addTarget:self action:@selector(sendVideo) forControlEvents:UIControlEventTouchUpInside];
//    [self.refreshButton addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
//    [self.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshView {
    _recordProgress.progress = 0;
    self.recordButton.enabled = YES;
    self.clusterVC.rightBar.hidden = YES;
    [self.deleteBtn removeFromSuperview];
    [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];

    
}

- (void)playVideo {
    UIImage *image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:self.outputFilePath]];
    PKFullScreenPlayerViewController *vc = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:self.outputFilePath previewImage:image];
    [self presentViewController:vc animated:NO completion:NULL];
}

- (void)toggleRecording {
    
//    [self.progress setProgress:1.0 Animated:YES];
    if ([self canRecord] && [self openMicroph]) {
        [self startProgress];
        
        //静止自动锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        //记录开始录制时间
        self.beginRecordTime = CACurrentMediaTime();
        //开始录制视频
        [self.recorder startRecording];
    }

}

- (void)startProgress{
    NSTimer *myTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timerFired:)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
    self.timer = myTimer;
}

- (void)timerFired:(NSTimer *)timer{
    _recordProgress.progress += 1.0f/900.0f;
    self.time += 0.01;
    if (self.time >= 9.0f) {
        [self.timer invalidate];
        self.time = 0.0f;
        
    }
}


- (void)buttonStopRecording {
//    [self.progress stopanimate];
    //停止录制
    [self.recorder stopRecording];

}

- (void)endRecordingWithPath:(NSString *)path failture:(BOOL)failture {
    
    [self.recordButton setTitle:@"拍摄" forState:UIControlStateNormal];
    
//    if (failture) {
//        [PKRecordShortVideoViewController showAlertViewWithText:@"生成视频失败"];
//    } else {
//        [PKRecordShortVideoViewController showAlertViewWithText:[NSString stringWithFormat:@"请长按超过%@秒钟",@(self.videoMinimumDuration)]];
//    }
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [self recordButtonAction];
}

+ (void)showAlertViewWithText:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"录制小视频失败" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)invalidateTime {
    if ([self.stopRecordTimer isValid]) {
        [self.stopRecordTimer invalidate];
        self.stopRecordTimer = nil;
    }
}


#pragma mark - PKShortVideoRecorderDelegate

///录制开始回调
- (void)recorderDidBeginRecording:(PKShortVideoRecorder *)recorder {
    //录制长度限制到时间停止
//    self.stopRecordTimer = [NSTimer scheduledTimerWithTimeInterval:self.videoMaximumDuration target:self selector:@selector(buttonStopRecording) userInfo:nil repeats:NO];
    
    [self.recordButton setTitle:@"" forState:UIControlStateNormal];
}

//录制结束回调
- (void)recorderDidEndRecording:(PKShortVideoRecorder *)recorder {
    //停止进度条

    [self.timer invalidate];
    self.time = 0.0f;
}

//视频录制结束回调
- (void)recorder:(PKShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(NSString *)outputFilePath error:(NSError *)error {
    //解除自动锁屏限制
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //取消计时器
    [self invalidateTime];
    
    if (error) {
        NSLog(@"视频拍摄失败: %@", error );
        [self endRecordingWithPath:outputFilePath failture:YES];
    } else {
        //当前时间
        CFAbsoluteTime nowTime = CACurrentMediaTime();
        if (self.beginRecordTime != 0 && nowTime - self.beginRecordTime < self.videoMinimumDuration) {
            [self endRecordingWithPath:outputFilePath failture:NO];
        } else {
            self.clusterVC.rightBar.hidden = NO;
            self.outputFilePath = outputFilePath;
            [self.recorder stopRecording];
            self.recordButton.enabled = NO;
            self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.deleteBtn.frame = CGRectMake(0, Screen_height, Screen_width, 45*ScreenRatio);
            self.deleteBtn.backgroundColor = [UIColor blackColor];
            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.deleteBtn.titleLabel.font = BFFontOfSize(15);
            [self.deleteBtn addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
            [[UIApplication sharedApplication].delegate.window addSubview:self.deleteBtn];
            [UIView animateWithDuration:0.5 animations:^{
                self.deleteBtn.frame = CGRectMake(0, Screen_height - 45*ScreenRatio, Screen_width, 45*ScreenRatio);

            }];
            
            /*
            [self.recordButton setTitle:@"发送" forState:UIControlStateNormal];
            self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.playButton.tintColor = self.themeColor;
            UIImage *playImage = [[UIImage imageNamed:@"PK_Play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.playButton setImage:playImage forState:UIControlStateNormal];
            [self.playButton sizeToFit];
            self.playButton.center = CGPointMake((Screen_width-PKRecordButtonWidth)/2/2, PKOtherButtonVarticalHeight);
            [self.view addSubview:self.playButton];
            
            self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.refreshButton.tintColor = self.themeColor;
            UIImage *refreshImage = [[UIImage imageNamed:@"PK_Delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.refreshButton setImage:refreshImage forState:UIControlStateNormal];
            [self.refreshButton sizeToFit];
            self.refreshButton.center = CGPointMake(Screen_width-(Screen_width-PKRecordButtonWidth)/2/2, PKOtherButtonVarticalHeight);
            [self.view addSubview:self.refreshButton];
            
            [self sendButtonAction];
             */
        }
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentIndex = scrollView.contentOffset.x / self.scrollview.frame.size.width;
    
    if (currentIndex == self.currentIndex) { return; }
    self.currentIndex = currentIndex;
    if ([self.delegate respondsToSelector:@selector(scrollviewDidScroll:)]) {
        [self.delegate scrollviewDidScroll:self.currentIndex];
    }
}

- (void)pushVC:(SelectVideo)select{
    if (select) {
        select(self.outputFilePath);
    }
}

@end
