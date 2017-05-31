//
//  CouponController.m
//  BFTest
//
//  Created by 伯符 on 16/12/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "CouponController.h"
#import "YSLContainerViewController.h"
#import "JinMaiCouponController.h"
#import "PrivilegeCouponController.h"
#import "AppointmentCouponController.h"
#import "OutdateCouponController.h"
#import "MyCouponModel.h"
@interface CouponController ()<YSLContainerViewControllerDelegate>{
    JinMaiCouponController *jinmai;
    PrivilegeCouponController *privilege;
    AppointmentCouponController *appointment;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CouponController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    self.title = @"我的卡包";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 65*ScreenRatio, 16*ScreenRatio);
    [btn setContentEdgeInsets:UIEdgeInsetsMake(10*ScreenRatio, 10*ScreenRatio, 6, -20)];
    [btn setTitle:@"已过期" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = BFFontOfSize(14);
    [btn addTarget:self action:@selector(outdateCoupon:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)backItemClick:(UIBarButtonItem *)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)outdateCoupon:(UIButton *)btn{
    OutdateCouponController *outdateCouponvc = [[OutdateCouponController alloc]init];
    [self.navigationController pushViewController:outdateCouponvc animated:YES];
}

- (void)configureUI{
    self.view.backgroundColor = [UIColor whiteColor];
    jinmai = [[JinMaiCouponController alloc]init];
    jinmai.title = @"近脉券";
    
    privilege = [[PrivilegeCouponController alloc]init];
    privilege.title = @"优惠券";
    
    appointment = [[AppointmentCouponController alloc]init];
    appointment.title = @"约会券";
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[jinmai,privilege,appointment]
                                                                                        topBarHeight:NavigationBar_Height - 5
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont boldSystemFontOfSize:17];
    containerVC.view.frame = CGRectMake(0, NavBar_Height, Screen_width, Screen_height - NavBar_Height);
    [self.view addSubview:containerVC.view];
    
    [self containerViewItemIndex:0 currentController:jinmai];
}


#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [controller viewWillAppear:YES];
    if (index == 1) {
        // 优惠券
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobile-app/cards/",BUSINESS_URL];
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        NSString *phoneNum = [BFUserLoginManager shardManager].phone;
        if(phoneNum == nil){
            phoneNum = @"123";
        }
        NSDictionary *para = @{@"platform_uid":manager.jmId,@"platform_user_tel":phoneNum,@"platform_token":JMTOKEN,@"category":@"DISCOUNT",@"_page_item_pos":@0};
        [BFNetRequest getaWithURLString:urlStr parameters:para success:^(id responseObject) {
            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",accessDict);
            if ([accessDict[@"success"] intValue]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *contentDic = accessDict[@"content"];
                NSArray *array = contentDic[@"clist"];
                for (NSDictionary *dic in array) {
                    MyCouponModel *model = [MyCouponModel configureModelWithDic:dic];
                    [self.dataArray addObject:model];
                }
                privilege.dataArray = self.dataArray;
                if (self.dataArray.count == 0) {
                    [privilege.tableView setBackgroundView:[self buidImage:@"nocoupons" title:@"暂无优惠券" up:YES]];
                }else{
                    privilege.tableView.backgroundView = nil;
                }
                [privilege.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }else if (index == 2){
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobile-app/cards/",BUSINESS_URL];
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        NSString *phoneNum = [BFUserLoginManager shardManager].phone;
        if(phoneNum == nil){
            phoneNum = @"123";
        }
        NSDictionary *para = @{@"platform_uid":manager.jmId,@"platform_user_tel":phoneNum,@"platform_token":JMTOKEN,@"category":@"DATING",@"_page_item_pos":@0};
        [BFNetRequest getaWithURLString:urlStr parameters:para success:^(id responseObject) {
            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",accessDict);
            if ([accessDict[@"success"] intValue]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSDictionary *contentDic = accessDict[@"content"];
                NSArray *array = contentDic[@"clist"];
                for (NSDictionary *dic in array) {
                    MyCouponModel *model = [MyCouponModel configureModelWithDic:dic];
                    [self.dataArray addObject:model];
                }
                appointment.dataArray = self.dataArray;
                if (self.dataArray.count == 0) {
                    [appointment.tableView setBackgroundView:[self buidImage:@"nocoupons" title:@"暂无优惠券" up:YES]];
                }else{
                    appointment.tableView.backgroundView = nil;
                }
                [appointment.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        // 近脉券
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobile-app/cards/",BUSINESS_URL];
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        NSString *phoneNum = [BFUserLoginManager shardManager].phone;
        if(phoneNum == nil){
            phoneNum = @"123";
        }
        NSDictionary *para = @{@"platform_uid":manager.jmId,@"platform_user_tel":phoneNum,@"platform_token":JMTOKEN,@"category":@"JM",@"_page_item_pos":@0};
        [BFNetRequest getaWithURLString:urlStr parameters:para success:^(id responseObject) {
            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",accessDict);
            if ([accessDict[@"success"] intValue]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSDictionary *contentDic = accessDict[@"content"];
                NSArray *array = contentDic[@"clist"];
                for (NSDictionary *dic in array) {
                    MyCouponModel *model = [MyCouponModel configureModelWithDic:dic];
                    [self.dataArray addObject:model];
                }
                jinmai.dataArray = self.dataArray;
                if (self.dataArray.count == 0) {
                    [jinmai.tableView setBackgroundView:[self buidImage:@"nocoupons" title:@"暂无优惠券" up:YES]];
                }else{
                    jinmai.tableView.backgroundView = nil;
                }
                [jinmai.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (UIView *)buidImage:(NSString *)imgstr title:(NSString *)tink up:(BOOL)isup{
    UIImage *img = [UIImage imageNamed:imgstr];
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    back.backgroundColor = BFColor(222, 222, 222, 1);
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60*ScreenRatio, 60*ScreenRatio)];
    if (isup) {
        imgview.center = CGPointMake(Screen_width/2, Screen_height/2 - 70*ScreenRatio);
    }else{
        imgview.center = CGPointMake(Screen_width/2, Screen_height/2 + 15*ScreenRatio);
    }
    imgview.image = img;
    imgview.contentMode = UIViewContentModeScaleAspectFill;
    [back addSubview:imgview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 20*ScreenRatio)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = BFFontOfSize(15);
    label.center = CGPointMake(Screen_width/2, CGRectGetMaxY(imgview.frame)+ 25*ScreenRatio);
    label.text = tink;
    [back addSubview:label];
    
    return back;
}

@end
