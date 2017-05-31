//
//  UIViewController+BFViewController.h
//  BFTest
//
//  Created by 伯符 on 16/5/11.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BFViewController)

- (void)buildNavigationBar;

- (void)hideTabbar:(BOOL)isHide;

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg;

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg  duration:(NSTimeInterval)duration;
- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg  duration:(NSTimeInterval)duration finishCallBack:(void(^)())finishCallBack;

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg sureAction:(void(^)())sureActionHandler cancelAction:(void(^)())cancelActionHandler;

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg sureAction:(void(^)())sureActionHandler;

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg cancelbutton:(NSString *)str otherbutton:(NSString *)otherstr;


- (NSString *)transformData:(id)data;

+ (void)showUpLabelText:(NSString *)mesg;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (BOOL)openMicroph;

- (BOOL)canRecord;

@end
