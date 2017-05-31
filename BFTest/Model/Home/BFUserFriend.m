//
//  BFUserFriend.m
//  BFTest
//
//  Created by 伯符 on 16/6/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFUserFriend.h"

@implementation BFUserFriend

- (instancetype)initModelWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ID = [dic[@"ID"]integerValue];
        self.name = dic[@"name"];
        self.nikename = dic[@"nikename"];
        self.pass = dic[@"pass"];
        self.useridtwo = dic[@"useridtwo"];
        self.mybmp = dic[@"mybmp"];
    }
    return self;
}

+ (instancetype)configureModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initModelWithDic:dic];
}

@end

@implementation BFSearchFrid

- (instancetype)initModelWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.nikename = dic[@"nikename"];
        self.jmid = dic[@"jmid"];
        self.mybmp = dic[@"mybmp"];
    }
    return self;
}

+ (instancetype)configureModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initModelWithDic:dic];
}

@end
