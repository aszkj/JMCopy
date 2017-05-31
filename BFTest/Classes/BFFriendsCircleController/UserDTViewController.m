//
//  UserDTViewController.m
//  BFTest
//
//  Created by 伯符 on 17/2/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "UserDTViewController.h"
#import "AKASegmentedControl.h"
#import "UserDTController.h"
#import "UserDTPictureController.h"
#import "BFInterestModelFrame.h"
#import "BFFriMediaClusterController.h"
#import "DTAlertViewController.h"
#import "BFTabbarController.h"

@interface UserDTViewController (){
    UIImageView *icon;
    UILabel *nameLabel;
    UIButton *bellBtn;
    UILabel *dtnumLabel;
    UILabel *alertLabel;
    AKASegmentedControl *segmentedControl;
    UIView *upview;
    UserDTController *userdt;
    UserDTPictureController *picdt;
    NSInteger itemsNum;
    NSDictionary *userHead;
    NSString *home_uid;

}
@property (nonatomic, assign) BOOL isSmallScreen;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *picDataArray;

// 缓存数组
@property (nonatomic,strong) NSMutableArray *cachesArray;
@end

@implementation UserDTViewController

- (NSMutableArray *)picDataArray{
    if (!_picDataArray) {
        _picDataArray = [NSMutableArray array];
    }
    return _picDataArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    itemsNum = 0;
    [self configureUI];
    [self achieveData];
    [self setAlert];
    
}

- (void)setAlert{
    BFTabbarController *tabarvc = (BFTabbarController *)self.tabBarController;
    if (tabarvc.tabbar.dtNum != 0) {
        alertLabel.hidden = NO;
        alertLabel.text = [NSString stringWithFormat:@"%ld",tabarvc.tabbar.dtNum];
    }
}



- (void)configureUI{
    self.title = @"个人动态";
    
    UIButton *cameraItem = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraItem.frame = CGRectMake(0, 0, 23, 20);
        [cameraItem setBackgroundImage:[UIImage imageNamed:@"fadongtai"] forState:UIControlStateNormal];
    
    UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithCustomView:cameraItem];
    [cameraItem addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [self.useruid isEqualToString:[BFUserLoginManager shardManager].jmId] ? camera:nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    upview = [[UIView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, 98*ScreenRatio)];
    upview.userInteractionEnabled = YES;
    [self.view addSubview:upview];
    icon = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ScreenRatio, 10*ScreenRatio, 40*ScreenRatio, 40*ScreenRatio)];
    icon.layer.cornerRadius = 20*ScreenRatio;
    icon.layer.masksToBounds = YES;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    [upview addSubview:icon];
    
    nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = BFFontOfSize(16);
    [upview addSubview:nameLabel];
    
    
    bellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bellBtn.frame = CGRectMake(Screen_width - 45*ScreenRatio, 20*ScreenRatio, 35*ScreenRatio, 20*ScreenRatio);
    NSString *userID = [BFUserLoginManager shardManager].jmId;

    self.isSelf = [self.useruid isEqualToString:userID] ? YES :NO;
    
    
    bellBtn.tag = 999 + 6;
    [bellBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    [bellBtn setBackgroundImage:self.isSelf ? [UIImage imageNamed:@"dtselfbell"] : [UIImage imageNamed:@"guanzhulogo"] forState:UIControlStateNormal];
    [upview addSubview:bellBtn];
    if (self.isSelf) {
        bellBtn.frame = CGRectMake(Screen_width - 45*ScreenRatio, 20*ScreenRatio, 18*ScreenRatio, 20*ScreenRatio);
    }else{
        bellBtn.hidden = YES;
    }
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(bellBtn.width - 5*ScreenRatio, -3, 11*ScreenRatio, 11*ScreenRatio)];
    alertLabel.layer.cornerRadius = CGRectGetWidth(alertLabel.frame)/2;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.backgroundColor = [UIColor redColor];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = BFFontOfSize(9);
    alertLabel.hidden = YES;
    [bellBtn addSubview:alertLabel];
    
    
    dtnumLabel = [[UILabel alloc]init];
    dtnumLabel.textColor = [UIColor grayColor];
    dtnumLabel.textAlignment = NSTextAlignmentLeft;
    dtnumLabel.font = BFFontOfSize(13);
    [upview addSubview:dtnumLabel];
    
    [self setupSegmentedControl3];

}

- (void)cameraClick:(UIBarButtonItem *)cameraItem{
//    self.tabBarController.tabBar.hidden = YES;
    BFFriMediaClusterController *clustervc = [[BFFriMediaClusterController alloc]init];
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:clustervc animated:YES];
    
}

- (void)achieveData{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/news/",DongTai_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *para;
    home_uid = self.isSelf ? UserwordMsg : self.useruid;
    if (UserwordMsg && JMTOKEN) {
        NSString *num = [NSString stringWithFormat:@"%ld",itemsNum];

        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"page_item_pos":num,@"home_uid":self.useruid};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            
            NSDictionary *contentDic = dic[@"content"];
            userHead = contentDic[@"head"];
            for (NSDictionary *userDic in contentDic[@"fnlist"]) {
                BFInterestModel *interestModel = [BFInterestModel configureModelWithDic:userDic];
                BFInterestModelFrame *modelFrame = [[BFInterestModelFrame alloc]init];
                modelFrame.interestModel = interestModel;
                [self.dataArray addObject:modelFrame];
                [self.cachesArray addObject:userDic];
            }
            NSLog(@"%@",self.dataArray);
            
            userdt.dataArray = self.dataArray;
            userdt.userDic = userHead;
            if (userHead && userHead[@"uid"] != nil) {
                [self configutrHeaderView:userHead];

            }
            // 存入缓存
            //            [BFChatHelper saveToLocalDB:self.cachesArray saveIdenti:@"DTDATA"];
                        itemsNum = self.dataArray.count;
            //            [interestList reloadData];
            if (self.dataArray.count == 0) {
                [userdt.interestList setBackgroundView:[self buidImage:@"hanomesg" title:@"暂无动态" up:YES]];
                [userdt.interestList reloadData];

            }
        }
    } failure:^(NSError *error) {
        //
    }];
    self.isSmallScreen = YES;
    
}

- (void)configutrHeaderView : (NSDictionary *)userDic{
    [icon sd_setImageWithURL:[NSURL URLWithString:userDic[@"head_image"]] placeholderImage:BFIcomImg];
    
    CGFloat width = [userDic[@"nikename"] getWidthWithHeight:13*ScreenRatio font:16];
    nameLabel.frame = CGRectMake(CGRectGetMaxX(icon.frame)+5*ScreenRatio, 10*ScreenRatio, width, 17*ScreenRatio);
    nameLabel.text = [NSString stringWithFormat:@"%@",userDic[@"nikename"]];
    NSString *dongtainum ;
    if (userDic[@"counts"]) {
        dongtainum = userDic[@"counts"];
    }else{
        dongtainum = @"0";
    }
    NSString *dtnum = [NSString stringWithFormat:@"%@条动态",dongtainum];
    CGFloat dtnumwidth = [dtnum getWidthWithHeight:13*ScreenRatio font:13];
    
    dtnumLabel.frame = CGRectMake(CGRectGetMaxX(icon.frame)+5*ScreenRatio, CGRectGetMaxY(nameLabel.frame)+ 7*ScreenRatio, dtnumwidth, 13*ScreenRatio);
    dtnumLabel.text = dtnum;
}

- (void)setupSegmentedControl3
{

    UIView *upline = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame) + 10.0 *ScreenRatio, Screen_width, 0.5)];
    upline.backgroundColor = [UIColor lightGrayColor];
    
    [upview addSubview:upline];
    
    segmentedControl = [[AKASegmentedControl alloc] initWithFrame:CGRectMake(10.0 * ScreenRatio, CGRectGetMaxY(upline.frame), Screen_width - 20 * ScreenRatio, 37.0 * ScreenRatio)];
    [segmentedControl addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];

    [segmentedControl setSegmentedControlMode:AKASegmentedControlModeSticky];
    [segmentedControl setSelectedIndex:0];

    [segmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    // Button 1
    UIButton *buttonsf = [[UIButton alloc] init];
    buttonsf.backgroundColor = [UIColor clearColor];
    UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"dongtaiself-normal"];
    UIImage *buttonSocialImageSelect = [UIImage imageNamed:@"dongtaiself-selected"];

    [buttonsf setImage:buttonSocialImageNormal forState:UIControlStateNormal];
    [buttonsf setImage:buttonSocialImageSelect forState:UIControlStateSelected];
    [buttonsf setImage:buttonSocialImageSelect forState:UIControlStateHighlighted];
    [buttonsf setImage:buttonSocialImageSelect forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 1
    UIButton *buttonsl = [[UIButton alloc] init];
    buttonsl.backgroundColor = [UIColor clearColor];
    UIImage *buttonslImageNormal = [UIImage imageNamed:@"dongtaisuoluo-normal"];
    UIImage *buttonslImageSelect = [UIImage imageNamed:@"dongtaisuoluo-selected"];

    [buttonsl setImage:buttonslImageNormal forState:UIControlStateNormal];
    [buttonsl setImage:buttonslImageSelect forState:UIControlStateSelected];
    [buttonsl setImage:buttonslImageSelect forState:UIControlStateHighlighted];
    [buttonsl setImage:buttonslImageSelect forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentedControl.frame), Screen_width, 0.5)];
    bottomline.backgroundColor = [UIColor lightGrayColor];
    [upview addSubview:bottomline];
    [segmentedControl setButtonsArray:@[buttonsf, buttonsl]];
    [upview addSubview:segmentedControl];
    
    userdt = [[UserDTController alloc]init];
    userdt.isSelf = self.isSelf;
    
    [self addChildViewController:userdt];
    picdt = [[UserDTPictureController alloc]init];
    [self addChildViewController:picdt];
    
    userdt.view.frame = CGRectMake(0, CGRectGetMaxY(upview.frame), Screen_width, Screen_height - CGRectGetMaxY(upview.frame) );
    picdt.view.frame = CGRectMake(0, CGRectGetMaxY(upview.frame), Screen_width, Screen_height - CGRectGetMaxY(upview.frame) );
    [self.view addSubview:userdt.view];
    [self.view addSubview:picdt.view];
    [self.view bringSubviewToFront:userdt.view];
}

#pragma mark - AKASegmentedControl callbacks

- (void)segmentedViewController:(id)sender
{
    AKASegmentedControl *segmentedCl = (AKASegmentedControl *)sender;
    NSIndexSet *indexset =  [segmentedCl selectedIndexes];
    NSInteger index = [indexset indexLessThanIndex:2];
    if (index == 0) {
        [self.view bringSubviewToFront:userdt.view];
    }else{
        [self achievePicData];

        [self.view bringSubviewToFront:picdt.view];

    }
}

- (void)btnClick:(UIButton *)btn{

    alertLabel.hidden = YES;
    BFTabbarController *tabarvc = (BFTabbarController *)self.tabBarController;
    BFTabbar *tb = tabarvc.tabbar;
    [tb hideDTNum];
    DTAlertViewController *vc = [[DTAlertViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)achievePicData{
    NSString *urlstr = [NSString stringWithFormat:@"%@/user/news/thumbanil/",DongTai_URL];
    NSDictionary *para;
    [MBProgressHUD showHUDAddedTo:picdt.view animated:YES];
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"page_item_pos":@0,@"home_uid":home_uid};
    }
    [BFNetRequest getWithURLString:urlstr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:picdt.view animated:YES];
        NSLog(@"%@",dic);
        if (self.picDataArray.count > 0) {
            [self.picDataArray removeAllObjects];
        }
        if ([dic[@"success"] intValue]) {
            NSArray *content = dic[@"content"];
            if (content.count > 0) {
                for (NSDictionary *picDic in content) {
                    [self.picDataArray addObject:picDic];
                }
            }
            picdt.dataArray = self.picDataArray;
            
            if (self.picDataArray.count == 0) {
                [picdt.collectionView setBackgroundView:[self buidImage:@"hanomesg" title:@"暂无动态" up:YES]];
                [picdt.collectionView reloadData];
                
            }
        }
        
    } failure:^(NSError *error) {
        //
    }];
}

- (UIView *)buidImage:(NSString *)imgstr title:(NSString *)tink up:(BOOL)isup{
    UIImage *img = [UIImage imageNamed:imgstr];
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    back.backgroundColor = BFColor(222, 222, 222, 1);
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60*ScreenRatio, 60*ScreenRatio)];
    if (isup) {
        imgview.center = CGPointMake(Screen_width/2, Screen_height/2 - 90*ScreenRatio);
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
