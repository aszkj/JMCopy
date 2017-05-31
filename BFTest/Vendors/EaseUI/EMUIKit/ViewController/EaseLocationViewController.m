/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc. 发送位置界面
 */

#import <CoreLocation/CoreLocation.h>
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
static EaseLocationViewController *defaultLocation = nil;

@interface EaseLocationViewController () <CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    BMKPointAnnotation *_annotation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;
    UIButton *locateButton;
    BMKLocationService *_locService;
    UITableView *listTableView;
    BMKPinAnnotationView *newAnnotation;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
}

@property (strong, nonatomic) NSString *addressString;

@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation EaseLocationViewController

@synthesize addressString = _addressString;


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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
    }
    
    return self;
}

+ (instancetype)defaultLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLocation = [[EaseLocationViewController alloc] initWithNibName:nil bundle:nil];
    });
    
    return defaultLocation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSEaseLocalizedString(@"location.messageType", @"location message");
    [self configureUI];
}

- (void)configureUI{
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 200*ScreenRatio)];
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    _mapView.zoomLevel = 17;
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
    
    locateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 30)];
    locateButton.center = CGPointMake(_mapView.center.x, _mapView.center.y - 20);
    [locateButton setImage:[UIImage imageNamed:@"mapnumbc"] forState:UIControlStateNormal];
    [self.view addSubview:locateButton];
    [_mapView bringSubviewToFront:locateButton];
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), Screen_width, Screen_height - _mapView.height - NavBar_Height) style:UITableViewStylePlain];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    if (_locService==nil) {
        
        _locService = [[BMKLocationService alloc]init];
        
        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    _locService.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.showsUserLocation = YES;//显示定位图层
    
    if (_isSendLocation) {
        _mapView.showsUserLocation = YES;//显示当前位置
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [sendButton setTitle:NSEaseLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [sendButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendButton]];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];

    //    _mapView.centerCoordinate = userLocation.location.coordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
    
//    __weak typeof(self) weakSelf = self;
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
//        if (!error && array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            weakSelf.addressString = placemark.name;
//            
//            [self removeToLocation:userLocation.location.coordinate];
//        }
//    }];
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
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self showHudInView:self.view hint:NSEaseLocalizedString(@"location.ongoning", @"locating...")];
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

#pragma mark - MKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:locateButton.center toCoordinateFromView:_mapView];
//    __weak typeof(self) weakSelf = self;
//    CLLocation *location = [[CLLocation alloc]initWithLatitude:MapCoordinate.latitude longitude:MapCoordinate.longitude];
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
//        NSLog(@"%@",array);
//        if (!error && array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            weakSelf.addressString = placemark.name;
//        }
//    }];
//    _currentLocationCoordinate = MapCoordinate;

//    if (_geoCodeSearch==nil) {
//        //初始化地理编码类
//        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
//        _geoCodeSearch.delegate = self;
//    }
//    if (_reverseGeoCodeOption==nil) {
//        //初始化反地理编码类
//        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
//    }
//    //需要逆地理编码的坐标位置
//    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
//    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self startAnimate];
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:locateButton.center toCoordinateFromView:_mapView];
    
    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
        
    }
    if (_reverseGeoCodeOption==nil) {
        
        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    
    __weak typeof(self) weakSelf = self;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:MapCoordinate.latitude longitude:MapCoordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSDictionary *dic = placemark.addressDictionary;
            NSString *addressStr = [dic[@"FormattedAddressLines"] firstObject];
            weakSelf.addressString = addressStr;
        }
    }];
    _currentLocationCoordinate = MapCoordinate;

    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    
}

#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        [self.listArray removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            BFLocateModel *model=[[BFLocateModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            
            [self.listArray addObject:model];
            [listTableView reloadData];
        }
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
    
}

- (void)startAnimate{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint locatepoint = locateButton.center;
        locatepoint.y -= 20;
        locateButton.center = locatepoint;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGPoint locatepoint = locateButton.center;
            locatepoint.y += 20;
            locateButton.center = locatepoint;
        } completion:nil];
    }];
}

- (void)sendLocation
{
    NSLog(@"%@",_addressString);
    if (_delegate && [_delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
        [_delegate sendLocationLatitude:_currentLocationCoordinate.latitude longitude:_currentLocationCoordinate.longitude andAddress:_addressString];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    BFLocateModel *model=self.listArray[indexPath.row];
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.address;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

@end
