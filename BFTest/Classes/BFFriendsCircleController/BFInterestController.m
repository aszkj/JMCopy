//
//  BFInterestController.m
//  BFTest
//
//  Created by 伯符 on 16/7/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//  关注

#import "BFInterestController.h"
#import "BFInterestCell.h"
#import "BFInterestModel.h"
#import "BFDataGenerator.h"
#import "ODRefreshControl.h"
#import "WMPlayer.h"
#import "BFInterestModelFrame.h"
#import "BFFriMediaClusterController.h"
#import "MJRefresh.h"
#import "BFSearchBar.h"
#import "LLSearchControllerDelegate.h"
#import "BFInterestSearchResultController.h"
#import "BFNavigationController.h"
#import "UserDTViewController.h"
#import "SearchFirstController.h"
#import "UIImage+Addition.h"
#import "BFChatHelper.h"
#import "DTCommentViewController.h"
#import "RelateTopicsController.h"
#import "BFJubaoView.h"
#import "BFDeleteView.h"
static  NSString *CellIdenti = @"interestCell";

@interface BFInterestController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,BFHomeTableViewCellDelegate,WMPlayerDelegate,LLSearchControllerDelegate,DeleteDTDelegate>{
    UITableView *interestList;
    NSIndexPath *cellPath;
    BFInterestCellImageView *imageView;
    WMPlayer *wmPlayer;
    BFSearchBar *searchbar;
    UIView *tableHeaderView;
    NSInteger itemsNum;
    NSIndexPath *selectIndex;
    BFInterestCell *selectCell;
}
@property (nonatomic, assign) BOOL isSmallScreen;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *placeArray;
@property (nonatomic,strong) NSArray *fromPlaceArray;
// 缓存数组
@property (nonatomic,strong) NSMutableArray *cachesArray;

@property (nonatomic,strong) NSDictionary *userDic;
@end

@implementation BFInterestController

- (NSMutableArray *)cachesArray{
    if (!_cachesArray) {
        _cachesArray = [NSMutableArray array];
    }
    return _cachesArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (selectIndex) {
        [interestList reloadRowsAtIndexPaths:@[selectIndex] withRowAnimation:UITableViewRowAnimationNone];
        selectIndex = nil;
    }
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
    self.navigationItem.title = @"发现";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNaviBar];
    
    interestList = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, Screen_height - Tabbar_Height - NavBar_Height) style:UITableViewStylePlain];
    
    interestList.tableFooterView = [[UIView alloc]init];
    interestList.delegate = self;
    interestList.dataSource = self;
    [self.view addSubview:interestList];
    
    [self configureRefreshView];
    
    searchbar = [BFSearchBar defaultSearchBarWithFrame:CGRectMake(0, 0, Screen_width, SEARCH_TEXT_FIELD_HEIGHT + 16)];
    searchbar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    searchbar.delegate = self;
    searchbar.placeholder = @"搜索";
    
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, CGRectGetHeight(searchbar.frame))];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:searchbar];
    
    interestList.tableHeaderView = tableHeaderView;
    [self achieveData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendDTSuccess) name:@"SendDTSuccess" object:nil];
    
}

- (void)sendDTSuccess{
    [self dropViewDidBeginRefreshing];
}

- (void)configureRefreshView{
    __weak BFInterestController *weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf dropViewDidBeginRefreshing];
        [interestList.mj_header beginRefreshing];
    }];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [weakSelf upViewDidBeginRefreshing];
        [interestList.mj_footer beginRefreshing];
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
    interestList.mj_header = header;
    
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    
    [footer setImages:@[img1] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [footer setImages:@[img2] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:@[img1,img2,img3] forState:MJRefreshStateRefreshing];
    interestList.mj_footer = footer;
}

- (void)initNaviBar{
    UIButton *searchItem = [UIButton buttonWithType:UIButtonTypeCustom];
    searchItem.frame = CGRectMake(0, 0, 18, 20);
    [searchItem setBackgroundImage:[UIImage imageNamed:@"dongtaime"] forState:UIControlStateNormal];
    UIBarButtonItem *searchme = [[UIBarButtonItem alloc]initWithCustomView:searchItem];
    [searchItem addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = searchme;
    
    UIButton *cameraItem = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraItem.frame = CGRectMake(0, 0, 23, 20);
    [cameraItem setBackgroundImage:[UIImage imageNamed:@"fadongtai"] forState:UIControlStateNormal];
    UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithCustomView:cameraItem];
    [cameraItem addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = camera;
    
}

#pragma mark  - 个人动态

- (void)searchClick:(UIBarButtonItem *)searchItem{
    UserDTViewController *userdt = [[UserDTViewController alloc]init];
    userdt.userDic = self.userDic;
    userdt.useruid = self.userDic[@"jmid"];
    userdt.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:userdt animated:YES];
}

#pragma mark  - 发布动态

- (void)cameraClick:(UIBarButtonItem *)cameraItem{
    self.tabBarController.tabBar.hidden = YES;
    BFFriMediaClusterController *clustervc = [[BFFriMediaClusterController alloc]init];
    clustervc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:clustervc animated:YES];
    
}

- (void)achieveData{
    
    // 缓存
    /*
    NSMutableArray *array = [BFChatHelper getDataArrayFromDB:@"DTDATA"];
    NSLog(@"%@",array);
    if (array) {
        // 从本地缓存获取
        [self configureDataArray:array];
        return ;
    }
    */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/news/",DongTai_URL];
    NSDictionary *para;
    if (UserwordMsg ) {
        para = @{@"uid":UserwordMsg,@"token":@"",@"page_item_pos":@0,@"action":@"D"};
    }
    NSLog(@"%@",para);
    [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
        NSDictionary *dic = nil;
        if([responseObject isKindOfClass:[NSDictionary class]]){
            dic = responseObject;
        }else{
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        NSLog(@"%@",dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"success"] intValue] && ![dic[@"success"] isKindOfClass:[NSNull class]]) {
            
            NSDictionary *contentDic = dic[@"content"];
            self.userDic = contentDic[@"head"];
            for (NSDictionary *userDic in contentDic[@"fnlist"]) {
                BFInterestModel *interestModel = [BFInterestModel configureModelWithDic:userDic];
                BFInterestModelFrame *modelFrame = [[BFInterestModelFrame alloc]init];
                modelFrame.interestModel = interestModel;
                [self.dataArray addObject:modelFrame];
                [self.cachesArray addObject:userDic];
            }
            
            // 存入缓存
            [BFChatHelper saveToLocalDB:self.cachesArray saveIdenti:@"DTDATA"];
            itemsNum = self.dataArray.count;
            dispatch_async(dispatch_get_main_queue(), ^{
                [interestList reloadData];
            });
        }else{
            NSMutableArray *array = [BFChatHelper getDataArrayFromDB:@"DTDATA"];
            if (array) {
                // 从本地缓存获取
                [self configureDataArray:array];
                return ;
            }
        }
    } failure:^(NSError *error) {
        //
    }];
    // 没有网络情况
    /*
    [BFNetRequest netWorkStatus:^(AFNetworkReachabilityStatus netStatus) {
        if (netStatus == AFNetworkReachabilityStatusUnknown || netStatus == AFNetworkReachabilityStatusNotReachable){
            NSMutableArray *array = [BFChatHelper getDataArrayFromDB:@"DTDATA"];
            if (array) {
                // 从本地缓存获取
                [self configureDataArray:array];
                return ;
            }
        }
    }];
    */
    self.isSmallScreen = YES;
}

- (void)configureDataArray:(NSMutableArray *)array{
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    for (NSDictionary *userDic in array) {
        BFInterestModel *interestModel = [BFInterestModel configureModelWithDic:userDic];
        BFInterestModelFrame *modelFrame = [[BFInterestModelFrame alloc]init];
        modelFrame.interestModel = interestModel;
        [self.dataArray addObject:modelFrame];
    }
    [interestList reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BFInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenti];
    cell.indexPath = indexPath;
    if (!cell) {
        cell = [[BFInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdenti];
        cell.videoDelegate = self;
        cell.guanzhuBtn.hidden = YES;
    }
    
    cell.modelFrame = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BFInterestModelFrame *modelFrame = self.dataArray[indexPath.row];
    NSInteger height = modelFrame.cellHeight;
    return height;
    
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak BFInterestController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [interestList reloadData];
        }
        
        if (isHeader) {
            [interestList.mj_header endRefreshing];
        }
        else{
            [interestList.mj_footer endRefreshing];
        }
    });
}


- (void)dropViewDidBeginRefreshing{
    NSString *url = [NSString stringWithFormat:@"%@/news/",DongTai_URL];

    NSDictionary *para;
    if (UserwordMsg ) {
        para = @{@"uid":UserwordMsg,@"token":@"",@"page_item_pos":@0,@"action":@"D"};
    }
    [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            [self.dataArray removeAllObjects];
            [self.cachesArray removeAllObjects];
            NSDictionary *contentDic = dic[@"content"];
            NSArray *fnlist = contentDic[@"fnlist"];
            for (NSDictionary *userDic in fnlist) {
                BFInterestModel *interestModel = [BFInterestModel configureModelWithDic:userDic];
                
                BFInterestModelFrame *modelFrame = [[BFInterestModelFrame alloc]init];
                modelFrame.interestModel = interestModel;
//                [self.dataArray insertObject:modelFrame atIndex:0];
//                [self.cachesArray insertObject:userDic atIndex:0];
                [self.dataArray addObject:modelFrame];
                [self.cachesArray addObject:userDic];
            }
            if (fnlist.count != 0) {
                [BFChatHelper saveToLocalDB:self.cachesArray saveIdenti:@"DTDATA"];
            }
            itemsNum = self.dataArray.count;
            [interestList reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];


    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

- (void)upViewDidBeginRefreshing{
    NSString *url = [NSString stringWithFormat:@"%@/news/",DongTai_URL];

    NSDictionary *para;
    NSString *num = [NSString stringWithFormat:@"%ld",itemsNum];
    if (UserwordMsg) {
        para = @{@"uid":UserwordMsg,@"token":@"",@"page_item_pos":num,@"action":@"U"};
    }
    NSLog(@"%@",para);
    [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            NSDictionary *contentDic = dic[@"content"];
            for (NSDictionary *userDic in contentDic[@"fnlist"]) {
                BFInterestModel *interestModel = [BFInterestModel configureModelWithDic:userDic];
                BFInterestModelFrame *modelFrame = [[BFInterestModelFrame alloc]init];
                modelFrame.interestModel = interestModel;
                //                [self.dataArray addObject:modelFrame];
                [self.dataArray addObject:modelFrame];
                
            }
            [interestList reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];
    
    
    [self tableViewDidFinishTriggerHeader:NO reload:YES];
}

#pragma mark - BFHomeTableViewCellDelegate

- (void)homeTableViewCell:(BFInterestCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(BFInterestCellImageView *)baseImageView {
    
    cellPath = [interestList indexPathForCell:cell];
    imageView = baseImageView;
    
    wmPlayer = [[WMPlayer alloc]initWithFrame:baseImageView.bounds];
    wmPlayer.delegate = self;
    wmPlayer.closeBtnStyle = CloseBtnStyleClose;
    wmPlayer.URLString = videoUrl;
    [baseImageView addSubview:wmPlayer];
    [wmPlayer play];
}

- (void)moreBtnClick:(UILabel *)label withCell:(BFInterestCell *)cell isHaveMore:(BOOL)more{
    NSIndexPath *index = [interestList indexPathForCell:cell];
    BFInterestModelFrame *modelFrame = self.dataArray[index.row];
    modelFrame.shrinkMore = more;
    modelFrame.haveMoreBtn = YES;
    [interestList reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 点赞

- (void)zanBtnClickWithcell:(BFInterestCell *)cell model:(id)data{
    NSIndexPath *index = [interestList indexPathForCell:cell];
    BFInterestModelFrame *modelFrame = self.dataArray[index.row];
    modelFrame.interestModel = (BFInterestModel *)data;
    [interestList reloadData];
    NSString *nid = cell.cellModel.nid;

    NSString *urlstr = [NSString stringWithFormat:@"%@/news/%@/zan/",DongTai_URL,nid];
    NSDictionary *para;
    if (UserwordMsg ) {
        para = @{@"uid":UserwordMsg,@"token":@""};
    }
    [BFNetRequest postWithURLString:urlstr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 点击评论

- (void)commentBtnClickWithCell:(BFInterestCell *)cell{
    NSString *nid = cell.cellModel.nid;
    DTCommentViewController *commentVC = [[DTCommentViewController alloc]init];
    commentVC.modelFrame = cell.modelFrame;

    commentVC.userDic = self.userDic;
    selectIndex = [interestList indexPathForCell:cell];
    commentVC.ReplyBlock = ^(BFInterestModelFrame *modelframe){
        
        cell.modelFrame = modelframe;

        /*
        NSLog(@"%@ ---- %@",self.dataArray,dic);

        BFInterestModel *interestModel = [BFInterestModel configureModelWithDic:dic];
        BFInterestModelFrame *modelFrame = [[BFInterestModelFrame alloc]init];
        modelFrame.interestModel = interestModel;
        NSMutableArray *arraytemp = self.dataArray;
        NSMutableArray *cachestemp = self.cachesArray;
        NSArray * dataarray = [NSArray arrayWithArray: arraytemp];
        NSArray * cachesarray = [NSArray arrayWithArray: cachestemp];

        for (BFInterestModelFrame *mlframe in dataarray) {
            if ([mlframe.interestModel.nid isEqualToString:interestModel.nid]) {
                NSInteger index = [self.dataArray indexOfObject:mlframe];
//                [self.dataArray replaceObjectAtIndex:index withObject:modelFrame];
//                [self.cachesArray replaceObjectAtIndex:index withObject:dic];
                [arraytemp replaceObjectAtIndex:index withObject:modelFrame];
                [cachestemp replaceObjectAtIndex:index withObject:dic];

            }
        }
        self.dataArray = arraytemp;
        self.cachesArray = cachestemp;
        [BFChatHelper saveToLocalDB:self.cachesArray saveIdenti:@"DTDATA"];
        [interestList reloadData];
         */
    };
    commentVC.nid = nid;
    commentVC.reply_userid = cell.cellModel.uid;
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - 举报
- (void)jubaoBtnClikWithCell:(BFInterestCell *)cell{
    if ([cell.cellModel.jmid isEqualToString:JMUSERID]) {
        BFDeleteView *deleteview = [[BFDeleteView alloc]initViewWithTitle:@"删除"];
        deleteview.delegate = self;
        selectCell = cell;
        [deleteview show];
    }else{
        BFJubaoView *jbview = [[BFJubaoView alloc]init];
        [jbview show];
        jbview.block = ^(NSString *jbmesg){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"举报内容成功" message:jbmesg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //
                    //            [self resignView];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            });
        };
    }

}

- (void)deleteUserDT{
    
    NSDictionary *para;
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/news/",DongTai_URL];

    if (UserwordMsg) {
        para = @{@"uid":UserwordMsg,@"token":@"",@"nid":selectCell.cellModel.nid};
        
    }
    
    [BFNetRequest deleteWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] intValue]) {
            [self showAlertViewTitle:@"删除动态成功" message:nil];
            NSIndexPath *index = [interestList indexPathForCell:selectCell];
            [self.dataArray removeObjectAtIndex:index.row];
            [interestList deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSError *error) {
        //
    }];
}

#pragma mark - 点击话题
- (void)selectTopics:(MLEmojiLabelLinkType)linktype linkstr:(NSString *)linkStr{
    RelateTopicsController *vc = [[RelateTopicsController alloc]init];
    vc.linkStr = linkStr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击用户头像
- (void)selectUserIcon:(NSString *)userid{
    UserDTViewController *vc = [[UserDTViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.useruid = userid;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (wmPlayer.superview) {
        CGRect rectInTableView = [interestList rectForRowAtIndexPath:cellPath];
        CGRect rectInSuperview = [interestList convertRect:rectInTableView toView:[interestList superview]];
        if (rectInSuperview.origin.y < -imageView.frame.size.height || rectInSuperview.origin.y>kScreenHeight-64-49) {//往上拖动
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]&&self.isSmallScreen) {
                self.isSmallScreen = YES;
            } else {
                [self releaseWMPlayer];
            }
        } else {
            if ([imageView.subviews containsObject:wmPlayer]) {
                
            } else {
                [self releaseWMPlayer];
            }
        }
    }
}

#pragma mark - WMPlayerDelegate
- (BOOL)prefersStatusBarHidden {
    if (wmPlayer) {
        if (wmPlayer.isFullscreen) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)toCell {
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = imageView.bounds;
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [imageView addSubview:wmPlayer];
        [imageView bringSubviewToFront:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.isSmallScreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
    
}

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation {
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    } else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth-40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    
    [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(wmPlayer).with.offset(0);
        make.width.mas_equalTo(kScreenHeight);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-kScreenHeight/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(45);
        make.right.equalTo(wmPlayer.topView).with.offset(-45);
        make.center.equalTo(wmPlayer.topView);
        make.top.equalTo(wmPlayer.topView).with.offset(0);
    }];
    
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)));
        make.height.equalTo(@30);
    }];
    
    [wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-37, -(kScreenWidth/2-37)));
    }];
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}

- (void)toSmallScreen {
    // 放widow上
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(kScreenWidth/2,kScreenHeight-49-(kScreenWidth/2)*0.75, kScreenWidth/2, (kScreenWidth/2)*0.75);
        wmPlayer.playerLayer.frame = wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
        
    } completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        wmPlayer.fullScreenBtn.selected = NO;
        self.isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:wmPlayer];
    }];
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn {
    if (wmplayer.isFullscreen) {
        wmplayer.isFullscreen = NO;
        [self toCell];
    } else {
        [self releaseWMPlayer];
    }
    
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    if (fullScreenBtn.isSelected) {//全屏显示
        wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    } else {
        if (self.isSmallScreen) {
            // 放widow上,小屏显示
            [self toSmallScreen];
        } else {
            [self toCell];
        }
    }
}

- (void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
}

- (void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}

- (void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state {
    NSLog(@"wmplayerDidFailedPlay");
}

- (void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state {
    NSLog(@"wmplayerDidReadyToPlay");
}

- (void)wmplayerFinishedPlay:(WMPlayer *)wmplayer {
    [self releaseWMPlayer];
}

- (void)releaseWMPlayer {
    [wmPlayer pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
}


#pragma mark - 搜索 -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    
    SearchFirstController *searchvc = [[SearchFirstController alloc]init];
    searchvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchvc animated:YES];
    
    return NO;
}

- (void)willPresentSearchController:(LLSearchViewController *)searchController {
    
}

- (void)didPresentSearchController:(LLSearchViewController *)searchController {
    interestList.tableHeaderView = nil;
    CGRect frame = tableHeaderView.frame;
    frame.origin.y = -frame.size.height;
    tableHeaderView.frame = frame;
}

- (void)willDismissSearchController:(LLSearchViewController *)searchController {
    
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        searchbar.hidden = YES;
        interestList.tableHeaderView = tableHeaderView;
    } completion:^(BOOL finished) {
        searchbar.hidden = NO;
    }];
    
}

- (void)didDismissSearchController:(LLSearchViewController *)searchController {
    //    _connectionAlertView.alpha = 0;
    //    for (UITableViewCell *cell in self.tableView.visibleCells) {
    //        cell.alpha = 0;
    //    }
    //    [UIView animateWithDuration:0.25 animations:^{
    //        _connectionAlertView.alpha = 1;
    //        for (UITableViewCell *cell in self.tableView.visibleCells) {
    //            cell.alpha = 1;
    //        }
    //    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

@end
