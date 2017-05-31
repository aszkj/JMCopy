//
//  AppDelegate.h
//  BFTest
//
//  Created by 伯符 on 16/5/3.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "BFTabbarController.h"

static NSDate *  testDate;
#define testData(str) NSLog(@"耗时%@————————————————————————————————————————————————————————time -> %f",str,[[NSDate date] timeIntervalSinceDate:testDate]);

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    BMKMapManager *_mapManager;
    CLLocationManager *_locationManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

