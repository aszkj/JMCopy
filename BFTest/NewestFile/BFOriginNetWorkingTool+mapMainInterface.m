//
//  BFOriginNetWorkingTool+mapMainInterface.m
//  BFTest
//
//  Created by 伯符 on 2017/4/17.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFOriginNetWorkingTool+mapMainInterface.h"
#import "BFMapUserInfo.h"
#import "BFMapItemModel.h"
#import "BFChatHelper.h"
#import "YYModel.h"
@implementation BFOriginNetWorkingTool (mapMainInterface)

//商家信息获取 网络工具接口
+ (void)getNearbyAllUserLocate:(CLLocationCoordinate2D)coordinate type:(NSInteger)typeindex completionHandler:(void(^)(NSMutableArray *shops,NSMutableArray *users, NSError *error))completionHandler{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/geosearch/v3/nearby?mcode=com.bofu.BFTest&ak=%@&geotable_id=%d&location=%f,%f&radius=150000",BAIDUMAP_ACCESSKEY,BDMERCHANT_ID,coordinate.longitude,coordinate.latitude];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [BFOriginNetWorkingTool getWithURLString:urlStr parameters:nil success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *contentsArray = responseObject[@"contents"];
        NSMutableArray *shopsArray = [NSMutableArray array];
        NSMutableArray *usersArray = [NSMutableArray array];

        if (contentsArray.count != 0) {
            for (int i = 0; i < contentsArray.count; i ++) {
                NSDictionary *seller = contentsArray[i];
                BFMapUserInfo *mapuser = [BFMapUserInfo configureMapInfoWithdic:seller];
                NSArray *coordinate = mapuser.location;
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([coordinate[1] doubleValue],[coordinate[0] doubleValue]);
                BFMapItemModel *clusterItem = [[BFMapItemModel alloc] init];
                clusterItem.coor = coor;
                clusterItem.isShop = YES;
                clusterItem.shop_id = mapuser.shop_id;
                //                clusterItem.mapUser = mapuser;
                clusterItem.logo_thumb = mapuser.logo_thumb;
                clusterItem.logo = mapuser.logo;
//                [_clusterManager addClusterItem:clusterItem];
                [shopsArray addObject:clusterItem];
            }
        }
            NSDictionary *parameters = @{
                                         @"data":@{
                                                 @"jmid":[BFUserLoginManager shardManager].jmId,
                                                 @"longitude":@(coordinate.longitude),
                                                 @"latitude":@(coordinate.latitude),
                                                 @"target":@(typeindex),
                                                 }
                                         };
            [BFOriginNetWorkingTool postWithURLString:JM_MAP_NEARBY parameters:parameters success:^(NSDictionary *responseObject) {
                NSLog(@"%@",responseObject);
                NSMutableArray *userArray = [responseObject[@"data"] objectForKey:@"users"];
                if (userArray.count != 0) {
                    for (int i = 0; i < userArray.count; i ++) {

                        NSDictionary *dic = userArray[i];
                        if (![dic isKindOfClass:[NSDictionary class]]){
                            continue;
                        }
                        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue],[dic[@"longitude"] doubleValue]);
                        MapUserItem *user = [MapUserItem yy_modelWithDictionary:dic];
                        
                        BFMapItemModel *clusterItem = [[BFMapItemModel alloc] init];
                        clusterItem.coor = coor;
                        clusterItem.isShop = NO;
                        clusterItem.dicData = dic;
                        clusterItem.user = user;
                        clusterItem.logo = dic[@"photo"];
//                        [_clusterManager addClusterItem:clusterItem];
                        [usersArray addObject:clusterItem];
                        
                    }

                }
                completionHandler(shopsArray,usersArray,nil);
            } failure:^(NSError *error) {
            }];
//        }
    } failure:^(NSError *error) {
        //
        completionHandler(nil,nil,error);
    }];
}


+ (void)getNearbyUserLocate:(CLLocationCoordinate2D)coordinate type:(NSInteger)typeindex completionHandler:(void(^)(NSMutableArray *users, NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":[BFUserLoginManager shardManager].jmId,
                                         @"longitude":@(coordinate.longitude),
                                         @"latitude":@(coordinate.latitude),
                                         @"target":@(typeindex),
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JM_MAP_NEARBY parameters:parameters success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *usersArray = [NSMutableArray array];
        NSMutableArray *userArray = [responseObject[@"data"] objectForKey:@"users"];
        if (userArray.count != 0) {
            for (int i = 0; i < userArray.count; i ++) {
                NSDictionary *dic = userArray[i];
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue],[dic[@"longitude"] doubleValue]);
                MapUserItem *user = [MapUserItem yy_modelWithDictionary:dic];
                BFMapItemModel *clusterItem = [[BFMapItemModel alloc] init];
                clusterItem.coor = coor;
                clusterItem.isShop = NO;
                clusterItem.dicData = dic;
                clusterItem.user = user;
                clusterItem.logo = dic[@"photo"];
                //                        [_clusterManager addClusterItem:clusterItem];
                [usersArray addObject:clusterItem];
                
            }
        }
        completionHandler(usersArray,nil);

    } failure:^(NSError *error) {
        completionHandler(nil,error);

    }];
    
}


+ (void)getNearbyMerchantsLocate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(NSMutableArray *users, NSError *error))completionHandler{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/geosearch/v3/nearby?mcode=com.bofu.BFTest&ak=%@&geotable_id=%d&location=%f,%f&radius=150000",BAIDUMAP_ACCESSKEY,BDMERCHANT_ID,coordinate.longitude,coordinate.latitude];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [BFOriginNetWorkingTool getWithURLString:urlStr parameters:nil success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *contentsArray = responseObject[@"contents"];
        NSMutableArray *shopsArray = [NSMutableArray array];
        if (contentsArray.count != 0) {
            for (int i = 0; i < contentsArray.count; i ++) {
                NSDictionary *seller = contentsArray[i];
                BFMapUserInfo *mapuser = [BFMapUserInfo configureMapInfoWithdic:seller];
                NSArray *coordinate = mapuser.location;
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([coordinate[1] doubleValue],[coordinate[0] doubleValue]);
                BFMapItemModel *clusterItem = [[BFMapItemModel alloc] init];
                clusterItem.coor = coor;
                clusterItem.isShop = YES;
                clusterItem.shop_id = mapuser.shop_id;
                //                clusterItem.mapUser = mapuser;
                clusterItem.logo_thumb = mapuser.logo_thumb;
                clusterItem.logo = mapuser.logo;
                //                [_clusterManager addClusterItem:clusterItem];
                [shopsArray addObject:clusterItem];
            }
        }
        completionHandler(shopsArray,nil);

    } failure:^(NSError *error) {
        //
        completionHandler(nil,error);

    }];
    
}

+ (void)insertGPSWithCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(NSString *code, NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":[BFUserLoginManager shardManager].jmId,
                                         @"longitude":@(coordinate.longitude),
                                         @"latitude":@(coordinate.latitude),
                                         }
                                 };
    NSLog(@"%@",parameters);
    [BFOriginNetWorkingTool postWithURLString:JM_MAP_ADDGPS parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *meta = responseObject[@"meta"];
        NSString *code = meta[@"code"];
        completionHandler(code,nil);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
    
}

+ (void)searchNearbyUserLocate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(NSMutableArray *users, NSError *error))completionHandler{
    NSString *minAge;
    NSString *maxAge;
    NSInteger target = 0;
    NSString *shieldFrid;
    NSDictionary *dic = [BFChatHelper getDataFromDB:@"BoSetting"];
    NSLog(@"%@",dic);
    if (dic && dic[@"selectSex"]) {
        
        NSString *sexstr = dic[@"selectSex"];
        if ([sexstr isEqualToString:@"女"]) {
            target = 1;
        }else if ([sexstr isEqualToString:@"男"]){
            target = 0;
        }else{
            target = 3;
        }
        minAge = dic[@"ageonestr"];
        maxAge = dic[@"agetwostr"];
        shieldFrid = dic[@"shieldFrid"];
    }else{
        NSString *gender = [BFUserLoginManager shardManager].sex;
        target = ![gender intValue];
        minAge = @"16";
        maxAge = @"50";
        shieldFrid = @"0";
    }
    
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":[BFUserLoginManager shardManager].jmId,
                                         @"longitude":@(coordinate.longitude),
                                         @"latitude":@(coordinate.latitude),
                                         @"target":@(target),
                                         @"minAge":minAge,
                                         @"maxAge":maxAge,
                                         @"contractMask":@1,
                                         @"friendMask":shieldFrid,
                                         @"page":@1,
                                         }
                                 };
    [BFOriginNetWorkingTool postWithURLString:JM_MAP_SEARCHUSER parameters:parameters success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *userArray = [responseObject[@"data"] objectForKey:@"users"];
        if (userArray.count != 0) {
            completionHandler(userArray,nil);
        }

    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)likeOrnotUser:(NSString *)jmid likeorNot:(BOOL)like completionHandler:(void(^)(NSString *code, NSError *error))completionHandler{
    NSString *likeEachOtherFocus;
    NSDictionary *dic = [BFChatHelper getDataFromDB:@"BoSetting"];
    if (dic && dic[@"selectSex"]) {
        likeEachOtherFocus = dic[@"likeEachOtherFocus"];
    }

    
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":[BFUserLoginManager shardManager].jmId,
                                         @"relationJmid":jmid,
                                         @"followAtLike":likeEachOtherFocus,
                                         }
                                 };
    NSString *urlstr = like ? JM_MAP_BODISLIKE : JM_MAP_BOLIKE;
    [BFOriginNetWorkingTool postWithURLString:urlstr parameters:parameters success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

+ (void)requestForUserInfo:(NSString *)otherjm completionHandler:(void(^)(BFUserInfoModel *model, NSError *error))completionHandler{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"jmid":[BFUserLoginManager shardManager].jmId,
                                         @"otherJmid":otherjm,
                                         }
                                 };
    
    [BFOriginNetWorkingTool postWithURLString:JM_USER_GETUSERINFO parameters:parameters success:^(NSDictionary *responseObject) {
        NSDictionary *userdic = [responseObject objectForKey:@"data"];
        NSLog(@"%@",userdic);
        BFUserInfoModel *usermodel = [BFUserInfoModel yy_modelWithDictionary:userdic];
        
        completionHandler(usermodel,nil);
        
    } failure:^(NSError *error) {
        completionHandler(nil,error);
    }];
}

@end
