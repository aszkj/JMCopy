//
//  BFLocationController.m
//  BFTest
//
//  Created by 伯符 on 16/9/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFLocationController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>
@interface BFLocationController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>{
    CLLocationCoordinate2D _currentLocationCoordinate;
    BMKMapView *_mapView;
    BMKLocationService *_locService;

}
@end

@implementation BFLocationController

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记e得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _currentLocationCoordinate = locationCoordinate;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    _mapView.zoomLevel=17;
    _mapView.delegate=self;
    _mapView.scrollEnabled = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    CLLocationCoordinate2D location = _currentLocationCoordinate;
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(location, BMKCoordinateSpanMake(0.01,0.01));
    viewRegion.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    viewRegion.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:viewRegion animated:YES];
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _currentLocationCoordinate;
    
    [_mapView addAnnotation:annotation];
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"locateMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorGreen;
        // 从天上掉下效果
        annotationView.animatesDrop = NO;
        // 设置可拖拽
        annotationView.draggable = YES;
        annotationView.image = [UIImage imageNamed:@"mapnumbc"];
    }
    return annotationView;
}

@end
