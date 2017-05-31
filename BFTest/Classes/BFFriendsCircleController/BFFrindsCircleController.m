//
//  BFFrindsCircleController.m
//  BFTest
//
//  Created by 伯符 on 16/6/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFFrindsCircleController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YSLScrollMenuView.h"

#import "BFInterestController.h"
#import "YSLContainerViewController.h"

#import "BFDiscoverBottomView.h"
#import "BFFriMediaClusterController.h"
#import "BFSearchUserController.h"
#import "BFSearchTopicController.h"
#import "BFSearchLocationController.h"
@interface BFFrindsCircleController ()<UIWebViewDelegate,YSLContainerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BFDiscoverBottomViewDelegate>{
    YSLScrollMenuView *menuView;
    BFSearchUserController *userVC;
    BFSearchTopicController *topicVC;
    BFSearchLocationController *locationVC;
    NSInteger indexNum;
}

@property (nonatomic,strong)NSArray *titles;

@property (nonatomic) BFSearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic,strong)BFDiscoverBottomView *bottomView;
@end

@implementation BFFrindsCircleController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (BFDiscoverBottomView *)bottomView{
    if (!_bottomView) {
        
        _bottomView = [[BFDiscoverBottomView alloc]initWithFrame:CGRectMake(0, Screen_height, Screen_width, 120*ScreenRatio)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureUI];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self.bottomView];

}


#pragma mark - 跳转个人动态
- (void)searchClick:(UIBarButtonItem *)searchItem{
    
    
}

- (void)cameraClick:(UIBarButtonItem *)cameraItem{
    self.tabBarController.tabBar.hidden = YES;
    [self.bottomView show];
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [self showAlertViewTitle:nil message:@"未检测到摄像头"];
//        return ;
//    }
//    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    picker.delegate = self;
//    picker.videoMaximumDuration = 300.f;
//    picker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
//    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:nil];

}

- (void)configureUI{

    userVC = [[BFSearchUserController alloc]init];
    userVC.searchViewController = self.searchViewController;
    userVC.title = @"用户";
    
    topicVC = [[BFSearchTopicController alloc]init];
    topicVC.searchViewController = self.searchViewController;
    topicVC.title = @"话题";

    locationVC = [[BFSearchLocationController alloc]init];
    locationVC.searchViewController = self.searchViewController;
    locationVC.title = @"地点";
    
    // ContainerView
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[userVC,topicVC,locationVC]
                                                                                        topBarHeight:NavigationBar_Height - 5
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
    
    [self.view addSubview:containerVC.view];
    [self containerViewItemIndex:0 currentController:userVC];

}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    // 放在这里请求数据
    indexNum = index;
    [controller viewWillAppear:YES];
    [self achieveDataWithIndex:index];
}

- (void)achieveDataWithIndex:(NSInteger)index{
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/",DongTai_URL];
    NSDictionary *para;
    NSString *type;
    
    if (index == 0) {
        type = @"U";
    }else if (index == 1){
        type = @"T";
    }else{
        type = @"L";
    }
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"type":type,@"parm":@""};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            if ([dic[@"content"] isKindOfClass:[NSArray class]]) {
                NSArray *content = dic[@"content"];
                if (content.count > 0) {
                    if (self.dataArray.count > 0) {
                        [self.dataArray removeAllObjects];
                    }
                    for (NSDictionary *picDic in content) {
                        [self.dataArray addObject:picDic];
                    }
                    if (index == 1) {
                        topicVC.data = [self.dataArray mutableCopy];
                        topicVC.canEnter = YES;
                    }else if (index == 0){
                        userVC.data = [self.dataArray mutableCopy];
                        
                    }else{
                        locationVC.data = [self.dataArray mutableCopy];
                    }
                }

            }
            
        }
    } failure:^(NSError *error) {
        //
    }];
}

- (void)discoverViewClick:(UIButton *)btn{
    
    if (btn.tag == DiscoverButtonTypeDynamic) {
        NSLog(@"DiscoverButtonTypeDynamic");
        BFFriMediaClusterController *clustervc = [[BFFriMediaClusterController alloc]init];
        clustervc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:clustervc animated:YES];
        [self.bottomView resign];
    }else if (btn.tag == DiscoverButtonTypeLive){
        NSLog(@"DiscoverButtonTypeLive");

    }else{
        self.tabBarController.tabBar.hidden = NO;
        [self.bottomView resign];
    }
}

- (void)searchWithText:(NSString *)searchText {
    if (![self.searchBar.placeholder isEqualToString:@"搜索"]) {
        return;
    }
    NSString *type;
    
    if (indexNum == 0) {
        type = @"U";
    }else if (indexNum == 1){
        type = @"T";
    }else{
        type = @"L";
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/",DongTai_URL];
    NSDictionary *para;
    if (!searchText) {
        searchText = @"";
    }
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"type":type,@"parm":searchText};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            NSArray *content = dic[@"content"];
            if (content.count > 0) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *picDic in content) {
                    [self.dataArray addObject:picDic];
                }
                
                if (indexNum == 1) {
                    topicVC.data = [self.dataArray mutableCopy];
                    topicVC.canEnter = YES;
                }else if (indexNum == 0){
                    userVC.data = [self.dataArray mutableCopy];
                    
                }else{
                    locationVC.data = [self.dataArray mutableCopy];
                }
            
            }
            
        }
    } failure:^(NSError *error) {
        //
    }];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //    _searchResultView.frame = self.view.bounds;
    //    _chatHistoryTableView.frame = _searchResultView.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _searchBar = self.searchViewController.searchBar;
}

//- (void)tapHandler:(UITapGestureRecognizer *)tap {
//    //    if (self.searchResultView.hidden)
//    [self.searchViewController dismissKeyboard];
//}


- (void)searchTextDidChange:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (void)searchButtonDidTapped:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (BOOL)shouldShowSearchResultControllerBeforePresentation {
    return YES;
}

- (BOOL)shouldHideSearchResultControllerWhenNoSearch {
    return NO;
}


@end
