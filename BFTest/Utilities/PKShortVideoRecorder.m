//
//  PKShortVideoWriter.m
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "PKShortVideoRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "PKShortVideoSession.h"


#import <ImageIO/ImageIO.h>
#import "UIImage+Resize.h"


typedef NS_ENUM( NSInteger, PKRecordingStatus ) {
    PKRecordingStatusIdle = 0,
    PKRecordingStatusStartingRecording,
    PKRecordingStatusRecording,
    PKRecordingStatusStoppingRecording,
}; 

@interface PKShortVideoRecorder() <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, PKShortVideoSessionDelegate>

@property (nonatomic, strong) NSString *outputFilePath;
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, strong) NSString *tempFilePath;

@property (nonatomic, strong) dispatch_queue_t recorderQueue;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) dispatch_queue_t audioDataOutputQueue;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureConnection *cameraConnection;

@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;

@property (nonatomic) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic) CMFormatDescriptionRef outputAudioFormatDescription;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;

@property (nonatomic, assign) PKRecordingStatus recordingStatus;

@property (nonatomic, retain) PKShortVideoSession *assetSession;

@end

@implementation PKShortVideoRecorder

#pragma mark - Init

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize {
    self = [super init];
    if (self) {
        
        _scaleNum = 1.f;
        _preScaleNum = 1.f;
        _outputFilePath = outputFilePath;
        _outputSize = outputSize;
        
        _recorderQueue = dispatch_queue_create("com.PKShortVideoWriter.sessionQueue", DISPATCH_QUEUE_SERIAL );
        
        _audioDataOutputQueue = dispatch_queue_create("com.PKShortVideoWriter.audioOutput", DISPATCH_QUEUE_SERIAL );

        _videoDataOutputQueue = dispatch_queue_create("com.PKShortVideoWriter.videoOutput", DISPATCH_QUEUE_SERIAL );
        
        dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
        
        self.sessionQueue = sessionQueue;

        dispatch_set_target_queue(_videoDataOutputQueue, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ) );
        
        _captureSession = [self setupCaptureSession];

        [self addVideoInputFrontCamera:NO];
        [self addStillImageOutput];

        [self addDataOutputsToCaptureSession:self.captureSession];
    }
    return self;
}

- (void)dealloc {
    [_captureSession stopRunning];
    self.previewLayer = nil;
    self.captureSession = nil;
    self.stillImageOutput = nil;
    //    self.stillImage = nil;
}


- (void)addStillImageOutput {
    
    AVCaptureStillImageOutput *tmpOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];//输出jpeg
    tmpOutput.outputSettings = outputSettings;
    
    //    AVCaptureConnection *videoConnection = [self findVideoConnection];
    
    [_captureSession addOutput:tmpOutput];
    
    self.stillImageOutput = tmpOutput;
}


- (void)addVideoInputFrontCamera:(BOOL)front {
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
                
            }  else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    
    if (front) {
        AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!error) {
            if ([_captureSession canAddInput:frontFacingCameraDeviceInput]) {
                [_captureSession addInput:frontFacingCameraDeviceInput];
                self.inputDevice = frontFacingCameraDeviceInput;
                
            } else {
                NSLog(@"Couldn't add front facing video input");
            }
        }
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            if ([_captureSession canAddInput:backFacingCameraDeviceInput]) {
                [_captureSession addInput:backFacingCameraDeviceInput];
                self.inputDevice = backFacingCameraDeviceInput;
            } else {
                NSLog(@"Couldn't add back facing video input");
            }
        }
    }
}



#pragma mark - Running Session

- (void)startRunning {
    dispatch_sync(self.recorderQueue, ^{
        [self.captureSession startRunning];
    } );
}

- (void)stopRunning {
    dispatch_sync(self.recorderQueue, ^{
        [self stopRecording];
        [self.captureSession stopRunning];
    } );
}



#pragma mark - Recording

- (void)startRecording {
    @synchronized(self) {
        if (self.recordingStatus != PKRecordingStatusIdle) {
            NSLog(@"已经在录制了");
            return;
        }   
        [self transitionToRecordingStatus:PKRecordingStatusStartingRecording error:nil];
    }
    
    NSString *tempFileName = [NSProcessInfo processInfo].globallyUniqueString;
    self.tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[tempFileName stringByAppendingPathExtension:@"mp4"]];
    
    self.assetSession = [[PKShortVideoSession alloc] initWithTempFilePath:self.tempFilePath];
    self.assetSession.delegate = self;
    
    
    [self.assetSession addVideoTrackWithSourceFormatDescription:self.outputVideoFormatDescription settings:self.videoCompressionSettings];
    [self.assetSession addAudioTrackWithSourceFormatDescription:self.outputAudioFormatDescription settings:self.audioCompressionSettings];
    
    [self.assetSession prepareToRecord];
}

- (void)stopRecording {
    @synchronized(self) {
        if (self.recordingStatus != PKRecordingStatusRecording){
            return;
        }
        [self transitionToRecordingStatus:PKRecordingStatusStoppingRecording error:nil];
    }
    [self.assetSession finishRecording];
}



#pragma mark - SwapCamera

- (void)swapFrontAndBackCameras {
    NSArray *inputs = self.captureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            } else {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];

            //beginConfiguration 确保改变不会立刻应用
            [self.captureSession beginConfiguration];
            
            [self.captureSession removeOutput:self.videoDataOutput];
            [self.captureSession removeOutput:self.audioDataOutput];

            [self.captureSession removeInput:input];
            [self.captureSession addInput:newInput];
            
            self.inputDevice = newInput;

            self.outputVideoFormatDescription = nil;
            self.outputAudioFormatDescription = nil;
            //开始生效
            [self.captureSession commitConfiguration];
            //重新加载
            [self addDataOutputsToCaptureSession:self.captureSession];
            break;
        }
    }
}



#pragma mark - Private methods

- (void)addDataOutputsToCaptureSession:(AVCaptureSession *)captureSession {
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    self.videoDataOutput.videoSettings = nil;
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    self.audioDataOutput = [AVCaptureAudioDataOutput new];
    [self.audioDataOutput setSampleBufferDelegate:self queue:self.audioDataOutputQueue];
    
    [self addOutput:self.videoDataOutput toCaptureSession:self.captureSession];
    
    self.cameraConnection = [self findVideoConnection];
    self.videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    [self addOutput:self.audioDataOutput toCaptureSession:self.captureSession];
    self.audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    
    [self setCompressionSettings];
}

- (void)setCompressionSettings {
    NSInteger numPixels = self.outputSize.width * self.outputSize.height;
    //每像素比特
    CGFloat bitsPerPixel = 6.0;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
    
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                    AVVideoExpectedSourceFrameRateKey : @(30),
                                             AVVideoAverageBitRateKey : @(30) };
    
    self.videoCompressionSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                 AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                       AVVideoWidthKey : @(self.outputSize.height),
                                      AVVideoHeightKey : @(self.outputSize.width),
                       AVVideoCompressionPropertiesKey : compressionProperties };
    
    // 音频设置
    self.audioCompressionSettings = @{ AVEncoderBitRatePerChannelKey : @(28000),
                                                       AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                               AVNumberOfChannelsKey : @(1),
                                                     AVSampleRateKey : @(22050) };
}



#pragma mark - SampleBufferDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == self.videoConnection){
        if (!self.outputVideoFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputVideoFormatDescription = formatDescription;
            }
        } else {
            @synchronized(self) {
                if (self.recordingStatus == PKRecordingStatusRecording){
                    [self.assetSession appendVideoSampleBuffer:sampleBuffer];
                }
            }
        }
    } else if (connection == self.audioConnection ){
        if (!self.outputAudioFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputAudioFormatDescription = formatDescription;
            }
        }
        @synchronized(self) {
            if (self.recordingStatus == PKRecordingStatusRecording){
                [self.assetSession appendAudioSampleBuffer:sampleBuffer];
            }
        }
    }
}

#pragma mark - PKAssetWriterDelegate methods

- (void)sessionDidFinishPreparing:(PKShortVideoRecorder *)writer {
    @synchronized(self) {
        if (self.recordingStatus != PKRecordingStatusStartingRecording){
            return;
        }
        [self transitionToRecordingStatus:PKRecordingStatusRecording error:nil];
    }
}

- (void)session:(PKShortVideoRecorder *)writer didFailWithError:(NSError *)error {
    @synchronized(self) {
        self.assetSession = nil;
        [self transitionToRecordingStatus:PKRecordingStatusIdle error:error];
    }
}

- (void)sessionDidFinishRecording:(PKShortVideoRecorder *)writer {
    @synchronized(self) {
        if ( self.recordingStatus != PKRecordingStatusStoppingRecording ) {
            return;
        }
    }
    self.assetSession = nil;
    
    @synchronized(self) {
        [self transitionToRecordingStatus:PKRecordingStatusIdle error:nil];
    }
}


#pragma mark - Recording State Machine

- (void)transitionToRecordingStatus:(PKRecordingStatus)newStatus error:(NSError *)error {
    PKRecordingStatus oldStatus = self.recordingStatus;
    self.recordingStatus = newStatus;
    
    if (newStatus != oldStatus){
        if (error && (newStatus == PKRecordingStatusIdle)){
            dispatch_async( dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [self.delegate recorder:self didFinishRecordingToOutputFilePath:self.outputFilePath error:error];
                }
            });
        } else {
            error = nil;
            if (oldStatus == PKRecordingStatusStartingRecording && newStatus == PKRecordingStatusRecording){
                dispatch_async( dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        [self.delegate recorderDidBeginRecording:self];
                    }
                });
            } else if (oldStatus == PKRecordingStatusStoppingRecording && newStatus == PKRecordingStatusIdle) {
                dispatch_async( dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        [self.delegate recorderDidEndRecording:self];
                        [self.delegate recorder:self didFinishRecordingToOutputFilePath:self.tempFilePath error:nil];
                    }
                });
            }
        }
    }
}

#pragma mark - Capture Session Setup


- (AVCaptureSession *)setupCaptureSession {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc]init];
    
    if (self.isBigSize) {
        captureSession.sessionPreset = AVCaptureSessionPresetMedium;//360 x 480 小视频一般不会超过此尺寸
    } else {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720;//720 x 1280 小视频一般不会超过此尺寸
    }
    
    if (![self addDefaultCameraInputToCaptureSession:captureSession]){
        NSLog(@"加载摄像头失败");
    }
    if (![self addDefaultMicInputToCaptureSession:captureSession]){
        NSLog(@"加载麦克风失败");
    }
    
    return captureSession;
}

- (BOOL)addDefaultCameraInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    
    if (error) {
        NSLog(@"配置摄像头输入错误: %@", [error localizedDescription]);
        return NO;
    } else {
        BOOL success = [self addInput:cameraDeviceInput toCaptureSession:captureSession];
        self.cameraDevice = cameraDeviceInput.device;
        return success;
    }
}

- (BOOL)addDefaultMicInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error;
    AVCaptureDeviceInput *micDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    if (error){
        NSLog(@"配置麦克风输入错误: %@", [error localizedDescription]);
        return NO;
    } else {
        BOOL success = [self addInput:micDeviceInput toCaptureSession:captureSession];
        return success;
    }
}

- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddInput:input]){
        [captureSession addInput:input];
        return YES;
    } else {
        NSLog(@"不能添加输入: %@", [input description]);
    }
    return NO;
}


- (BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddOutput:output]){
        [captureSession addOutput:output];
        return YES;
    } else {
        NSLog(@"不能添加输出 %@", [output description]);
    }
    return NO;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            return device;
        }
    }
    return nil;
}


#pragma mark - Getter

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer && _captureSession){
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    return _previewLayer;
}

- (BOOL)isBigSize {
    if (self.outputSize.width > 360 || self.outputSize.width/self.outputSize.height > 4/3) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - actions
/**
 *  拍照
 */
- (void)takePicture:(DidCapturePhotoBlock)block {
//    AVCaptureConnection *videoConnection = self.videoConnection;
    AVCaptureConnection *videoConnection = [self findVideoConnection];
    
    [videoConnection setVideoScaleAndCropFactor:_scaleNum];
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments) {
            NSLog(@"attachements: %@", exifAttachments);
        } else {
            NSLog(@"no attachments");
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        NSLog(@"originImage:%@", [NSValue valueWithCGSize:image.size]);

        //        [SCCommon saveImageToPhotoAlbum:image];
        
        CGFloat squareLength = Screen_width;
        CGFloat headHeight = _previewLayer.bounds.size.height - squareLength;//_previewLayer的frame是(0, 44, 320, 320 + 44)
        CGSize size = CGSizeMake(squareLength * 2, squareLength * 2);
        
        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
        
        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2 + headHeight, size.width, size.height);
        NSLog(@"cropFrame:%@", [NSValue valueWithCGRect:cropFrame]);
        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
        NSLog(@"croppedImage:%@", [NSValue valueWithCGSize:croppedImage.size]);

        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation != UIDeviceOrientationPortrait) {
            
            CGFloat degree = 0;
            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
                degree = 180;// M_PI;
            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
                degree = -90;// -M_PI_2;
            } else if (orientation == UIDeviceOrientationLandscapeRight) {
                degree = 90;// M_PI_2;
            }
            croppedImage = [croppedImage rotatedByDegrees:degree];
        }
        
        //        self.imageView.image = croppedImage;
        
        //block、delegate、notification 3选1，传值
        if (block) {
            block(croppedImage);
        } else if ([_delegate respondsToSelector:@selector(didCapturePhoto:)]) {
//            [_delegate didCapturePhoto:croppedImage];
        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kCapturedPhotoSuccessfully object:croppedImage];
        }
    }];
}


- (AVCaptureConnection*)findVideoConnection {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    return videoConnection;
}

/**
 *  拉近拉远镜头
 *
 *  @param scale 拉伸倍数
 */
/*
- (void)pinchCameraViewWithScalNum:(CGFloat)scale {
    _scaleNum = scale;
    if (_scaleNum < MIN_PINCH_SCALE_NUM) {
        _scaleNum = MIN_PINCH_SCALE_NUM;
    } else if (_scaleNum > MAX_PINCH_SCALE_NUM) {
        _scaleNum = MAX_PINCH_SCALE_NUM;
    }
    [self doPinch];
    _preScaleNum = scale;
}

- (void)pinchCameraView:(UIPinchGestureRecognizer *)gesture {
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [gesture numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [gesture locationOfTouch:i inView:_preview];
        CGPoint convertedLocation = [_previewLayer convertPoint:location fromLayer:_previewLayer.superlayer];
        if ( ! [_previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        _scaleNum = _preScaleNum * gesture.scale;
        
        if (_scaleNum < MIN_PINCH_SCALE_NUM) {
            _scaleNum = MIN_PINCH_SCALE_NUM;
        } else if (_scaleNum > MAX_PINCH_SCALE_NUM) {
            _scaleNum = MAX_PINCH_SCALE_NUM;
        }
        
        [self doPinch];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded ||
        [gesture state] == UIGestureRecognizerStateCancelled ||
        [gesture state] == UIGestureRecognizerStateFailed) {
        _preScaleNum = _scaleNum;
        SCDLog(@"final scale: %f", _scaleNum);
    }
}

- (void)doPinch {
    //    AVCaptureStillImageOutput* output = (AVCaptureStillImageOutput*)[_session.outputs objectAtIndex:0];
    //    AVCaptureConnection *videoConnection = [output connectionWithMediaType:AVMediaTypeVideo];
    
    AVCaptureConnection *videoConnection = [self findVideoConnection];
    
    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;//videoScaleAndCropFactor这个属性取值范围是1.0-videoMaxScaleAndCropFactor。iOS5+才可以用
    if (_scaleNum > maxScale) {
        _scaleNum = maxScale;
    }
    
    //    videoConnection.videoScaleAndCropFactor = _scaleNum;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [_previewLayer setAffineTransform:CGAffineTransformMakeScale(_scaleNum, _scaleNum)];
    [CATransaction commit];
}
 */

/**
 *  切换闪光灯模式
 *  （切换顺序：最开始是auto，然后是off，最后是on，一直循环）
 *  @param sender: 闪光灯按钮
 */
- (void)switchFlashMode:(UIButton*)sender {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *imgStr = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        //        if (!sender) {//设置默认的闪光灯模式
        //            device.flashMode = AVCaptureFlashModeAuto;
        //        } else {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            imgStr = @"flashing_on.png";
            
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            imgStr = @"flashing_auto.png";
            
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            imgStr = @"flashing_off.png";
            
        }
        //        }
        
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有闪光灯功能" delegate:nil cancelButtonTitle:@"噢T_T" otherButtonTitles: nil];
        [alert show];
    }
    [device unlockForConfiguration];
}

/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint {
    //    if (CGRectContainsPoint(_previewLayer.bounds, devicePoint) == NO) {
    //        return;
    //    }
    
    devicePoint = [self convertToPointOfInterestFromViewCoordinates:devicePoint];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    
    dispatch_async(_sessionQueue, ^{
        AVCaptureDevice *device = [_inputDevice device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
    
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

/**
 *  外部的point转换为camera需要的point(外部point/相机页面的frame)
 *
 *  @param viewCoordinates 外部的point
 *
 *  @return 相对位置的point
 */
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _previewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = self.previewLayer;
    
    if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for(AVCaptureInputPort *port in [[self.captureSession.inputs lastObject]ports]) {
            if([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspect]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                    
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}


@end
