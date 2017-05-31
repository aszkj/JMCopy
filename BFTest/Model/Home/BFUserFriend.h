//
//  BFUserFriend.h
//  BFTest
//
//  Created by 伯符 on 16/6/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFUserFriend : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *mybmp;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pass;
@property (nonatomic, copy) NSString *useridtwo;


- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;
@end

@interface BFSearchFrid : NSObject

@property (nonatomic, copy) NSString *mybmp;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *jmid;

- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;

@end
