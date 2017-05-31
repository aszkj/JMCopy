//
//  BFInterestModel.m
//  BFTest
//
//  Created by 伯符 on 16/7/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFInterestModel.h"

@implementation BFInterestModel

- (instancetype)initModelWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)configureModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initModelWithDic:dic];

}

@end

@implementation BFCommentModel

- (instancetype)initModelWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)configureModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initModelWithDic:dic];
}

@end


@implementation BFFansModel

- (instancetype)initModelWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)configureModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initModelWithDic:dic];
}

@end

@implementation BFDtAlertModel

- (instancetype)initModelWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)configureModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initModelWithDic:dic];
}

@end

