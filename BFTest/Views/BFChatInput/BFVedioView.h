//
//  BFVedioView.h
//  BFTest
//
//  Created by 伯符 on 16/7/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFRecordDelegate <NSObject>

@optional
- (void)recordStartedVoiceAction:(UIView *)recordView;

- (void)didCancelRecordingVoiceAction:(UIView *)recordView;

- (void)didFinishRecoingVoiceAction:(UIView *)recordView;
@end

@interface BFVedioView : UIView

@property (nonatomic,assign) id<BFRecordDelegate> delegate;

@end
