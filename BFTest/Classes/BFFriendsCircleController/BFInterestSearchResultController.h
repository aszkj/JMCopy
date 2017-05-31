//
//  BFInterestSearchResultController.h
//  BFTest
//
//  Created by 伯符 on 17/2/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFSearchBar.h"
#import "LLSearchResultDelegate.h"
#import "LLSearchControllerDelegate.h"

#define HIDE_ANIMATION_DURATION 0.3
#define SHOW_ANIMATION_DURATION 0.3

@interface BFInterestSearchResultController : UIViewController
@property (nonatomic,strong) UIViewController<LLSearchResultDelegate>* searchResultController;

@property (nonatomic, weak) id<LLSearchControllerDelegate> delegate;

@property (nonatomic,strong) BFSearchBar *searchBar;

+ (instancetype)sharedInstance;

+ (void)destoryInstance;

- (void)showInViewController:(UIViewController *)controller fromSearchBar:(UISearchBar *)fromSearchBar ;

- (void)dismissSearchController;

- (void)dismissKeyboard;

- (void)hide ;
@end
