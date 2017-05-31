//
//  MyCouponModel.m
//  BFTest
//
//  Created by 伯符 on 16/12/23.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "MyCouponModel.h"

@implementation MyCouponModel

- (instancetype)initModelWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)configureModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initModelWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
}



@end
