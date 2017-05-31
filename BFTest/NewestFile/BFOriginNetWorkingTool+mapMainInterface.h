//
//  BFOriginNetWorkingTool+mapMainInterface.h
//  BFTest
//
//  Created by 伯符 on 2017/4/17.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFOriginNetWorkingTool.h"
#import "BFUserInfoModel.h"

@interface BFOriginNetWorkingTool (mapMainInterface)

// 请求所有人
+ (void)getNearbyAllUserLocate:(CLLocationCoordinate2D)coordinate type:(NSInteger)typeindex completionHandler:(void(^)(NSMutableArray *shops,NSMutableArray *users, NSError *error))completionHandler;

// 请求男生或者女生
+ (void)getNearbyUserLocate:(CLLocationCoordinate2D)coordinate type:(NSInteger)typeindex completionHandler:(void(^)(NSMutableArray *users, NSError *error))completionHandler;

// 请求商家
+ (void)getNearbyMerchantsLocate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(NSMutableArray *users, NSError *error))completionHandler;

// 记录GPS
+ (void)insertGPSWithCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(NSString *code, NSError *error))completionHandler;

// 啵一啵 搜索
+ (void)searchNearbyUserLocate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(NSMutableArray *users, NSError *error))completionHandler;

+ (void)likeOrnotUser:(NSString *)jmid likeorNot:(BOOL)like completionHandler:(void(^)(NSString *code, NSError *error))completionHandler;

+ (void)requestForUserInfo:(NSString *)otherjm completionHandler:(void(^)(BFUserInfoModel *model, NSError *error))completionHandler;
@end
