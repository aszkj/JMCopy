//
//  BFSearchLocationDetailController.m
//  BFTest
//
//  Created by 伯符 on 17/2/14.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFSearchLocationDetailController.h"
#import <MapKit/MapKit.h>
#import "EaseLocationViewController.h"

#import "UIViewController+HUD.h"
#import "EaseLocalDefine.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "BFLocateModel.h"
#import "BFHotCollectionViewCell.h"
#import "BFDataGenerator.h"
#import "UserDTDetailController.h"
static BFSearchLocationDetailController *defaultLocation = nil;

@interface BFSearchLocationDetailController ()<CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    BMKMapView *_mapView;
    BMKPointAnnotation *_annotation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
    UIButton *locateButton;
    BMKLocationService *_locService;
    UITableView *listTableView;
    BMKPinAnnotationView *newAnnotation;
    UICollectionView *collectView;
    NSString *locationName;
}

@property (strong, nonatomic) NSString *addressString;

@property (strong, nonatomic) NSMutableArray *listArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BFSearchLocationDetailController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记e得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate locationName:(NSString *)name
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _currentLocationCoordinate = locationCoordinate;
        locationName = name;
    }
    
    
    return self;
}

+ (instancetype)defaultLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLocation = [[BFSearchLocationDetailController alloc] initWithNibName:nil bundle:nil];
    });
    
    return defaultLocation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    [self achieveData];
}

- (void)achieveData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/news/search/",DongTai_URL];
    
    NSDictionary *para;
    if (UserwordMsg) {
        para = @{@"uid":UserwordMsg,@"token":@"",@"type":@"L",@"parm":locationName};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            
            NSMutableArray *content = dic[@"content"];
            if (content.count != 0) {
                for (NSDictionary *model in content) {
                    [self.dataArray addObject:model];
                }
                [collectView reloadData];
            }
        }
    } failure:^(NSError *error) {
        //
    }];

}

- (void)configureUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = locationName;
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, 150*ScreenRatio)];
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    _mapView.zoomLevel = 18;
    _mapView.scrollEnabled = NO;
    _mapView.delegate=self;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    displayParam.locationViewImgName= @"alert";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    [_mapView setCenterCoordinate:_currentLocationCoordinate];
    
    locateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 30)];
    locateButton.center = CGPointMake(_mapView.center.x, _mapView.center.y - 20);
    [locateButton setImage:[UIImage imageNamed:@"mapnumbc"] forState:UIControlStateNormal];
    [self.view addSubview:locateButton];
    [_mapView bringSubviewToFront:locateButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*ScreenRatio, CGRectGetMaxY(_mapView.frame)+10*ScreenRatio, 70*ScreenRatio, 20*ScreenRatio)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"热门";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewFlowLayout.minimumLineSpacing = 1.0f;
    collectionViewFlowLayout.minimumInteritemSpacing = 1.0f;
    collectionViewFlowLayout.itemSize = CGSizeMake((Screen_width - 2)/3, (Screen_width - 2)/3);
    
    collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10*ScreenRatio, Screen_width, Screen_height - CGRectGetMaxY(titleLabel.frame) - 10*ScreenRatio) collectionViewLayout:collectionViewFlowLayout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.bounces = YES;
    collectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [collectView registerClass:[BFHotCollectionViewCell class] forCellWithReuseIdentifier:@"HotCell"];
    [self.view addSubview:collectView];
}




- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            
        }
        default:
            break;
    }
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    NSLog(@"mapViewDidFinishLoading");
}

#pragma mark - public

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }

}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorGreen;
        // 从天上掉下效果
        annotationView.animatesDrop = NO;
        // 设置可拖拽
        annotationView.draggable = YES;
        annotationView.image = [UIImage imageNamed:@"mapan"];
    }
    return annotationView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BFHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.item];
    if (dic) {
        cell.dic = dic;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.item];
    UserDTDetailController *vc = [[UserDTDetailController alloc]init];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
