//
//  MapUserItem.h
//  BFTest
//
//  Created by 伯符 on 17/1/14.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapUserItem : NSObject


@property (nonatomic, copy) NSString *jmid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *vipGrade;
@property (nonatomic, copy) NSString *fromArea;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *datePlace;


- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;
@end
