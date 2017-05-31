//
//  BFTextField.m
//  BFTest
//
//  Created by JM on 2017/4/8.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFTextField.h"

@implementation BFTextField
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tintColor = [UIColor whiteColor];  //设置光标颜色
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:21/255.0 green:169/255.0 blue:154/255.0 alpha:1];

    attrs[NSFontAttributeName] = self.font;
    
    //画出占位符
    CGRect placeholderRect;
    placeholderRect.size.width = rect.size.width;
    placeholderRect.size.height = rect.size.height;
    placeholderRect.origin.x = 0;
    placeholderRect.origin.x = rect.size.width - 15 * (self.placeholder.length+0.25);
    placeholderRect.origin.y = (rect.size.height - self.font.lineHeight) * 0.5;
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
  }
@end
