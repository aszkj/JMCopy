//
//  BFNearbyPlaceController.m
//  BFTest
//
//  Created by 伯符 on 16/12/23.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFNearbyPlaceController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "BFLocateModel.h"
@interface BFNearbyPlaceController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate,BMKMapViewDelegate>{
    CLLocationManager *_locationManager;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BMKCoordinateRegion region;
    NSString *businessCircle;
}
@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation BFNearbyPlaceController

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _locService.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    _locService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;//kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    [_locationManager startUpdatingLocation];
    
    
}

- (void)configureData:(CLLocationCoordinate2D)MapCoordinate{
    //屏幕坐标转地图经纬度
//    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:locateButton.center toCoordinateFromView:_mapView];
    
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
//            weakSelf.addressString = addressStr;
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
    if ([result.businessCircle containsString:@","]) {
        businessCircle = [[result.businessCircle componentsSeparatedByString:@","]firstObject];
    }else{
        businessCircle = result.businessCircle;
    }
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        [self.listArray removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {

            BFLocateModel *model=[[BFLocateModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            model.pt = poiInfo.pt;
            [self.listArray addObject:model];
            [self.tableView reloadData];
        }
    }else{
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
    
}


// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    [self configureData:oldCoordinate];
    
    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    
    // 计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    NSLog(@"%f",distance);
    
    [manager stopUpdatingLocation];
    
}

// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@", @"ok");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 30*ScreenRatio)];
        back.backgroundColor = BFColor(239, 240, 241, 1);
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*ScreenRatio, 20*ScreenRatio)];
        titleLabel.center = CGPointMake(40*ScreenRatio + 10*ScreenRatio, 30*ScreenRatio/2);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = BFColor(118, 119, 120, 1);
        titleLabel.font = BFFontOfSize(16);
        if (section == 1) {
            titleLabel.text = @"附近商圈";
        }else{
            titleLabel.text = @"附近地点";
        }
        [back addSubview:titleLabel];
        return back;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 30*ScreenRatio;

    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? self.listArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*ScreenRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width - 10*ScreenRatio, 20)];
        titleLabel.tag = 999;
        titleLabel.center = CGPointMake(Screen_width/2 + 10*ScreenRatio, 45 *ScreenRatio/2);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = BFFontOfSize(17);
        [cell.contentView addSubview:titleLabel];
    }
    UILabel *label = [cell.contentView viewWithTag:999];
    if (indexPath.section == 0) {
        label.text= @"不显示位置";
    }else if (indexPath.section == 1){
        label.text= businessCircle;

    }else{
        BFLocateModel *model=self.listArray[indexPath.row];
        label.text=model.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 || indexPath.section == 1) {
        BFLocateModel *model=self.listArray[indexPath.row];
        if (self.selectBlock) {
            self.selectBlock(model.name,model.pt);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (indexPath.section == 0){
        BFLocateModel *model=self.listArray[indexPath.row];

        if (self.selectBlock) {
            self.selectBlock(nil,model.pt);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
