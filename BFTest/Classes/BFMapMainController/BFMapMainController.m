//
//  BFMapMainController.m
//  BFTest
//
//  Created by 伯符 on 16/5/4.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFMapMainController.h"
#import "BFSliderBar.h"

#import "BFAppController.h"
#import "BFUserLeftView+new.h"
#import "BFLeftController.h"
#import "JinMaimMainController.h"
#import "BFNavigationController.h"

#import "BFMapUserInfo.h"
#import "BFPointAnnotation.h"
#import "BFMapAlertView.h"
#import "BFSellerView.h"
#import "BMKClusterManager.h"
#import "BFClusterAnnotationView.h"
#import "BMKClusterItem.h"
#import "BFClusterView.h"
#import "UserMainController.h"
#import "BFMapItemModel.h"
#import "BFMapUserView.h"
#import "MyWalletController.h"
#import "CouponController.h"
#import "BFSettingController.h"
#import "BFMatchView.h"
#import "MatchSettingController.h"
#import "MapUserItem.h"
#import "BFChatHelper.h"
#import "BFChatViewController.h"
#import "BFUserInfoController.h"

#import "BFAlertView.h"
#import "BFHXManager.h"
#import "BFDiscountCoupon.h"
#import "BFOriginNetWorkingTool+mapMainInterface.h"
#import "BFOriginNetWorkingTool+userRelations.h"


#import "BFSendMessageToWXReq.h"
#import "MKJMainPopoutView.h"


@interface BFMapMainController ()<BFUserLeftViewSelectDelegate,BFMapAlertViewDelete,BFSellerViewDelete,BFUserViewDelete,BFCouponDelete,BFClusterViewDelete,CLLocationManagerDelegate,MKJMainPopoutViewDelegate>{
    
    BFSliderBar *sliderBar;
    BFPointAnnotation* pointAnnotation;
    
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
    NSInteger _previousZoom; // 记录前一次的缩放等级
    dispatch_source_t _timer;
    NSDictionary *userData;
    UIButton *showbtn;
}


@property (nonatomic,strong) BFUserLeftView* leftView;
@property (nonatomic,strong) NSDictionary *dicUser;
@property (nonatomic,strong) BFMapAlertView *alertView;
@property (nonatomic,strong) BFClusterView *clusterView;
@property (nonatomic,strong) BFSellerView *sellView;
@property (nonatomic,strong) BFMapUserView *userView;
@property (nonatomic,strong) BFDiscountCoupon *couponView;

@property (nonatomic,strong) BFMatchView *matchView;

@property (nonatomic,strong) NSArray *alertArray;
@property (nonatomic,strong) NSMutableArray *itemModelArray;
@property (nonatomic,strong) NSMutableArray <BFPointAnnotation *>*shopAnnotationArray;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation BFMapMainController



- (void)setShopAnnotationArray:(NSMutableArray<BFPointAnnotation *> *)shopAnnotationArray{
    dispatch_async(dispatch_get_main_queue(), ^{
        //先移除先前添加的商家大头针
        //        [_mapView removeAnnotations:_shopAnnotationArray];
        
        _shopAnnotationArray = shopAnnotationArray;
        
        //再添加新的商家大头针
        //        [_mapView addAnnotations:_shopAnnotationArray];
    });
}

- (NSMutableArray<BFPointAnnotation *>*)getBFPointAnnotationsByShops:(NSMutableArray *)shops{
    NSMutableArray *arrM = [NSMutableArray array];
    for(BFMapItemModel *model in shops){
        BFPointAnnotation *annotation = [[BFPointAnnotation alloc]init];
        annotation.size = 1;
        annotation.items = [NSMutableArray arrayWithObject:model];
        annotation.coordinate = CLLocationCoordinate2DMake(model.coor.latitude, model.coor.longitude);
        [arrM addObject:annotation];
    }
    return arrM;
}

- (NSMutableArray *)itemModelArray{
    if (!_itemModelArray) {
        _itemModelArray = [NSMutableArray array];
    }
    return _itemModelArray;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:self.view.bounds];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignUperView:)];
        [_backView addGestureRecognizer:tap];
    
    }
    return _backView;
}

- (BFMapAlertView *)alertView{
    if (!_alertView) {
        
        _alertView = [[BFMapAlertView alloc]initWithFrame:CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0)];
        _alertView.delegate = self;
    }
    return _alertView;
}

- (BFClusterView *)clusterView{
    if (!_clusterView) {
        
        _clusterView = [[BFClusterView alloc]initWithFrame:CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0)];
        _clusterView.delegate = self;
    }
    return _clusterView;
}

- (BFSellerView *)sellView{
    if (!_sellView) {
        _sellView = [[BFSellerView alloc]initWithFrame:CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0)];
        _sellView.delegate = self;
    }
    return _sellView;
    
}

- (BFMapUserView *)userView{
    if (!_userView) {
        _userView = [[BFMapUserView alloc]initWithFrame:CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0)];
        _userView.userDelegate = self;
    }
    return _userView;
}

- (BFDiscountCoupon *)couponView{
    if (!_couponView) {
        _couponView = [[BFDiscountCoupon alloc]initWithFrame:CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0)];
        _couponView.userDelegate = self;
    }
    return _couponView;
}

- (BFMatchView *)matchView{
    if (!_matchView) {
        _matchView = [[BFMatchView alloc]initWithFrame:CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio - kMapShowHeight, kMapPopViewHeight, kMapShowHeight)];
        _matchView.delegate = self;
    }
    return _matchView;
}


- (BFUserLeftView *)leftView{
    if (!_leftView) {
        _leftView = [[BFUserLeftView alloc]initWithFrame:CGRectMake(- 305, 0, 305, Screen_height)];
        if (Screen_width == 320) {
            _leftView = [[BFUserLeftView alloc]initWithFrame:CGRectMake(- 250, 0, 250, Screen_height)];
        }
        _leftView.delegate = self;
        _leftView.vc = self;
    }
    return _leftView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    self.navigationController.navigationBar.hidden = NO;
    
    _mapView.delegate = self; // 此处记e得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    [self resignUperView:nil];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)addTimer{
    NSTimer *timer = [BFUserLoginManager shardManager].timer_GPS;
    if(timer){
        return;
    }
    
    timer = [NSTimer timerWithTimeInterval:5*60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    [BFUserLoginManager shardManager].timer_GPS = timer;
}

- (void)timerAction{
    CLLocationCoordinate2D coordinate = _locService.userLocation.location.coordinate;
    [BFOriginNetWorkingTool insertGPSWithCoordinate:coordinate completionHandler:^(NSString *code, NSError *error) {
        if(code.intValue == 200){
            NSLog(@"上传成功！");
        }else{
            NSLog(@"上传失败！");
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMapView];
    //    RefreshUser
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(achieveUserData) name:@"RefreshUser" object:nil];
    
    [self achieveUserData];
    [self setupLocService];
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    self.alertArray = @[@{@"alerImg":@"changemesg",@"alertTitle":@"交易消息",@"alertSub":@"您购买的单人自助午餐于12：30放入购物车，请尽快使用"},@{@"alerImg":@"myticket",@"alertTitle":@"我的券",@"alertSub":@"您购买的单人自助午餐于12：30放入购物车，请尽快使用"}];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70*ScreenRatio, 30*ScreenRatio)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"JINMAI"]];
    imgview.contentMode = UIViewContentModeScaleAspectFill;
    imgview.clipsToBounds = YES;
    imgview.frame = CGRectMake(0, 0, 60*ScreenRatio, 12*ScreenRatio);
    imgview.center = CGPointMake(35*ScreenRatio, 15*ScreenRatio);
    [view addSubview:imgview];
    self.navigationItem.titleView = view;
    //请求用户信息 侧滑时候显示用户头像和用户名
    [self addSearchBo];
    //     设置导航栏按钮
    [self buildBarItem];
    //     设置边缘滑动手势
    [self configureGesture];
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
    [_clusterManager clearClusterItems];
    UIView *rootView = [UIApplication sharedApplication].keyWindow;
    [rootView addSubview:self.leftView];
    [self startLocation];
    
    // 请求优惠券
    [self achieveDiscountCoupon];
    
    
}



- (void)achieveData{
    
    [_clusterManager clearClusterItems];
    
    
    CLLocationCoordinate2D coordinate = _locService.userLocation.location.coordinate;
    
    
    [BFOriginNetWorkingTool getNearbyAllUserLocate:coordinate type:3 completionHandler:^(NSMutableArray *shops, NSMutableArray *users, NSError *error) {
        
        //  商家添加到百度地图聚合
        //        for (int i = 0; i < shops.count; i ++) {
        //            BFMapItemModel *clusterItem = shops[i];
        //            [_clusterManager addClusterItem:clusterItem];
        //            [self.itemModelArray addObject:clusterItem];
        //        }
        
        
        //商家添加到百度地图不聚合大头针
        self.shopAnnotationArray = [self getBFPointAnnotationsByShops:shops];
        
        BOOL hideOrpresence = [[NSUserDefaults standardUserDefaults]boolForKey:PRESENCEORHIDE];
        if (hideOrpresence) {
            for (int i = 0; i < users.count; i ++) {
                BFMapItemModel *clusterItem = users[i];
                [_clusterManager addClusterItem:clusterItem];
                [self.itemModelArray addObject:clusterItem];
            }
            
        }
        
        [self updateClusters];
    }];
    
}

#pragma mark - 初始化定位参数
- (void)setupLocService{
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _locService.distanceFilter = 0.1;//设置最小的更新距离为0.1m
}
#pragma mark - 地图初始化
- (void)addMapView{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 30*ScreenRatio)];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.delegate = self; // 此处记e得不用的时候需要置nil，否则影响内存的释放
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 20;
    _mapView.logoPosition = BMKLogoPositionCenterTop;

    _mapView.minZoomLevel = MINZoomLevel;//18;
    _mapView.maxZoomLevel = MAXZoomLevel;//20.7;//20.7;
    
    _mapView.showMapScaleBar = NO;  // 设置比例尺
    _mapView.scrollEnabled = NO;
    _mapView.rotateEnabled = YES;
    
    //    _mapView.mapScaleBarPosition = CGPointMake(CGRectGetMinX(getcode.frame)+2, Screen_height - 90);
    [self.view addSubview:_mapView];
    // 添加顶部滑动导航条
    [self configureSlider];
    
    
    UIButton *getcode = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [getcode setTitle:@"定位" forState:UIControlStateNormal];
    [getcode setBackgroundImage:[UIImage imageNamed:@"locatelogo"] forState:UIControlStateNormal];
    [getcode setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    getcode.titleLabel.font = BFFontOfSize(15);
    getcode.frame = CGRectMake(20, Screen_height - 100, 30, 30);
    [self.view addSubview:getcode];
    [getcode addTarget:self action:@selector(locat:) forControlEvents:UIControlEventTouchUpInside];
    if(IsTestModel){
        [getcode addTarget:self action:@selector(changeTrackingModel) forControlEvents:UIControlEventTouchUpOutside];
        [getcode addTarget:self action:@selector(addBottomCollectionView) forControlEvents:UIControlEventTouchDragEnter];
    }
    
    showbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showbtn setBackgroundImage:[UIImage imageNamed:@"hideself"] forState:UIControlStateNormal];
    [showbtn setBackgroundImage:[UIImage imageNamed:@"showself"] forState:UIControlStateSelected];
    BOOL hideOrpresence = [[NSUserDefaults standardUserDefaults]boolForKey:PRESENCEORHIDE];
    showbtn.selected = hideOrpresence;
    
    [showbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    showbtn.frame = CGRectMake(Screen_width - 55, CGRectGetMaxY(sliderBar.frame) + 20*ScreenRatio, 40, 40);
    
    [self.view addSubview:showbtn];
    [showbtn addTarget:self action:@selector(showSelfInMap:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma addCollectionView
- (void)addBottomCollectionView{
    if(self.bottomView == nil){
        _mapView.userTrackingMode = BMKUserTrackingModeHeading;
    MKJMainPopoutView *bottomView = [[MKJMainPopoutView alloc]init];
    [bottomView showInSuperView:_mapView];
        bottomView.delegate = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(_mapView);
        make.height.mas_equalTo(150);
        make.bottom.equalTo(self.view).offset(-Tabbar_Height-10);
    }];
    self.bottomView = bottomView;
    }else{
        [self.bottomView removeFromSuperview];
        self.bottomView = nil;
    }
}
-(void)selected:(MKJItemModel *)item{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(item.latitude, item.longitude);
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(location, BMKCoordinateSpanMake(0.01,0.01));
    [_mapView setRegion:viewRegion animated:YES];
}

#pragma mark - 开启隐身/现身

- (void)showSelfInMap:(UIButton *)btn{
    if (!btn.selected) {
        BFAlertView *alertview = [BFAlertView alertViewWithContent:@"现身状态将会出现在地图上,现身的用户能够互相看见,是否切换到现身状态?" mainBtn:@"确定" otherBtn:@"取消"];
        [alertview show];
        alertview.action = ^(UIButton *selectBtn){
            if ([selectBtn.titleLabel.text isEqualToString:@"确定"]) {
                btn.selected = !btn.selected;
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:PRESENCEORHIDE];
                [self filterValueChanged:sliderBar];
            }
        };
    }else{
        
        BFAlertView *alertview = [BFAlertView alertViewWithContent:@"隐身状态不会出现在地图上,也看不见其他用户,是否切换到隐身状态?" mainBtn:@"确定" otherBtn:@"取消"];
        [alertview show];
        alertview.action = ^(UIButton *selectBtn){
            if ([selectBtn.titleLabel.text isEqualToString:@"确定"]) {
                btn.selected = !btn.selected;
                
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:PRESENCEORHIDE];
                [self filterValueChanged:sliderBar];
                
            }
        };
    }
    
}

#pragma mark - 配对
- (void)addSearchBo{
    UIButton *bobo = [UIButton buttonWithType:UIButtonTypeCustom];
    [bobo setBackgroundImage:[UIImage imageNamed:@"newbobo"] forState:UIControlStateNormal];
    
    bobo.frame = CGRectMake(Screen_width - 83, Screen_height - 93, 78, 29);
    [self.view addSubview:bobo];
    [bobo addTarget:self action:@selector(bobo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bobo:(UIButton *)btn{
    [self.view addSubview:self.backView];
    [self.view addSubview:self.matchView];
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    NSString *imgStr = manager.photo;
    [self.matchView startedRadarScan:imgStr];
    __block int timeout = MAXFLOAT + arc4random_uniform(3);
    __block int timenum = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self matchDeleteClick:nil];
            });
        }
        timeout--;
        timenum ++;
        if (timenum > 2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.matchView.tinktext = @"附近没有更多的人了...";
                self.matchView.settingBtn.hidden = NO;
            });
            return ;
            
        }
        
        
    });
    
    dispatch_resume(_timer);
    
    CLLocationCoordinate2D coordinate = _locService.userLocation.location.coordinate;
    
    [BFOriginNetWorkingTool searchNearbyUserLocate:coordinate completionHandler:^(NSMutableArray *users, NSError *error) {
        
        if (users.count != 0) {
            timeout = 3;
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    //            dispatch_release(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.matchView showMatchUserview:users];
                    });
                }
                timeout--;
            });
        }
    }];
    
    
}


#pragma mark - 请求用户信息
- (void)achieveUserData{
    userData = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_KEY];
    self.leftView.userDic = userData;
}

#pragma mark - configureGesture
- (void)configureGesture{
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panStart:)];
    pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
}

- (void)panStart:(UIScreenEdgePanGestureRecognizer *)pan{
    
    [self.leftView showWithGesture:pan];
}
#pragma mark - 设置导航栏按钮
- (void)buildBarItem{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 16, 20);
    [back setBackgroundImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:back];
    [back addTarget:self action:@selector(selectUser:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBar;
    
    
    UIButton *back2 = [UIButton buttonWithType:UIButtonTypeCustom];
    back2.frame = CGRectMake(0, 0, 16, 20);
    [back2 setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    UIBarButtonItem *backBar2 = [[UIBarButtonItem alloc]initWithCustomView:back2];
    [back2 addTarget:self action:@selector(showAlertView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = backBar2;
}

- (void)selectUser:(UIBarButtonItem *)item{
    
    [self.leftView showLeftView];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self keepNaviheight];
    
}

#pragma mark - 点击右边按钮   显示消息
- (void)showAlertView:(UIBarButtonItem *)item{
    
    [self sellerDeleteClick:nil];
    [self clusterDeleteClick:nil];
    [self userDeleteClick:nil];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.alertView];
    [self.alertView showMapAlertView];
}

- (void)keepNaviheight{
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBar.height = 64;
        [self.navigationController.navigationBar layoutIfNeeded];
    } completion:nil];
}


#pragma mark - BFUserLeftViewSelectDelegate

- (void)hiddenStatusBar{
    [self keepNaviheight];
}

- (void)selectedIndex:(NSInteger)index{
    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    if ([hidebtn[@"MBCenter"]isEqualToString:@"0"] || [UserwordMsg isEqualToString:@"123456jm"]){
        switch (index) {
            case 0:
            {
                // 我的卡包
                CouponController *vc = [[CouponController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                // 我的设置
                BFSettingController *main = [[BFSettingController alloc]init];
                main.hidesBottomBarWhenPushed = YES;
                //            BFNavigationController *nv = [[BFNavigationController alloc]initWithRootViewController:main];
                //            [self presentViewController:nv animated:YES completion:nil];
                [self.navigationController pushViewController:main animated:YES];
            }
                break;
            case 2:
            {
                // 分享给好友
                [self shareToWXFriends];
            }
                break;
                
            default:
                break;
        }
        
    }else{
        switch (index) {
            case 0:
            {
                // 会员中心
                [self showAlertViewTitle:@"敬请期待" message:nil];
            }
                break;
            case 1:
            {
                // 我的钱包
                
                [self showAlertViewTitle:@"敬请期待" message:nil];
                
                //            MyWalletController *vc = [[MyWalletController alloc]init];
                //            BFNavigationController *nv = [[BFNavigationController alloc]initWithRootViewController:vc];
                //            [self presentViewController:nv animated:YES completion:nil];
                //            [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                // 我的卡包
                CouponController *vc = [[CouponController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 3:
            {
                // 我的设置
                BFSettingController *main = [[BFSettingController alloc]init];
                main.hidesBottomBarWhenPushed = YES;
                
                //            BFNavigationController *nv = [[BFNavigationController alloc]initWithRootViewController:main];
                //            [self presentViewController:nv animated:YES completion:nil];
                [self.navigationController pushViewController:main animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
    
}

- (void)shareToWXFriends{
    [BFSendMessageToWXReq shareAction];
}
#pragma mark - 配置地图滑动选择器
- (void)configureSlider{
    sliderBar = [[BFSliderBar alloc]initWithFrame:CGRectMake(25, 70, self.view.frame.size.width-50, 60) Titles:[NSArray arrayWithObjects:@"全部", @"男生", @"女生", @"生活", nil]];
    [sliderBar addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [sliderBar setProgressColor:[UIColor blackColor]];//设置滑杆的颜色
    [sliderBar setTopTitlesColor:BFThemeColor];//设置滑块上方字体颜色
    [sliderBar setSelectedIndex:0];//设置当前选中
    [self.view addSubview:sliderBar];
    
    //    double delayInSeconds = 0.2;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        //执行事件
    //        [self filterValueChanged:sliderBar];
    //    });
}

#pragma mark -- 滑动滑块按钮响应事件
-(void)filterValueChanged:(BFSliderBar *)sender
{
    
    for (NSMutableArray *ar in _clusterCaches) {
        if (ar.count > 0) {
            [ar removeAllObjects];
        }
    }
    if (self.itemModelArray.count > 0) {
        [self.itemModelArray removeAllObjects];
    }
    [_clusterManager clearClusterItems];
    [_mapView removeAnnotations:_mapView.annotations];
    
    BOOL hideOrpresence = [[NSUserDefaults standardUserDefaults]boolForKey:PRESENCEORHIDE];
    if (!hideOrpresence && sender.SelectedIndex != 3 && sender.SelectedIndex != 0) {
        
        [self updateClusters];
        return ;
    }
    //滑块选择显示类型
    switch (sender.SelectedIndex) {
        case 0:{
            [self achieveData];
        }
            break;
        case 1:{
            
            [self achieveMaleUser];
        }
            break;
        case 2:{
            
            [self achieveFemaleUser];
        }
            break;
        case 3:{
            // 生活、商家标注
            
            [self ahieveMerchant];
        }
            break;
            
        default:
            break;
    }
}

- (void)achieveFemaleUser{
    
    //删除地图上商家大头针
    self.shopAnnotationArray = nil;
    
    CLLocationCoordinate2D coordinate = _locService.userLocation.location.coordinate;
    
    [BFOriginNetWorkingTool getNearbyUserLocate:coordinate type:1 completionHandler:^(NSMutableArray *users, NSError *error) {
        NSLog(@"%@",users);
        for (int i = 0; i < users.count; i ++) {
            BFMapItemModel *clusterItem = users[i];
            [_clusterManager addClusterItem:clusterItem];
            [self.itemModelArray addObject:clusterItem];
        }
        [self updateClusters];
        
    }];
    
}

- (void)achieveMaleUser{
    //删除地图上商家大头针
    self.shopAnnotationArray = nil;
    CLLocationCoordinate2D coordinate = _locService.userLocation.location.coordinate;
    [BFOriginNetWorkingTool getNearbyUserLocate:coordinate type:0 completionHandler:^(NSMutableArray *users, NSError *error) {
        for (int i = 0; i < users.count; i ++) {
            BFMapItemModel *clusterItem = users[i];
            [_clusterManager addClusterItem:clusterItem];
            [self.itemModelArray addObject:clusterItem];
        }
        [self updateClusters];
        
    }];
    
}
//商家信息获取
- (void)ahieveMerchant{
    
    CLLocationCoordinate2D coordinate = _locService.userLocation.location.coordinate;
    
    [BFOriginNetWorkingTool getNearbyMerchantsLocate:coordinate completionHandler:^(NSMutableArray *shops, NSError *error) {
        //商家聚合版本
        //        for (int i = 0; i < shops.count; i ++) {
        //            BFMapItemModel *clusterItem = shops[i];
        //            [_clusterManager addClusterItem:clusterItem];
        //            [self.itemModelArray addObject:clusterItem];
        //        }
        //        [self updateClusters];
        //商家不聚合版本
        self.shopAnnotationArray = [self getBFPointAnnotationsByShops:shops];
        [self updateClusters];
    }];
    
}
- (void)changeTrackingModel{
    static bool testModel = NO;
    testModel = !testModel;
    if(testModel){
        _mapView.userTrackingMode = BMKUserTrackingModeHeading;
        _mapView.scrollEnabled = YES;
    }else{
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.scrollEnabled = NO;
    }
    [_mapView mapForceRefresh];
    
}

// 点击返回到当前用户位置
- (void)locat:(UIButton *)btn{
    
    CLLocationCoordinate2D location = _locService.userLocation.location.coordinate;
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(location, BMKCoordinateSpanMake(0.01,0.01));
    
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)startLocation{
    //启动LocationService
    [_locService startUserLocationService];
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewImgName= @"bnavi_icon_location_fixed";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    sliderBar.alpha = 0.1f;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"DidChange");
    sliderBar.alpha = 1.0f;
    if (_previousZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}


/**
 *地图初始化完毕时会调用此接口
 *@param mapview 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self achieveData];
    
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapview 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
                [self updateClusters];
            }
            
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            [self showAlertViewTitle:@"定位服务未开启" message:@"请前往手机设置开启定位服务以看到附近用户" cancelbutton:@"确认" otherbutton:@"开启定位"];
        }
}


//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [NSMutableArray array];
        //        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        //        if (clusters.count > 0) {
        //            [_mapView removeAnnotations:_mapView.annotations];
        //            [_mapView addAnnotations:clusters];
        //            [_mapView addAnnotations:self.shopAnnotationArray];
        //        } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            ///获取聚合后的标注
            __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
            NSLog(@"%@",array);
            dispatch_async(dispatch_get_main_queue(), ^{
                for (BMKCluster *item in array) {
                    NSLog(@" --------- item.clusterItems :%@",item.clusterItems);
                    BFPointAnnotation *annotation = [[BFPointAnnotation alloc] init];
                    annotation.coordinate = item.coordinate;
                    annotation.size = item.size;
                    annotation.items = item.clusterItems;
                    [clusters addObject:annotation];
                }
                [_mapView removeAnnotations:_mapView.annotations];
                [_mapView addAnnotations:clusters];
                [_mapView addAnnotations:self.shopAnnotationArray];
            });
        });
        //        }
    }
    _previousZoom=(NSInteger)_mapView.zoomLevel;
    
}
#pragma mark - 定位服务Delegate,调用startUserLocationService定位成功后，用此Delegate来获取定位数据
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    
    NSLog(@"%@ ----  %@",[NSNumber numberWithDouble:userLocation.location.coordinate.latitude], [NSNumber numberWithDouble:userLocation.location.coordinate.longitude]);
    
    [self addTimer];
    
    
    
    [_mapView updateLocationData:userLocation];
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    BFClusterAnnotationView *annotationView = (BFClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"renameMark"];
    
    BFPointAnnotation *cluster = (BFPointAnnotation *)annotation;
    BFMapItemModel *model = [cluster.items firstObject];
    
    //会聚合的大头针
    NSString *AnnotationViewID = @"renameMark";
    if(annotationView == nil){
        annotationView = [[BFClusterAnnotationView alloc] initWithAnnotation:cluster reuseIdentifier:AnnotationViewID];
    }
    annotationView.frame = CGRectMake(0, 0, kAnnoView_Width, kAnnoView_Height);
    
    annotationView.canShowCallout = YES;
    if (cluster.size == 1) {
        annotationView.isShop = model.isShop;
        if (model.isShop) {
            annotationView.imgStr = model.logo;
        }else{
            MapUserItem *item = model.user;
            annotationView.imgStr = item.photo;
            annotationView.sex = item.sex;
        }
    }
    
    annotationView.size = cluster.size;
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectZero];
    BMKActionPaopaoView *paopao = [[BMKActionPaopaoView alloc]initWithCustomView:imgview];
    annotationView.paopaoView = paopao;
    //     annotationView.contentMode = UIViewContentModeScaleAspectFit;
    // 从天上掉下效果
    annotationView.animatesDrop = NO;
    // 设置可拖拽
    annotationView.draggable = YES;
    return annotationView;
    
    
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    [mapView deselectAnnotation:view.annotation animated:YES];
    if ([view isKindOfClass:[BFClusterAnnotationView class]]) {
        BFClusterAnnotationView *annotationView = (BFClusterAnnotationView *)view;
        BFPointAnnotation *cluster = (BFPointAnnotation *)annotationView.annotation;
        
        if (cluster.items.count > 1) {
            [self.view addSubview:self.backView];
            [self.view addSubview:self.clusterView];
            self.clusterView.items = cluster.items;
            [self.clusterView showMapAlertView];
        }else{
            [self.view addSubview:self.backView];
            
            BFMapItemModel *model = [cluster.items firstObject];
            if (model.isShop) {
                
                [self.view addSubview:self.sellView];
                NSString *url = [NSString stringWithFormat:@"%@/mobile-app/shop/%ld/info/",BUSINESS_URL,model.shop_id];
                
                [BFNetRequest getaWithURLString:url parameters:nil success:^(id responseObject) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                    self.sellView.sellDic = dic;
                    self.sellView.shop_id = model.shop_id;
                    [self.sellView showMapAlertView];
                } failure:^(NSError *error) {
                    NSLog(@"%@",[error description]);
                }];
            }else{
                [self.view addSubview:self.backView];
                [self.view addSubview:self.userView];
                
                [BFOriginNetWorkingTool requestForUserInfo:model.user.jmid completionHandler:^(BFUserInfoModel *model, NSError *error) {
                    //
                    _userView.model = model;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.userView showMapAlertView];
                    });
                }];
                
            }
        }
    }
}

// 当点击annotation view弹出的泡泡时，调用此接口

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"annotationViewForBubble");
    if ([view.annotation isKindOfClass:[BFPointAnnotation class]]) {
        
        BFPointAnnotation *annotation = (BFPointAnnotation *)view.annotation;
        //        NSString *url = [NSString stringWithFormat:@"http://poi.jinmailife.com/open_platform/poi/poi/%f,%f/",annotation.coordinate.longitude,annotation.coordinate.latitude];
        NSString *url = @"http://poi.jinmailife.com/restaurant/poi/1/";
        BFAppController *vc = [[BFAppController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.pathStr = url;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        BFAppController *vc = [[BFAppController alloc]init];
        vc.pathStr = @"http://poi.jinmailife.com/restaurant/dish_ticket/2/pay/";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)alertViewBtnClick:(UIButton *)btn{
    NSString *url;
    if (btn.tag == AlertviewButtonTypeDelete || btn == nil) {
        [_backView removeFromSuperview];
        _backView = nil;
        
        [UIView animateWithDuration:0.2 animations:^{
            _alertView.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0);
            _alertView.sellView.frame = _alertView.bounds;
        } completion:^(BOOL finished) {
            [_alertView removeFromSuperview];
            _alertView = nil;
        }];
        return ;
    }else if (btn.tag == AlertviewButtonTypeStartPay){
        url = [NSString stringWithFormat:@"%@/mobile-site/order/order.html?type=wp&b_t=app",BUSINESS_URL];
        
    }else if (btn.tag == AlertviewButtonTypeStartUse){
        url = [NSString stringWithFormat:@"%@/mobile-site/order/order.html?type=wu&b_t=app",BUSINESS_URL];
        
    }else if (btn.tag == AlertviewButtonTypeHaveUse){
        url = [NSString stringWithFormat:@"%@/mobile-site/order/order.html?type=used&b_t=app",BUSINESS_URL];
        
    }else if (btn.tag == AlertviewButtonTypeRefund){
        url = [NSString stringWithFormat:@"%@/mobile-site/order/order.html?type=refund&b_t=app",BUSINESS_URL];
        
    }
    BFAppController *vc = [[BFAppController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pathStr = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedRow:(NSInteger)rowIndex{
    NSString *url;
    if (rowIndex == 1) {
        
        url = [NSString stringWithFormat:@"%@/mobile-site/collection/merchant_collection.html?b_t=app",BUSINESS_URL];
    }else{
        url = [NSString stringWithFormat:@"%@/mobile-site/message/message.html?b_t=app",BUSINESS_URL];
    }
    BFAppController *vc = [[BFAppController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pathStr = url;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)sellerDeleteClick:(id)object{
    
    [_backView removeFromSuperview];
    _backView = nil;
    [UIView animateWithDuration:0.2 animations:^{
        _sellView.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0);
        _sellView.sellView.frame = _clusterView.bounds;
    } completion:^(BOOL finished) {
        [_sellView removeFromSuperview];
        _sellView = nil;
    }];
    
}

#pragma mark - BFMatchViewDelete

- (void)achieveMoreData{
    
    [self bobo:nil];
    
}

- (void)matchDeleteClick:(id)object{
    dispatch_cancel(_timer);
    [_backView removeFromSuperview];
    _backView = nil;
    [_matchView removeFromSuperview];
    _matchView = nil;
}

#pragma mark - 跳转啵设置
- (void)pushToSettingVC{
    [self matchDeleteClick:nil];
    MatchSettingController *vc = [[MatchSettingController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userDeleteClick:(id)object{
    [_backView removeFromSuperview];
    _backView = nil;
    [UIView animateWithDuration:0.2 animations:^{
        _userView.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0);
        //        _sellView.sellView.frame = _clusterView.bounds;
    } completion:^(BOOL finished) {
        [_userView removeFromSuperview];
        _userView = nil;
    }];
}

- (void)couponDeleteClick:(id)object{
    [_backView removeFromSuperview];
    _backView = nil;
    [UIView animateWithDuration:0.2 animations:^{
        _couponView.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0);
    } completion:^(BOOL finished) {
        [_couponView removeFromSuperview];
        _couponView = nil;
    }];
    
}

- (void)clusterDeleteClick:(id)object{
    
    [_backView removeFromSuperview];
    _backView = nil;
    [UIView animateWithDuration:0.2 animations:^{
        _clusterView.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, 0);
        _clusterView.itemsView.frame = _clusterView.bounds;
    } completion:^(BOOL finished) {
        [_clusterView removeFromSuperview];
        _clusterView = nil;
    }];
    
}

- (void)didSelectedMapModelItem:(BFMapItemModel *)model{
    if (model.isShop) {
        [self pushToDetail:model.shop_id];
    }else{
        [self clusterDeleteClick:nil];
        [self.view addSubview:self.backView];
        [self.view addSubview:self.userView];
        
        [BFOriginNetWorkingTool requestForUserInfo:model.user.jmid completionHandler:^(BFUserInfoModel *model, NSError *error) {
            //
            _userView.model = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.userView showMapAlertView];
            });
            
        }];
        /*
         NSString *url = [NSString stringWithFormat:@"%@/getlikefriendstwo",ALI_BASEURL];
         NSDictionary *para;
         if (UserwordMsg && JMTOKEN && model.user.jmid) {
         para = @{@"tkname":UserwordMsg,@"tok":JMTOKEN,@"jmid":model.user.jmid};
         [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"%@",dic);
         if (dic) {
         _userView.userDic = dic;
         [self.userView showMapAlertView];
         }else{
         [self.userView showMapAlertView];
         
         }
         
         } failure:^(NSError *error) {
         NSLog(@"%@",[error description]);
         }];
         }else{
         [self showAlertViewTitle:@"请求失败,请稍后再试" message:nil];
         }
         */
    }
}

- (void)resignUperView:(UITapGestureRecognizer *)gesture{
    [self alertViewBtnClick:nil];
    [self sellerDeleteClick:nil];
    [self clusterDeleteClick:nil];
    [self userDeleteClick:nil];
    [self couponDeleteClick:nil];
    
    if (_matchView) {
        [self matchDeleteClick:nil];
    }
}

#pragma mark - 请求优惠券
- (void)achieveDiscountCoupon{
    NSString *url = [NSString stringWithFormat:@"%@/mobile-app/daily-coupons/",BUSINESS_URL];
    NSDictionary *para;
    NSString *phoneNum = [BFUserLoginManager shardManager].phone;
    if (UserwordMsg) {
        para = @{@"platform_uid":UserwordMsg,@"platform_token":JMTOKEN,@"platform_user_tel":phoneNum};
        [BFNetRequest getaWithURLString:url parameters:para success:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@ --- %@",dic[@"error_info"],dic);
            NSArray *arr = [dic[@"content"]objectForKey:@"clist"];
            
            if ([dic[@"success"] intValue] && arr.count > 0) {
                [self.view addSubview:self.backView];
                [self.view addSubview:self.couponView];
                self.couponView.dataDic = dic;
                [self.couponView showMapAlertView];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@",[error description]);
        }];
    }else{
        [self showAlertViewTitle:@"请求失败,请稍后再试" message:nil];
    }
}


#pragma mark - 点击头像跳转用户界面
- (void)pushtoUserController{
    [self.leftView performBackAnimate];
    //    UserMainController *userSet = [[UserMainController alloc]init];
    //    userSet.isSelf = YES;
    //    userSet.hidesBottomBarWhenPushed = YES;
    
    BFUserInfoController *vc = [BFUserInfoController creatByJmid:[BFUserLoginManager shardManager].jmId];
    vc.hidesBottomBarWhenPushed = YES;
    //    vc.prefersStatusBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转聊天界面
- (void)pushtoUserChatID:(NSString *)jmid nickname:(NSString *)name icon:(NSString *)iconname{
    BFChatViewController *chatController = [[BFChatViewController alloc]initWithConversationChatter:jmid conversationType:EMConversationTypeChat];
    chatController.title = name.length > 0 ? name : jmid;
    chatController.avatarURLPath = iconname;
    chatController.nikename = name;
    chatController.jmid = jmid;
    chatController.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *usermsg = @{@"jmid":jmid,@"nikename":name,@"userIcon":iconname};
    NSMutableArray *cacheschat = [BFChatHelper getDataArrayFromDB:@"ChatUserCaches"];
    NSLog(@"%@ ---- %@",usermsg,cacheschat);
    if (cacheschat) {
        
        for (int i = 0; i < cacheschat.count; i ++) {
            NSDictionary *userdic = cacheschat[i];
            if ([userdic[@"jmid"] isEqualToString:usermsg[@"jmid"]]) {
                if (![userdic[@"nikename"] isEqualToString:usermsg[@"nikename"]] || ![userdic[@"userIcon"] isEqualToString:usermsg[@"userIcon"]]) {
                    [cacheschat removeObject:userdic];
                }
            }
        }
        
        [cacheschat addObject:usermsg];
        [BFChatHelper saveToLocalDB:cacheschat saveIdenti:@"ChatUserCaches"];
        
    }else{
        NSMutableArray *ar = [NSMutableArray array];
        [ar addObject:usermsg];
        [BFChatHelper saveToLocalDB:ar saveIdenti:@"ChatUserCaches"];
    }
    
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - 跳转个人资料界面
- (void)pushtoUserMain:(NSString *)jmid name:(NSString *)user{
    BFUserInfoController *vc = [BFUserInfoController creatByJmid:jmid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 关注
- (void)focusUserID:(NSString *)jmid{
    [BFOriginNetWorkingTool getuserRelationsModelWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:jmid completionHandler:^(BFUserOthersSettingModel *model, NSError *error) {
        AsMyShipType type = model.isMyFans.intValue == 1 ? AsMyShipTypeFans : AsMyShipTypeStranger;
        
        [BFHXManager addFollowToOtherJmid:jmid asMyship:type callBack:^(NSString *code) {
            if ([code intValue] == 200) {
                if (_userView) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _userView.hasfocus = YES;
                        
                    });
                }
            }
        }];
    }];
    
}

#pragma mark - BFSellerViewDelete

- (void)pushToDetail:(NSInteger)shopid{
    NSString *url = [NSString stringWithFormat:@"%@/mobile-site/index.html?shop_id=%ld&b_t=app",BUSINESS_URL,shopid];
    NSLog(@"%@",url);
    BFAppController *vc = [[BFAppController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pathStr = url;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
