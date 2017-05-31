//
//  UserDTController.m
//  BFTest
//
//  Created by 伯符 on 17/2/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "UserDTController.h"
#import "MJRefresh.h"
#import "BFInterestModel.h"
#import "BFDataGenerator.h"
#import "BFInterestModelFrame.h"
#import "BFInterestCell.h"
#import "WMPlayer.h"
#import "BFChatHelper.h"
#import "DTCommentViewController.h"
#import "BFJubaoView.h"
#import "BFDeleteView.h"
#import "RelateTopicsController.h"
static  NSString *CellIdenti = @"interestCell";

@interface UserDTController ()<UITableViewDelegate,UITableViewDataSource,BFHomeTableViewCellDelegate,WMPlayerDelegate,DeleteDTDelegate>{
    NSIndexPath *cellPath;
    BFInterestCellImageView *imageView;
    WMPlayer *wmPlayer;
    NSIndexPath *selectIndex;
    BFInterestCell *selectCell;
}

@property (nonatomic,strong) NSArray *placeArray;
@property (nonatomic,strong) NSArray *fromPlaceArray;

@end

@implementation UserDTController

- (NSMutableArray *)cachesArray{
    if (!_cachesArray) {
        _cachesArray = [NSMutableArray array];
    }
    return _cachesArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self achieveData];
//    [self dropViewDidBeginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.interestList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - NavBar_Height - 98*ScreenRatio) style:UITableViewStylePlain];
    
    self.interestList.tableFooterView = [[UIView alloc]init];
    self.interestList.delegate = self;
    self.interestList.dataSource = self;
    [self.view addSubview:self.interestList];
    __weak UserDTController *weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf dropViewDidBeginRefreshing];
        [self.interestList.mj_header beginRefreshing];
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
    self.interestList.mj_header = header;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.interestList reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BFInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenti];
    cell.indexPath = indexPath;
    if (!cell) {
        cell = [[BFInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdenti];
        cell.videoDelegate = self;
    }
    cell.modelFrame = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BFInterestModelFrame *modelFrame = _dataArray[indexPath.row];
    NSInteger height = modelFrame.cellHeight;
    return height;
    
}

- (void)dropViewDidBeginRefreshing{
    
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak UserDTController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [self.interestList reloadData];
        }
        
        if (isHeader) {
            [self.interestList.mj_header endRefreshing];
        }
        else{
            [self.interestList.mj_footer endRefreshing];
        }
    });
}

#pragma mark - BFHomeTableViewCellDelegate

- (void)homeTableViewCell:(BFInterestCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(BFInterestCellImageView *)baseImageView {
    
    cellPath = [self.interestList indexPathForCell:cell];
    imageView = baseImageView;
    
    wmPlayer = [[WMPlayer alloc]initWithFrame:baseImageView.bounds];
    wmPlayer.delegate = self;
    wmPlayer.closeBtnStyle = CloseBtnStyleClose;
    wmPlayer.URLString = videoUrl;
    [baseImageView addSubview:wmPlayer];
    [wmPlayer play];
}

- (void)moreBtnClick:(UILabel *)label withCell:(BFInterestCell *)cell isHaveMore:(BOOL)more{
    NSIndexPath *index = [self.interestList indexPathForCell:cell];
    BFInterestModelFrame *modelFrame = _dataArray[index.row];
    modelFrame.shrinkMore = more;
    modelFrame.haveMoreBtn = YES;
    [self.interestList reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)zanBtnClickWithcell:(BFInterestCell *)cell model:(id)data{
    NSIndexPath *index = [self.interestList indexPathForCell:cell];
    BFInterestModelFrame *modelFrame = _dataArray[index.row];
    modelFrame.interestModel = (BFInterestModel *)data;
    //    [interestList reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
    [self.interestList reloadData];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (wmPlayer.superview) {
        CGRect rectInTableView = [self.interestList rectForRowAtIndexPath:cellPath];
        CGRect rectInSuperview = [self.interestList convertRect:rectInTableView toView:[self.interestList superview]];
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


#pragma mark - 点击话题
- (void)selectTopics:(MLEmojiLabelLinkType)linktype linkstr:(NSString *)linkStr{
    RelateTopicsController *vc = [[RelateTopicsController alloc]init];
    vc.linkStr = linkStr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击评论

- (void)commentBtnClickWithCell:(BFInterestCell *)cell{
    NSString *nid = cell.cellModel.nid;
    DTCommentViewController *commentVC = [[DTCommentViewController alloc]init];
    commentVC.modelFrame = cell.modelFrame;
    commentVC.userDic = self.userDic;
    selectIndex = [self.interestList indexPathForCell:cell];
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
             NSIndexPath *index = [self.interestList indexPathForCell:selectCell];
             [self.dataArray removeObjectAtIndex:index.row];
             [self.interestList deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
     } failure:^(NSError *error) {
         //
     }];
}





@end
