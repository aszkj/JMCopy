//
//  BFPointAnnotation.h
//  BFTest
//
//  Created by 伯符 on 16/7/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface BFPointAnnotation : BMKPointAnnotation

@property (nonatomic, assign) NSInteger size;

@property (nonatomic,strong) NSDictionary *userInfo;

@property (nonatomic,strong) NSMutableArray *items;

@end
