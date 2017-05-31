//
//  NSString+MD5.h
//  XMNChatExample
//
//  Created by shscce on 15/11/19.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5String;

- (CGFloat)getHeightWithWidth:(CGFloat)width font:(CGFloat)fon;

- (CGFloat)getWidthWithHeight:(CGFloat)height font:(CGFloat)fon;

+ (NSAttributedString *)attStringWithString:(NSString *)string keyWord:(NSString *)keyWord;

- (NSString *)distanceTimeWithBeforeTime:(double)beTime;

@end
