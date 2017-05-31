//
//  UserDTDetailController.m
//  BFTest
//
//  Created by 伯符 on 17/3/6.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "UserDTDetailController.h"
#import "WMPlayer.h"
#import "BFInterestCell.h"
#import "DTCommentViewController.h"
#import "BFJubaoView.h"
#import "UserDTViewController.h"
#import "BFDeleteView.h"
#import "RelateTopicsController.h"
static  NSString *CellIdenti = @"detailCell";

@interface UserDTDetailController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,BFHomeTableViewCellDelegate,WMPlayerDelegate,DeleteDTDelegate,BFHomeTableViewCellDelegate>{
    UITableView *interestList;
    WMPlayer *wmPlayer;
    NSIndexPath *selectIndex;
    NSIndexPath *cellPath;
    BFInterestCellImageView *imageView;
    NSString *uid;
    BFInterestCell *selectCell;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isSmallScreen;
@property (nonatomic,strong) NSDictionary *userDic;

@end

@implementation UserDTDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (selectIndex) {
        [interestList reloadRowsAtIndexPaths:@[selectIndex] withRowAnimation:UITableViewRowAnimationNone];
        selectIndex = nil;
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    _nid = _dic[@"nid"];
    [self achieveData];
}

- (void)setNid:(NSString *)nid{
    _nid = nid;
    [self achieveData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"动态详情";

}

- (void)configureUI{
    
    interestList = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, Screen_height - NavBar_Height) style:UITableViewStylePlain];
    
    interestList.tableFooterView = [[UIView alloc]init];
    interestList.delegate = self;
    interestList.dataSource = self;
    [self.view addSubview:interestList];
    [interestList reloadData];
}

- (void)achieveData{
    NSString *url = [NSString stringWithFormat:@"%@/user/news/%@/",DongTai_URL,_nid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN};
    }
    
    [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            
            NSDictionary *contentDic = dic[@"content"];
            if (contentDic) {
                BFInterestModel *interestModel = [BFInterestModel configureModelWithDic:contentDic];
                BFInterestModelFrame *modelFrame = [[BFInterestModelFrame alloc]init];
                modelFrame.interestModel = interestModel;
                [self.dataArray addObject:modelFrame];
            }
            
            [self configureUI];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN};
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

- (void)selectUserIcon:(NSString *)userid{
    UserDTViewController *vc = [[UserDTViewController alloc]init];
    vc.useruid = userid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 举报
- (void)jubaoBtnClikWithCell:(BFInterestCell *)cell{
    NSString *jmid = cell.cellModel.jmid;
    if (![jmid isEqualToString:JMUSERID]) {
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
    }else{
        BFDeleteView *deleteview = [[BFDeleteView alloc]initViewWithTitle:@"删除"];
        deleteview.delegate = self;
        selectCell = cell;
        [deleteview show];
    }
    
}


//#pragma mark - 点击话题
//- (void)selectTopics:(MLEmojiLabelLinkType)linktype linkstr:(NSString *)linkStr{
//    RelateTopicsController *vc = [[RelateTopicsController alloc]init];
//    vc.linkStr = linkStr;
//    [self.navigationController pushViewController:vc animated:YES];
//}

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

- (void)deleteUserDT{
    NSDictionary *para;
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/news/",DongTai_URL];
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"nid":selectCell.cellModel.nid};
        
    }
    
    [BFNetRequest deleteWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] intValue]) {
            NSIndexPath *index = [interestList indexPathForCell:selectCell];
            [self.dataArray removeObjectAtIndex:index.row];
            [interestList deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSError *error) {
        //
    }];
}


@end
