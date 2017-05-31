//
//  BFHXContactViewController.m
//  BFTest
//
//  Created by JM on 2017/4/19.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#import "BFHXDetailViewController.h"
#import "BFHXContactCell.h"
#import "BFHXContactListViewController.h"
#import "MJRefresh.h"
#import "BFChatViewController.h"
#import "BFUserInfoController.h"
#import "BFOriginNetWorkingTool+userRelations.h"
#import "BFHXSearchUserViewController.h"

#define jumpToChatVC NO
static NSString *FindNoneCell = @"findNoneCell";
@interface BFHXContactListViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *friendNumLabel;

@end

@implementation BFHXContactListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BFHXContactCell" bundle:nil] forCellReuseIdentifier:@"BFHXContactCell"];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FindNoneCell];
    [self reloadTableViewDataFinishCallBack:nil];
    [self setRefreshHeader];
    [self setupUI];
    [self setupSearchBar];
    [self setupBackTableViewImage];
}


- (void)setupBackTableViewImage{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    
    self.imageView = imageView;
    self.label = label;
    
   UIImage *image = [UIImage imageNamed:@"聊天"];
    imageView.image = image;
    label.text = @"亲，你还没有添加好友哦~";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    
    [self.tableView insertSubview:imageView atIndex:0 ];
    [self.tableView insertSubview:label atIndex:1];
    
    label.hidden = YES;
    imageView.hidden = YES;
    
    imageView.size = CGSizeMake(image.size.width, image.size.height);
    imageView.center = CGPointMake(Screen_width/2, Screen_height/2);
    
    label.size = CGSizeMake(image.size.width*2, 30);
    label.center = CGPointMake(imageView.centerX,imageView.centerY+image.size.height/2 + 30);
    
    
}

- (void)showFindNoneCell{
    
    NSString *str = nil;
           str = @"找不到结果";
    self.dataArray = [NSMutableArray arrayWithObject:str];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataFinishCallBack:(void(^)())callBack{
        [BFOriginNetWorkingTool getFriendWithJmid:[BFUserLoginManager shardManager].jmId completionHandler:^(NSString *code, NSError *error) {
            if(code.intValue == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataArray =  [self matchSearchBarDataArrM:[BFHXManager shareManager].friendsArrM];
                    [self.tableView reloadData];
                     self.friendNumLabel.text = [NSString stringWithFormat:@"(%zd)",[BFHXManager shareManager].friendsArrM.count];
                    if(self.dataArray.count == 0 && [BFHXManager shareManager].friendsArrM.count>0){
                        [self showFindNoneCell];
                    }
                    if(callBack){
                        callBack();
                    }
                });
            }
        }];
}

- (void)setupUI{
    UITapGestureRecognizer *followTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followViewTap)];
    UITapGestureRecognizer *fansTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansViewTap)];
    //    添加手势
    [self.followView addGestureRecognizer:followTap];
    [self.fansView addGestureRecognizer:fansTap];
}


- (void)followViewTap{
    BFHXDetailViewController *vc = [[UIStoryboard storyboardWithName:@"BFIMViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"BFHXDetailViewController"];
    vc.detailVCType = BFHXDetailVCTypeFollow;
    vc.imVC = self.imVC;
    vc.navTitle = @"关注";
    [self.imVC.navigationController pushViewController:vc animated:YES];
}

- (void)fansViewTap{
    BFHXDetailViewController *vc = [[UIStoryboard storyboardWithName:@"BFIMViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"BFHXDetailViewController"];
    vc.detailVCType = BFHXDetailVCTypeFans;
    vc.imVC = self.imVC;
    vc.navTitle = @"粉丝";
    [self.imVC.navigationController pushViewController:vc animated:YES];
}

- (void)setupSearchBar{
    //searchBar此页面功能废除  改为跳转到新的页面 实现方式为在searchBar上添加一个button 事件为跳转
    UIButton *searchBarCoverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.searchBar.width, self.searchBar.height)];
    [self.searchBar addSubview:searchBarCoverBtn];
    [searchBarCoverBtn addTarget:self action:@selector(jumpToSearchUserViewController) forControlEvents:UIControlEventTouchUpInside];
    self.searchBar.delegate = self;
}
- (void)jumpToSearchUserViewController{
    BFHXSearchUserViewController *searchVC = [[BFHXSearchUserViewController alloc]init];
    
#warning 这个地方还需要后台再设置一个接口
//    self.imVC.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
}
#pragma  mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    [self reloadTableViewDataFinishCallBack:nil];
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

#pragma mark - setter

- (void)setRefreshHeader{
    
     self.friendNumLabel.text = [NSString stringWithFormat:@"(%zd)",[BFHXManager shareManager].friendsArrM.count];
    
    __weak BFHXContactListViewController *weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf reloadTableViewDataFinishCallBack:^{
                [weakSelf.tableView.mj_header endRefreshing];
                self.friendNumLabel.text = [NSString stringWithFormat:@"(%zd)",[BFHXManager shareManager].friendsArrM.count];
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
    
    static NSString *CellIdentifier = @"BFHXContactCell";
    BFHXContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BFUserInfoModel *model = self.dataArray[indexPath.row];
    UIViewController *vc = nil;
    
    if(jumpToChatVC){
        BFChatViewController *chatVC = [[BFChatViewController alloc]initWithConversationChatter:model.jmid conversationType:EMConversationTypeChat];
        vc = chatVC;
    }else{
        BFUserInfoController *infoVC = [BFUserInfoController creatByJmid:model.jmid];
        vc = infoVC;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.imVC.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

#pragma mark - public refresh




@end
