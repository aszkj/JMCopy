//
//  BFSearchBar.m
//  BFTest
//
//  Created by 伯符 on 17/2/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFSearchBar.h"
#define BAR_TINT_COLOR [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
#define kLLTextColor_green [UIColor colorWithRed:29/255.0 green:185/255.0 blue:14/255.0 alpha:1]

//#define BAR_TINT_COLOR [UIColor colorWithRed:236/255.0 green:234/255.0 blue:242/255.0 alpha:1]

@implementation BFSearchBar

+ (void)initialize {
    if (self == [BFSearchBar class]) {
        [[UIBarButtonItem appearanceWhenContainedIn: [BFSearchBar class], nil] setTintColor:kLLTextColor_green];
        [[UIBarButtonItem appearanceWhenContainedIn: [BFSearchBar class], nil] setTitle:@"取消"];
    }
    
}

+ (instancetype)defaultSearchBar {
    return [self defaultSearchBarWithFrame:CGRectMake(0, 64, Screen_width, [self defaultSearchBarHeight])];
}

+ (instancetype)defaultSearchBarWithFrame:(CGRect)frame {
    BFSearchBar *searchBar = [[BFSearchBar alloc] initWithFrame:frame];
    searchBar.placeholder = @"搜索";
    searchBar.showsCancelButton = NO;
    searchBar.barStyle = UISearchBarStyleMinimal;
    searchBar.backgroundColor = BAR_TINT_COLOR;
    
    searchBar.barTintColor = BAR_TINT_COLOR;

    searchBar.tintColor = kLLTextColor_green;
    
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.enablesReturnKeyAutomatically = YES;
    
    UITextField *searchTextField = [searchBar searchTextField];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.textColor = [UIColor blackColor];
    
    return searchBar;
}

+ (NSInteger)defaultSearchBarHeight {
    return SEARCH_TEXT_FIELD_HEIGHT + 16;
}

- (UITextField *)searchTextField {
    UITextField *searchTextField = nil;
    for (UIView* subview in self.subviews[0].subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            searchTextField = (UITextField*)subview;
            break;
        }
    }
    NSAssert(searchTextField, @"UISearchBar结构改变");
    
    return searchTextField;
}

- (UIButton *)searchCancelButton {
    UIButton *btn;
    
    NSArray<UIView *> *subviews = self.subviews[0].subviews;
    for(UIView *view in subviews) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            btn = (UIButton *)view;
            break;
        }
    }
    
    return btn;
}

- (void)resignFirstResponderWithCancelButtonRemainEnabled {
    [self resignFirstResponder];
    
    UIButton *cancelButton = [self searchCancelButton];
    [cancelButton setEnabled:YES];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated {
    [super setShowsCancelButton:showsCancelButton animated:animated];
    
    [self configCancelButton];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton {
    [self setShowsCancelButton:showsCancelButton animated:NO];
}

- (void)configCancelButton {
    UIButton *cancelButton = [self searchCancelButton];
    if (cancelButton) {
        UIColor *color = [cancelButton titleColorForState:UIControlStateNormal];
        [cancelButton setTitleColor:color forState:UIControlStateDisabled];
    }
}


@end
