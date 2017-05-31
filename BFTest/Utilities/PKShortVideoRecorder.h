//
//  PKShortVideoWriter.h
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PKShortVideoRecorder;

typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);

@protocol PKShortVideoRecorderDelegate <NSObject>

@required

- (void)recorderDidBeginRecording:(PKShortVideoRecorder *)recorder;
- (void)recorderDidEndRecording:(PKShortVideoRecorder *)recorder;
- (void)recorder:(PKShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(nullable NSString *)outputFilePath error:(nullable NSError *)error;

@end




@class AVCaptureVideoPreviewLayer;

@interface PKShortVideoRecorder : NSObject

//pinch
@property (nonatomic, assign) CGFloat preScaleNum;
@property (nonatomic, assign) CGFloat scaleNum;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, assign) id<PKShortVideoRecorderDelegate> delegate;

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize;

- (void)startRunning;
- (void)stopRunning;

- (void)startRecording;
- (void)stopRecording;

- (void)swapFrontAndBackCameras;

- (void)takePicture:(DidCapturePhotoBlock)block;
- (void)switchCamera:(BOOL)isFrontCamera;
- (void)pinchCameraViewWithScalNum:(CGFloat)scale;
- (void)pinchCameraView:(UIPinchGestureRecognizer*)gesture;
- (void)switchFlashMode:(UIButton*)sender;
- (void)focusInPoint:(CGPoint)devicePoint;
- (void)switchGrid:(BOOL)toShow;



- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

NS_ASSUME_NONNULL_END


