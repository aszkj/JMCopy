//
//  MyCouponModel.h
//  BFTest
//
//  Created by 伯符 on 16/12/23.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCouponModel : NSObject

@property (nonatomic,copy) NSString *expire_date;
@property (nonatomic,copy) NSString *item_name;
@property (nonatomic,copy) NSString *order_number;
@property (nonatomic,copy) NSString *photo_1;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *shop_name;
@property (nonatomic,copy) NSString *token_number;
@property (nonatomic,copy) NSString *cut;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *promotion_type;
@property (nonatomic,copy) NSString *coupon_name;


- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;

@end
