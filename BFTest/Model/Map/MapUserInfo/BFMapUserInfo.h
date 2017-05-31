//
//  BFMapUserInfo.h
//  BFTest
//
//  Created by 伯符 on 16/7/21.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
@interface BFMapUserInfo : NSObject

@property (nonatomic,copy)   NSString *address;
@property (nonatomic,copy)   NSString *category;
@property (nonatomic,copy)   NSString *category_parent;
@property (nonatomic,copy)   NSString *city;
@property (nonatomic,copy)   NSString *coord_type;
@property (nonatomic,copy)   NSString *create_time;
@property (nonatomic,copy)   NSString *direction;
@property (nonatomic,assign)   int distance;
@property (nonatomic,copy)   NSString *district;
@property (nonatomic,copy)   NSString *geotable_id;
@property (nonatomic,strong) NSArray *location;
@property (nonatomic,copy)   NSString *logo;
@property (nonatomic,copy)   NSString *logo_thumb;
@property (nonatomic,copy)   NSString *modify_time;

@property (nonatomic,copy)   NSString *province;
@property (nonatomic,assign)   NSInteger shop_id;
//@property (nonatomic,copy)   NSString *tags;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,assign)   NSInteger type;
@property (nonatomic,copy)   NSString *uid;
@property (nonatomic,assign)   int weight;

- (instancetype)initUserMapInfoWithdic:(NSDictionary *)dic;

+ (instancetype)configureMapInfoWithdic:(NSDictionary *)dic;

@end


@interface BFUserInfo : NSObject


@property (nonatomic,copy)   NSString *nums_fans;
@property (nonatomic,copy)   NSString *nums_focus;
@property (nonatomic,copy)   NSString *nums_likeme;
@property (nonatomic,copy)   NSString *robot;
@property (nonatomic,copy)   NSString *grade_value;
@property (nonatomic,copy)   NSString *grade_vip;

@property (nonatomic,copy)   NSString *constellation;
@property (nonatomic,copy)   NSString *emotionalstate;
@property (nonatomic,copy)   NSString *ilikeaddress;
@property (nonatomic,copy)   NSString *address;

@property (nonatomic,copy)   NSString *industry;
@property (nonatomic,copy)   NSString *interest;
@property (nonatomic,copy)   NSString *jmid;
@property (nonatomic,copy)   NSString *jmlocation;
@property (nonatomic,copy)   NSString *lasttime;
@property (nonatomic,copy)   NSString *liveaddress;
@property (nonatomic,copy)   NSString *mybmp;
@property (nonatomic,copy)   NSString *name;
@property (nonatomic,copy)   NSString *nikename;
@property (nonatomic,copy)   NSString *occupation;

@property (nonatomic,copy)   NSString *otherbmp;
@property (nonatomic,copy)   NSString *school;
@property (nonatomic,copy)   NSString *sex;
@property (nonatomic,copy)   NSString *signature;
@property (nonatomic,copy)   NSString *grade;
@property (nonatomic,copy)   NSString *vip;
@property (nonatomic,copy)   NSString *years;
@property (nonatomic,copy)   NSString *birthday;


- (instancetype)initUserInfoWithdic:(NSDictionary *)dic;

+ (instancetype)configureInfoWithdic:(NSDictionary *)dic;

@end
