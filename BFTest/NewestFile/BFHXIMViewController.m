//
//  BFHXIMViewController.m
//  BFTest
//
//  Created by JM on 2017/4/19.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXIMViewController.h"

@interface BFHXIMViewController ()<UIScrollViewDelegate>

@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,weak)BFSegmentedControl *segmentView;
@property (nonatomic,assign)BOOL isPaning;
@property (nonatomic,assign)CGPoint panOffset;
@property (nonatomic,strong)UIView *containView;

@end

@implementation BFHXIMViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupChildVCs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupSegmentControl];
    [self setupRightNavigationBarButton];
}
- (void)setupChildVCs{
    BFHXContactListViewController *contactListVC = [[UIStoryboard storyboardWithName:@"BFIMViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"BFHXContactListViewController"];
    
    BFHXConversationListViewController *conversationListVC = [[UIStoryboard storyboardWithName:@"BFIMViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"BFHXConversationListViewController"];
    
    UIView *containView = [[UIView alloc]init];
    
    
    self.containView = containView;
    self.conversationListVC = conversationListVC;
    self.contactListVC = contactListVC;

}
- (void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    BFHXContactListViewController *contactListVC = self.contactListVC;
    BFHXConversationListViewController *conversationListVC = self.conversationListVC;
    UIView *containView = self.containView;
    
    
    
    [containView addSubview: conversationListVC.view];
    [containView addSubview:contactListVC.view];
    [self.view addSubview:containView];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.width.mas_equalTo(Screen_width*2);
        make.left.equalTo(self.view.mas_left);
    }];
    
    [conversationListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containView).insets(UIEdgeInsetsMake(20, 0, 0, Screen_width));
    }];
    
    [contactListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(containView).insets(UIEdgeInsetsMake(0, Screen_width, 0, 0));
    }];
    
    
    contactListVC.imVC = self;
    conversationListVC.imVC = self;
    
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
//    [containView addGestureRecognizer:pan];
    
    
}
#pragma mark - 右上导航栏按钮
- (void)setupRightNavigationBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"addUser"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSeachUserVC)];
    self.navigationItem.rightBarButtonItem = item;
    NSLog(@"self.imVC.navigationItem %@",self.navigationItem);
}

- (void)pushSeachUserVC{
    BFHXDetailViewController *vc = [[UIStoryboard storyboardWithName:@"BFIMViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"BFHXDetailViewController"];
    vc.detailVCType = BFHXDetailVCTypeSearchUser;
    vc.title = @"添加好友";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
        
//        拖动手势也有状态
        if(pan.state == UIGestureRecognizerStateBegan){
//            开始拖动
            self.isPaning = YES;
            self.selectedIndex = self.segmentView.selectedIndex;
        }else if(pan.state == UIGestureRecognizerStateChanged){
//            注意:获取偏移量是相对于最原始的点
            CGPoint transP = [pan translationInView:pan.view];
            self.panOffset = CGPointMake(self.panOffset.x + transP.x, 0);
            pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, 0);
            [self.segmentView moveIndexToIndex:!self.selectedIndex animated:YES];
//            复位,让它相对于上一次.
            [pan setTranslation:CGPointZero inView:pan.view];
        }else if(pan.state == UIGestureRecognizerStateEnded){
//            结束拖动
            self.isPaning = NO;
            if(fabs(self.panOffset.x) >= Screen_width/2){
                [self.segmentView setSelectedIndex:!self.selectedIndex animated:YES];
            }else{
                [self.segmentView setSelectedIndex: self.selectedIndex animated:YES];
            }
        }
    
}

- (void)setupSegmentControl{
    BFSegmentedControl *segmentedControl = [[BFSegmentedControl alloc] initWithSectionTitles:@[@"聊天", @"通讯录"]];
    self.segmentView = segmentedControl;
    
    [segmentedControl setFrame:CGRectMake(0, 0, 150, 32)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTag:1];
    [segmentedControl setSelectedIndex:1 animated:YES];
    [self segmentedControlChangedValue:segmentedControl];
    self.navigationItem.titleView = segmentedControl;
    
}
- (void)segmentedControlChangedValue:(BFSegmentedControl *)segmentedControl {
    self.selectedIndex = segmentedControl.selectedIndex;
    [self.contactListVC reloadTableViewDataFinishCallBack:nil];
    if(self.isPaning == YES){
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        switch (segmentedControl.selectedIndex) {
            case 0:
            {
                // 会话列表
                [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.mas_left).offset(0);
                }];
                break;
            }
            case 1:
            {
                //通讯录
                [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(self.view.mas_left).offset(-Screen_width);
                }];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
        self.tabBarController.tabBar.hidden = NO;
    [self.contactListVC reloadTableViewDataFinishCallBack:nil];
}




@end
