//
//  BFMapUserInfo.m
//  BFTest
//
//  Created by 伯符 on 16/7/21.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFMapUserInfo.h"

@implementation BFMapUserInfo

- (instancetype)initUserMapInfoWithdic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)configureMapInfoWithdic:(NSDictionary *)dic{
    return [[self alloc]initUserMapInfoWithdic:dic];
    
}

@end

@implementation BFUserInfo

- (instancetype)initUserInfoWithdic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
//        self.constellation = dic[@"constellation"];
//        self.emotionalstate = dic[@"emotionalstate"];
//        self.grade = dic[@"grade"];
//        self.ilikeaddress = dic[@"ilikeaddress"];
//        self.industry = dic[@"industry"];
//        self.jmid = dic[@"jmid"];
//        self.jmlocation = dic[@"jmlocation"];
//        self.lasttime = dic[@"lasttime"];
//        self.liveaddress = dic[@"liveaddress"];
//        self.mybmp = dic[@"mybmp"];
//        self.name = dic[@"name"];
//        self.nikename = dic[@"nikename"];
//        self.occupation = dic[@"occupation"];
//        self.otherbmp = dic[@"otherbmp"];
//        self.school = dic[@"school"];
//        self.sex = dic[@"sex"];
//        self.signature = dic[@"signature"];
//        self.vip = dic[@"vip"];
//        self.years = dic[@"years"];
    }
    return self;
}

+ (instancetype)configureInfoWithdic:(NSDictionary *)dic{
    return [[self alloc]initUserInfoWithdic:dic];
}

@end
