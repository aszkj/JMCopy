//
//  BFMapMainController.h
//  BFTest
//
//  Created by 伯符 on 16/5/4.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
//#import <BaiduMapAPI_Map/BMKLocationViewDisplayParam.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface BFMapMainController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>{
    BMKMapManager * _mapManager;
    BMKMapView * _mapView;
    BMKLocationService *_locService;
    CLLocationManager *_locationManger;
}

- (void)pushtoUserController;

@end
