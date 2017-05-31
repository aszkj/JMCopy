//
//  BFUserInfoController.m
//  BFTest
//
//  Created by JM on 2017/4/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//


#import "BFUserInfoController.h"
#import "BFOriginNetWorkingTool+userInfo.h"
#import "BFOriginNetWorkingTool+userRelations.h"
#import "BFUserEditerViewController.h"
#import "BFUserBottomBarView.h"
#import "BFUserOthersSettingVC.h"
#import "BFChatViewController.h"

#define bottomViewHeight 44
@interface BFUserInfoController ()

@property (nonatomic,copy)NSString *jmid;
@property (nonatomic,readonly,assign)BOOL oneself;
@property (nonatomic,weak) id nextViewController;
@property (nonatomic,weak) BFUserInfoModel *model;
@property (nonatomic,strong) BFUserBottomBarView *bottomView;
@property (nonatomic,strong) BFUserOthersSettingModel *jumpToMoreVCModel;

@end

@implementation BFUserInfoController

+(instancetype)creatByJmid:(NSString *)jmid{
    return [[self alloc]initWithJmid:jmid];
}
- (instancetype)initWithJmid:(NSString *)jmid{
    if(self = [super init]){
        _jmid = jmid;
        [self loadUserInfoByjmid:jmid];
    }
    return self;
}

- (void)loadUserInfoByjmid:(NSString *)jmid{
    
    [BFOriginNetWorkingTool getUserInfoByJmid:[BFUserLoginManager shardManager].jmId otherJmid:jmid completionHandler:^(BFUserInfoModel *model, NSError *error) {
        
        if(model){
            [self refreshByModel:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.bottomView == nil){
                    [self setupBottomView];
                }
            });
            
        }else{
            NSLog(@"返回用户信息模型错误！");
            [self refreshByModel:[[BFUserInfoModel alloc]init]];
        }
    }];
    
}

- (void)refreshByModel:(BFUserInfoModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        BFUserInfoView *userView = (BFUserInfoView *)self.view;
        userView.model = model;
        self.model = model;
        
        if(self.nextViewController){
            [self.nextViewController setValue:userView.model forKey:@"model"];
        }
    });
    
}
- (void)loadView{
    self.view = [[NSBundle mainBundle]loadNibNamed:@"BFUserInfoView" owner:self options:nil].lastObject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupBottomView{
    //如果是自己 不加载底部bar
    if([self.model.jmid isEqualToString:[BFUserLoginManager shardManager].jmId]){
        return;
    }
  
    
    [BFOriginNetWorkingTool getuserRelationsModelWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:self.model.jmid completionHandler:^(BFUserOthersSettingModel *model, NSError *error) {
        self.jumpToMoreVCModel = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            BFUserBottomBarView *view = [[UINib nibWithNibName:@"BFUserBottomBar" bundle:nil]instantiateWithOwner:nil options:nil].lastObject;
            if(model.follow.intValue == 1){
                view.showFollowButton = NO;
            }else{
                view.showFollowButton = YES;
            }
            view.frame = CGRectMake(0, Screen_height, Screen_width, bottomViewHeight);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    view.frame = CGRectMake(0, Screen_height-bottomViewHeight, Screen_width, bottomViewHeight);
                }];
            });
            view.centerX = self.navigationController.navigationBar.centerX;
            
            if(self.bottomView != nil){
                [self.bottomView removeFromSuperview];
            }
            [self.navigationController.view addSubview:view];
            
            [view.chatButtonAction addTarget:self action:@selector(jumpToChat) forControlEvents:UIControlEventTouchUpInside];
            [view.followButtonAction addTarget:self action:@selector(makeToBeFollow) forControlEvents:UIControlEventTouchUpInside];
            self.bottomView = view;
        });
    }];
}


- (void)jumpToChat{
    NSString *jmid = self.model.jmid;
    BFChatViewController *chatController = [[BFChatViewController alloc]initWithConversationChatter:jmid conversationType:EMConversationTypeChat];
    NSString *name = self.model.name;
    chatController.title = name.length > 0 ? name : jmid;
    chatController.avatarURLPath = self.model.photo;
    chatController.nikename = name;
    chatController.jmid = jmid;
    chatController.hidesBottomBarWhenPushed = YES;
    UIViewController *mainVC = [BFHXDelegateManager shareDelegateManager].mainVC;
    [mainVC.navigationController pushViewController:chatController animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [mainVC.tabBarController setSelectedIndex:0];
    }];
    
    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
    

}
- (void)makeToBeFollow{
    
    AsMyShipType type = self.jumpToMoreVCModel.isMyFans.intValue == 1 ? AsMyShipTypeFans : AsMyShipTypeStranger;
    [BFHXManager addFollowToOtherJmid:self.model.jmid asMyship: type callBack:^(NSString *code) {
        
        if(code.intValue == 200){
        NSLog(@"添加关注成功！");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bottomView removeFromSuperview];
                self.bottomView = nil;
                [self setupBottomView];
            });
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    BFUserInfoView *view = (BFUserInfoView *)self.view;
    view.progressBackImageView.layer.cornerRadius = view.progressBackImageView.size.width/2;
    view.progressBackImageView_02.layer.cornerRadius = view.progressBackImageView_02.size.width/2;    
}
- (void)viewWillAppear:(BOOL)animated{
    [self loadUserInfoByjmid:self.jmid];
    if(self.bottomView == nil && self.model != nil){
        [self setupBottomView];
    }
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
}
- (void)setupUI{
    [self setupStatusbar];
    [self setupRightNavgationbarItem];
}

- (void)setupRightNavgationbarItem{
    
    UIImage *image = [self isOneself]?[UIImage imageNamed:@"topic"]:[UIImage imageNamed:@"detailpoint"];
    UIBarButtonItem *item = nil;
    item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action: @selector(jumpToVc)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)jumpToVc{
    
    UIStoryboard *storyBoard = nil;
    
    storyBoard = [self isOneself] ? [UIStoryboard storyboardWithName:@"BFUserEditerViewController" bundle:nil] :[UIStoryboard storyboardWithName:@"BFUserOthersSetting" bundle:nil];
    UIViewController *vc = [storyBoard instantiateInitialViewController];
    self.nextViewController = vc;
    
    
    //如果model已经加载好
    if(self.model){
        [vc setValue:self.model forKey:@"model"];
    }
    if([vc isKindOfClass:[BFUserOthersSettingVC class]]){
        
        [vc setValue:self.jumpToMoreVCModel forKey:@"settingModel"];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setupStatusbar{
    //设置状态栏显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

/**
 判断当前用户是不是自己
 */
-(BOOL)isOneself{
    if ([self.jmid isEqualToString:[BFUserLoginManager shardManager].jmId]){
        return YES;
    }else{
        return NO;
    }
}

@end
