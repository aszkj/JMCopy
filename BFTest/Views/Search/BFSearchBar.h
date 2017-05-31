//
//  BFSearchBar.h
//  BFTest
//
//  Created by 伯符 on 17/2/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEARCH_TEXT_FIELD_HEIGHT 28


@interface BFSearchBar : UISearchBar
+ (NSInteger)defaultSearchBarHeight;

+ (instancetype)defaultSearchBar;

+ (instancetype)defaultSearchBarWithFrame:(CGRect)frame;

- (UITextField *)searchTextField;

- (UIButton *)searchCancelButton;

- (void)resignFirstResponderWithCancelButtonRemainEnabled;

- (void)configCancelButton;


@end
