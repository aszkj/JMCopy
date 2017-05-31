//
//  BFInterestSearchResultController.m
//  BFTest
//
//  Created by 伯符 on 17/2/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFInterestSearchResultController.h"
#import "UIImage+Addition.h"
static BFInterestSearchResultController *_instance;

@interface BFInterestSearchResultController ()<UISearchBarDelegate>{
    UIView *statusbar;
}

@property (nonatomic) UIView *searchBackgroundView;

@property (nonatomic) UIView *fromNavigationBarView;

@property (nonatomic) UIView *toNavigationBarView;

@end

@implementation BFInterestSearchResultController{
    UIStatusBarStyle originStatusBarStyle;
    UISearchBar *fromSearchBar;
    CGRect fromSearchBarFrame;
    UIStatusBarStyle targetStatusBarStyle;
    
    UIView *searchResultView;
    BOOL willShowSearchResultController;
    BOOL shouldHideSearchResultWhenNoSearch;
    BOOL navigationBarHidden;
    BOOL shouldAllowSearchBarEditing;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    _searchBackgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _searchBackgroundView.backgroundColor = [UIColor blackColor];
    _searchBackgroundView.alpha = 0;
    [self.view addSubview:_searchBackgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTapHandler:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_searchBackgroundView addGestureRecognizer:tap];
    
    self.toNavigationBarView = [[UIView alloc] init];
    [self.view addSubview:self.toNavigationBarView];
    
    self.searchBar = [BFSearchBar defaultSearchBar];
    self.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor blackColor]];
    self.searchBar.delegate = self;
    [self.toNavigationBarView addSubview:self.searchBar];
    
}

+ (instancetype)sharedInstance {
    if (!_instance) {
        _instance = [[BFInterestSearchResultController alloc] initWithNibName:nil bundle:nil];
    }
    
    return _instance;
}

+ (void)destoryInstance {
    _instance = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    shouldAllowSearchBarEditing = YES;
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    navigationBarHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    statusbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 24)];
    statusbar.backgroundColor = [UIColor blackColor];
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    [win addSubview:statusbar];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:navigationBarHidden animated:YES];
    [statusbar removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    shouldAllowSearchBarEditing = !self.searchBar.isFirstResponder;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

/**
 *  显示搜索界面
 */
- (void)showInViewController:(UIViewController *)controller fromSearchBar:(UISearchBar *)_fromSearchBar {
    if (!controller.navigationController)return;
    
    willShowSearchResultController = YES;
    SAFE_SEND_MESSAGE(self.searchResultController, shouldShowSearchResultControllerBeforePresentation) {
        willShowSearchResultController = [self.searchResultController shouldShowSearchResultControllerBeforePresentation];
    }
    
    shouldHideSearchResultWhenNoSearch = NO;
    SAFE_SEND_MESSAGE(self.searchResultController, shouldHideSearchResultControllerWhenNoSearch) {
        shouldHideSearchResultWhenNoSearch = [self.searchResultController shouldHideSearchResultControllerWhenNoSearch];
    }
    
    fromSearchBar = _fromSearchBar;
    originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    fromSearchBarFrame = [fromSearchBar convertRect:fromSearchBar.bounds toView:[UIApplication sharedApplication].delegate.window];
    self.toNavigationBarView.frame = CGRectMake(0, 0, Screen_width, CGRectGetMaxY(fromSearchBarFrame));
    self.toNavigationBarView.backgroundColor = fromSearchBar.barTintColor;
    
    CGRect frame = fromSearchBar.frame;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetHeight(self.toNavigationBarView.frame) - CGRectGetHeight(fromSearchBar.frame);
    self.searchBar.frame = frame;
    self.searchBar.placeholder = fromSearchBar.placeholder;
    
    self.fromNavigationBarView = [controller.navigationController.navigationBar resizableSnapshotViewFromRect:CGRectMake(0, -20, Screen_width, 64) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.fromNavigationBarView];
    
    searchResultView = nil;
    if (willShowSearchResultController) {
        [self addSearchResultController];
    }
    
    targetStatusBarStyle = controller.preferredStatusBarStyle;
    
    UIViewController *targetController = self.navigationController ? self.navigationController : self;
    targetController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    targetController.modalPresentationCapturesStatusBarAppearance = YES;
    [controller.navigationController presentViewController:targetController animated:NO completion:^{
        [self show];
    }];
    
}

- (void)show {
    
    if ([self.delegate respondsToSelector:@selector(willPresentSearchController:)])
        [self.delegate willPresentSearchController:self];
    
    [self.searchBar becomeFirstResponder];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    void (^animationBlock)();
    SAFE_SEND_MESSAGE(self.searchResultController, animationForPresentation) {
        animationBlock = [self.searchResultController animationForPresentation];
    }
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         CGRect frame = self.fromNavigationBarView.frame;
                         frame.origin.y = -frame.size.height;
                         self.fromNavigationBarView.frame = frame;
                         
                         targetStatusBarStyle = UIStatusBarStyleDefault;
                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:SHOW_ANIMATION_DURATION delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.toNavigationBarView.frame;
                         frame.origin.y = -frame.size.height + 64;
                         self.toNavigationBarView.frame = frame;
                         
                         frame = _searchBar.frame;
                         frame.size.width = Screen_width;
                         _searchBar.frame = frame;
                         
                         if (searchResultView) {
                             frame = searchResultView.frame;
                             frame.origin.y = CGRectGetMaxY(self.toNavigationBarView.frame);
                             searchResultView.frame = frame;
                         }
                         
                         self.searchBackgroundView.alpha = 0.4;
                         
                         if (animationBlock)
                             animationBlock();
                     }
                     completion:^(BOOL finished) {
                         if (!willShowSearchResultController)
                             [self addSearchResultController];
                         if ([self.delegate respondsToSelector:@selector(didPresentSearchController:)])
                             [self.delegate didPresentSearchController:self];
                     }];
}

- (void)hide {
    if ([self.delegate respondsToSelector:@selector(willDismissSearchController:)])
        [self.delegate willDismissSearchController:self];
    self.searchBar.text = nil;
    
    [self dismissKeyboard];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    void (^animationBlock)();
    SAFE_SEND_MESSAGE(self.searchResultController, animationForDismiss) {
        animationBlock = [self.searchResultController animationForDismiss];
    }
    
    UIColor *originViewBackgroundColor = searchResultView.backgroundColor;
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         CGRect frame = self.fromNavigationBarView.frame;
                         frame.origin.y = 0;
                         self.fromNavigationBarView.frame = frame;
                         
                         frame = self.toNavigationBarView.frame;
                         frame.origin.y = 0;
                         self.toNavigationBarView.frame = frame;
                         
                         frame = _searchBar.frame;
                         frame.size.width = CGRectGetWidth(fromSearchBarFrame);
                         _searchBar.frame = frame;
                         
                         self.searchBackgroundView.alpha = 0;
                         
                         if (animationBlock)
                             animationBlock();
                         
                         targetStatusBarStyle = UIStatusBarStyleLightContent;
                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25 animations:^{
                             searchResultView.backgroundColor = [UIColor clearColor];
                             if ([self.delegate respondsToSelector:@selector(didDismissSearchController:)]) {
                                 [self.delegate didDismissSearchController:self];
                             }
                             
                         } completion:^(BOOL finished) {
                             searchResultView.backgroundColor = originViewBackgroundColor;
                             [self removeSearchResultController];
                             
                             [self.navigationController ? self.navigationController : self dismissViewControllerAnimated:NO completion:^(){
                                 [self.fromNavigationBarView removeFromSuperview];
                                 
                             }];
                             
                         }];
                     }];
    
}

- (void)addSearchResultController {
    [self addChildViewController:self.searchResultController];
    CGRect frame = self.view.frame;
    frame.origin.y = CGRectGetMaxY(self.toNavigationBarView.frame);
    frame.size.height -= 64;
    searchResultView = self.searchResultController.view;
    searchResultView.frame = frame;
    [self.view insertSubview:self.searchResultController.view aboveSubview:self.searchBackgroundView];
    [self.searchResultController didMoveToParentViewController:self];
    
    self.searchResultController.view.hidden = shouldHideSearchResultWhenNoSearch;
}

- (void)removeSearchResultController {
    [self.searchResultController willMoveToParentViewController:nil];
    [self.searchResultController.view removeFromSuperview];
    [self.searchResultController removeFromParentViewController];
    self.searchResultController = nil;
    searchResultView = nil;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldAllowSearchBarEditing) {
        return YES;
    }else {
        shouldAllowSearchBarEditing = YES;
        UIButton *searchBtn = [self.searchBar searchCancelButton];
        searchBtn.enabled = YES;
        return NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.searchResultController.view.hidden = shouldHideSearchResultWhenNoSearch;
        [self.searchResultController searchTextDidChange:nil];
    }else {
        self.searchResultController.view.hidden = NO;
        [self.searchResultController searchTextDidChange:searchText];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    SAFE_SEND_MESSAGE(self.searchResultController, searchCancelButtonDidTapped) {
        [self.searchResultController searchCancelButtonDidTapped];
    }
    [self hide];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboard];
    
    NSString *searchText = searchBar.text;
    if (searchText.length == 0) {
        self.searchResultController.view.hidden = shouldHideSearchResultWhenNoSearch;
        [self.searchResultController searchButtonDidTapped:searchText];
    }else {
        self.searchResultController.view.hidden = NO;
        [self.searchResultController searchButtonDidTapped:searchText];
        
    }
}


- (void)cancelTapHandler:(UITapGestureRecognizer *)tap {
    [self hide];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return targetStatusBarStyle;
}

- (void)dismissSearchController {
    [self hide];
}

- (void)dismissKeyboard {
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
        UIButton *searchBtn = [self.searchBar searchCancelButton];
        searchBtn.enabled = YES;
    }
}

- (void)cancelTapped:(UIButton *)btn {
    [self hide];
}
@end
