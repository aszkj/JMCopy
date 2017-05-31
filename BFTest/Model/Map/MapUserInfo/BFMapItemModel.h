//
//  BFMapItemModel.h
//  BFTest
//
//  Created by 伯符 on 16/11/8.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BMKClusterItem.h"
#import "BFMapUserInfo.h"
#import "MapUserItem.h"
@interface BFMapItemModel : BMKClusterItem

//@property (nonatomic,strong) BFMapUserInfo *mapUser;

@property (nonatomic,strong) NSDictionary *dicData;

@property (nonatomic,copy) NSString *logo_thumb;

@property (nonatomic,copy) NSString *logo;

@property (nonatomic,assign) NSInteger shop_id;

@property (nonatomic,assign) BOOL isShop;

@property (nonatomic,strong) NSArray *location;

@property (nonatomic,strong) MapUserItem *user;

@end
