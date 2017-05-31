//
//  BFHXDetailViewController.m
//  BFTest
//
//  Created by JM on 2017/4/19.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#import "BFHXContactCell.h"
#import "MJRefresh.h"
#import "BFHXDetailViewController.h"
#import "BFUserInfoController.h"
#import "BFOriginNetWorkingTool+userRelations.h"
#import "BFOriginNetWorkingTool+userInfo.m"
#import "NSString+Valid.h"
static NSString *CellIdentifier = @"BFHXContactCell";
static NSString *FindNoneCell = @"findNoneCell";
@interface BFHXDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *label;



@end

@implementation BFHXDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FindNoneCell];
    [self reloadTableViewDataFinishCallBack:nil];
    [self setRefreshHeader];
    [self setupSearchBar];
    [self setupBackTableViewImage];
}


- (void)setupSearchBar{
    self.searchBar.delegate = self;
}
- (void)setupBackTableViewImage{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    
    self.imageView = imageView;
    self.label = label;
    
    UIImage *image = [UIImage imageNamed:@"聊天"];
    imageView.image = image;
    
    NSString *placeHolder = nil;
    NSString *searchBarHolder = nil;
    switch (self.detailVCType) {
        case BFHXDetailVCTypeFans:
            placeHolder = @"亲，你还没有粉丝哦~";
            searchBarHolder = @"请输入要搜索的用户名";
            break;
        case BFHXDetailVCTypeFollow:
            placeHolder = @"亲，你还没有关注的人哦~";
            searchBarHolder = @"请输入要搜索的用户名";
            break;
        case BFHXDetailVCTypeBlackList:
            placeHolder = @"亲，你还没有拉黑的人哦~";
            searchBarHolder = @"请输入要搜索的用户名";
            break;
        case BFHXDetailVCTypeSearchUser:
            placeHolder = @"亲，你可以输入对应账号查找用户哦~";
            searchBarHolder = @"搜索近脉号";
            break;
            
        default:
            break;
    }
    
    self.searchBar.placeholder = searchBarHolder;
    
    label.text = placeHolder;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    
    [self.tableView insertSubview:imageView atIndex:0 ];
    [self.tableView insertSubview:label atIndex:1];
    
    label.hidden = YES;
    imageView.hidden = YES;
    
    imageView.size = CGSizeMake(image.size.width, image.size.height);
    imageView.center = CGPointMake(Screen_width/2, 80);
    
    label.size = CGSizeMake(image.size.width*3, 30);
    
    CGPoint center = CGPointMake(0, 0);
    center = CGPointMake(imageView.centerX,imageView.centerY+image.size.height/2 + 30);
    label.center = center;
    
    
    
}
- (void)showFindNoneCell{
    
    NSString *str = nil;
    if(self.detailVCType == BFHXDetailVCTypeSearchUser){
        str = @"该近脉账号不存在，请检查是否输入有误";
    }else{
        str = @"找不到结果";
    }
    self.dataArray = [NSMutableArray arrayWithObject:str];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataFinishCallBack:(void(^)())callBack{
    
    if(self.detailVCType == BFHXDetailVCTypeFollow){
        [BFOriginNetWorkingTool getFollowWithJmid:[BFUserLoginManager shardManager].jmId completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataArray = [self matchSearchBarDataArrM:[BFHXManager shareManager].followArrM];
                    [self.tableView reloadData];
                    if(self.dataArray.count == 0 && [BFHXManager shareManager].followArrM.count>0){
                        [self showFindNoneCell];
                    }
                    self.title = [NSString stringWithFormat: @"%@(%zd)",self.navTitle,[BFHXManager shareManager].followArrM.count];
                    if(callBack){
                        callBack();
                    }
                });
            }
        }];
    }
    if(self.detailVCType == BFHXDetailVCTypeFans){
        
        [BFOriginNetWorkingTool getFansWithJmid:[BFUserLoginManager shardManager].jmId completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataArray = [self matchSearchBarDataArrM:[BFHXManager shareManager].fansArrM];
                    [self.tableView reloadData];
                    if(self.dataArray.count == 0 && [BFHXManager shareManager].fansArrM.count>0){
                        [self showFindNoneCell];
                    }
                    self.title = [NSString stringWithFormat: @"%@(%zd)",self.navTitle,[BFHXManager shareManager].fansArrM.count];
                    if(callBack){
                        callBack();
                    }
                });
            }
        }];
        
    }
    if(self.detailVCType == BFHXDetailVCTypeBlackList){
        [BFOriginNetWorkingTool getBlackListWithJmid:[BFUserLoginManager shardManager].jmId completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataArray = [self matchSearchBarDataArrM: [BFHXManager shareManager].blackListArrM];
                    [self.tableView reloadData];
                    if(self.dataArray.count == 0 && [BFHXManager shareManager].blackListArrM.count>0){
                        [self showFindNoneCell];
                    }
                    self.title = [NSString stringWithFormat: @"%@(%zd)",self.navTitle,[BFHXManager shareManager].blackListArrM.count];
                    if(callBack){
                        callBack();
                    }
                });
            }
        }];
    }
    if(self.detailVCType == BFHXDetailVCTypeSearchUser){
        [BFOriginNetWorkingTool searchUserByJmid:[BFUserLoginManager shardManager].jmId otherJmid:self.searchBar.text completionHandler:^(NSMutableArray<BFUserInfoModel *> *arrM, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray = arrM;
                [self.tableView reloadData];
                if(self.dataArray.count == 0 && self.searchBar.text.length != 0){
                    [self showFindNoneCell];
                }
                if(callBack){
                    callBack();
                }
            });
        }];
    }
    
}
- (void)setRefreshHeader{
    
    __weak BFHXDetailViewController *weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf reloadTableViewDataFinishCallBack:^{
                [weakSelf.tableView.mj_header endRefreshing];
            }];
        });
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
    self.tableView.mj_header = header;
    
}


- (void)setBackInfoArrM{
    switch (self.detailVCType) {
        case BFHXDetailVCTypeFans:
            self.dataArray = [BFHXManager shareManager].fansArrM;
            
            break;
        case BFHXDetailVCTypeFollow:
            self.dataArray = [BFHXManager shareManager].followArrM;
            break;
        case BFHXDetailVCTypeBlackList:
            self.dataArray = [BFHXManager shareManager].blackListArrM;
            break;
        case BFHXDetailVCTypeSearchUser:
            self.dataArray = nil;
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}
#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        [self setBackInfoArrM];
        return;
    }
    [self reloadTableViewDataFinishCallBack:nil];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@""]||(self.detailVCType != BFHXDetailVCTypeSearchUser)||[text  isEqualToString:@"\n"]){
        return YES;
    }
    if([text isNum] == NO ){
        [self showAlertViewTitle:@"只能输入数字！" message:nil];
    }
    return [text isNum];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataArray.count == 0){
        self.imageView.hidden = NO;
        self.label.hidden = NO;
    }else{
        self.imageView.hidden = YES;
        self.label.hidden = YES;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFUserInfoModel *model = self.dataArray[indexPath.row];
    if(![model isKindOfClass:[BFUserInfoModel class]]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FindNoneCell forIndexPath:indexPath];
        cell.textLabel.text = (NSString *)model;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    
    BFHXContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = model;
    cell.isblackListCell = self.detailVCType == BFHXDetailVCTypeBlackList ? YES : NO;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BFUserInfoModel *model = self.dataArray[indexPath.row];
    BFUserInfoController *vc = [BFUserInfoController creatByJmid:model.jmid];
    vc.hidesBottomBarWhenPushed = YES;
    
    if(self.imVC == nil){
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.imVC.navigationController pushViewController:vc animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
//    [self.tableView reloadData];
}

/**
 添加黑名单列表的删除功能
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.detailVCType == BFHXDetailVCTypeBlackList){
        return YES;
    }else{
        return NO;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    
    
    BFUserInfoModel *model = self.dataArray[indexPath.row];
    [BFOriginNetWorkingTool delBlackListWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:model.jmid completionHandler:^(NSString *code, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(code.integerValue == 200){
                [[BFHXManager shareManager].blackListArrM removeObjectAtIndex:indexPath.row];
                self.dataArray = [BFHXManager shareManager].blackListArrM;
                // 从列表中删除
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        });
    }];
}

- (NSMutableArray *)matchSearchBarDataArrM:(NSArray <BFUserInfoModel*>*)arr{
    if(self.searchBar.text == nil || [self.searchBar.text isEqualToString:@""]){
        return arr.mutableCopy;
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    for(BFUserInfoModel *model in arr){
        if([model.name containsString:self.searchBar.text]){
            [arrM addObject:model];
        }
    }
    return arrM;
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadTableViewDataFinishCallBack:nil];
    
    if(self.detailVCType == BFHXDetailVCTypeBlackList){
        [self.searchBar removeFromSuperview];
        self.searchBar = nil;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
    }

}


@end
