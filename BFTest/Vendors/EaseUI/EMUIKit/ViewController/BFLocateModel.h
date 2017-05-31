//
//  BFLocateModel.h
//  BFTest
//
//  Created by 伯符 on 16/9/7.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFLocateModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *address;

@property (nonatomic) CLLocationCoordinate2D pt;

@end
