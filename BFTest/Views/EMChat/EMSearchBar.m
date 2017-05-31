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

#import "EMSearchBar.h"

@implementation EMSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barTintColor = BFColor(238, 238, 238, 1);
        self.backgroundImage = [UIImage new];
        self.backgroundColor = BFColor(238, 238, 238, 1);
        UIView *searchTextField = nil;
        if (IOS_VERSION >= 7.0) {
            searchTextField = [[[self.subviews firstObject] subviews] lastObject];
        }else{// iOS6以下版本searchBar内部子视图的结构不一样
            for(UIView *subview in self.subviews)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [subview removeFromSuperview];
                }
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    searchTextField = subview;
                }
            }
        }
//        [textField setBorderStyle:UITextBorderStyleNone];
//        textField.background = nil;
        searchTextField.frame = CGRectMake(8, 8, self.bounds.size.width - 2* 8,
                                     self.bounds.size.height - 2* 8);
        searchTextField.layer.cornerRadius = 6;
        searchTextField.layer.borderColor = [UIColor blackColor].CGColor;
        searchTextField.layer.borderWidth = 0.5f;
        
        searchTextField.clipsToBounds = YES;
        searchTextField.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
- (void)setCancelButtonTitle:(NSString *)title
{
    for (UIView *searchbuttons in self.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            [cancelButton setTitle:title forState:UIControlStateNormal];
            break;
        }
    }
}

@end
