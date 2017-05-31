//
//  BFVoiceIndicatorView.h
//  BFTest
//
//  Created by JM on 2017/4/27.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFVoiceIndicatorView : UIView

@property (nonatomic,assign) NSInteger powerLevel;

- (instancetype)initWithStateOnImage:(UIImage *)imageOn stateOffImage:(UIImage *)imageOff timeFullCallBack:(void(^)())callback;

- (void)showCancelStateOn:(BOOL)YESOrNO;


@end
