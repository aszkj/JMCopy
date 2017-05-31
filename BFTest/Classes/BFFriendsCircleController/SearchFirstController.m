//
//  SearchFirstController.m
//  BFTest
//
//  Created by 伯符 on 17/2/13.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "SearchFirstController.h"
#import "BFDataGenerator.h"
#import "BFHotCollectionViewCell.h"
#import "BFSearchBar.h"
#import "BFInterestSearchResultController.h"
#import "BFNavigationController.h"
#import "MJRefresh.h"
#import "BFFrindsCircleController.h"
#import "UIImage+Addition.h"
#import "BFTopicsSearchController.h"
#import "UserDTDetailController.h"
@interface SearchFirstController ()<UICollectionViewDelegate,UICollectionViewDataSource,LLSearchControllerDelegate>{
    BFSearchBar *searchbar;
    UICollectionView *collectView;
    UICollectionReusableView *collectionHeader;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SearchFirstController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"搜索";
    [self achieveData];
}

- (void)achieveData{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/",DongTai_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"type":@"",@"parm":@""};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            NSArray *content = dic[@"content"];
            if (content.count > 0) {
                for (NSDictionary *picDic in content) {
                    [self.dataArray addObject:picDic];
                }
                if (!collectView) {
                    [self addCollectionView];
                }else{
                    [collectView reloadData];
                }
            }

        }
    } failure:^(NSError *error) {
        //
    }];

}

- (void)addCollectionView{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewFlowLayout.minimumLineSpacing = 1.0f;
    collectionViewFlowLayout.minimumInteritemSpacing = 1.0f;
    collectionViewFlowLayout.itemSize = CGSizeMake((Screen_width - 2)/3, (Screen_width - 2)/3);
    
    collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, Screen_height - NavBar_Height) collectionViewLayout:collectionViewFlowLayout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.bounces = YES;
    collectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [collectView registerClass:[BFHotCollectionViewCell class] forCellWithReuseIdentifier:@"HotCell"];
    [collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];

    [self.view addSubview:collectView];
    
    __weak SearchFirstController *weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf dropViewDidBeginRefreshing];
        [collectView.mj_header beginRefreshing];
    }];
    // 设置普通状态的动画图片 (idleImages 是图片)
    UIImage *img1 = [UIImage imageNamed:@"runone"];
    UIImage *img2 = [UIImage imageNamed:@"runtwo"];
    UIImage *img3 = [UIImage imageNamed:@"runthree"];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    [header setImages:@[img1] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:@[img2] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:@[img1,img2,img3] forState:MJRefreshStateRefreshing];
    // 设置header
    collectView.mj_header = header;
}

- (void)dropViewDidBeginRefreshing{
    
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [collectView reloadData];
        }
        
        if (isHeader) {
            [collectView.mj_header endRefreshing];
        }
        else{
            [collectView.mj_footer endRefreshing];
        }
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BFHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.item];
    if (dic) {
        cell.dic = dic;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.item];
    UserDTDetailController *vc = [[UserDTDetailController alloc]init];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        collectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        
        searchbar = [BFSearchBar defaultSearchBarWithFrame:CGRectMake(0, 0, Screen_width, SEARCH_TEXT_FIELD_HEIGHT + 16)];
        searchbar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];

        searchbar.delegate = self;
        searchbar.placeholder = @"搜索";

        [collectionHeader addSubview:searchbar];
        
        return collectionHeader;
    }else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_width, SEARCH_TEXT_FIELD_HEIGHT + 16);
}

#pragma mark - 搜索 -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    BFInterestSearchResultController *vc = [BFInterestSearchResultController sharedInstance];
    BFNavigationController *navigationVC = [[BFNavigationController alloc] initWithRootViewController:vc];
    navigationVC.view.backgroundColor = [UIColor clearColor];
    vc.delegate = self;
     //    LLChatSearchController *resultController = [[LLUtils mainStoryboard] instantiateViewControllerWithIdentifier:SB_CONVERSATION_SEARCH_VC_ID];
    
//    BFTopicsSearchController *resultController = [[BFTopicsSearchController alloc]init];
//    resultController.canEnter = YES;
//    vc.searchResultController = resultController;
//    resultController.searchViewController = vc;
//    [vc showInViewController:self fromSearchBar:searchbar];

    BFFrindsCircleController *resultController = [[BFFrindsCircleController alloc]init];
//    resultController.canEnter = YES;
    vc.searchResultController = resultController;
    resultController.searchViewController = vc;
    [vc showInViewController:self fromSearchBar:searchbar];
    
    
    return NO;
}

- (void)willPresentSearchController:(LLSearchViewController *)searchController {
    
}

- (void)didPresentSearchController:(LLSearchViewController *)searchController {
//    interestList.tableHeaderView = nil;
    collectionHeader = nil;
    CGRect frame = collectionHeader.frame;
    frame.origin.y = -frame.size.height;
    collectionHeader.frame = frame;
}

- (void)willDismissSearchController:(LLSearchViewController *)searchController {
    
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        searchbar.hidden = YES;
//        interestList.tableHeaderView = tableHeaderView;
        
    } completion:^(BOOL finished) {
        searchbar.hidden = NO;
    }];
    
}

- (void)didDismissSearchController:(LLSearchViewController *)searchController {

}

@end
