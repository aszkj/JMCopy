//
//  BFClusterAnnotationView.h
//  BFTest
//
//  Created by 伯符 on 16/8/8.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BFClusterAnnotationView : BMKPinAnnotationView

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) BOOL isShop;

@end
