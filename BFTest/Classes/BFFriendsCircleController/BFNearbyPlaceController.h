//
//  BFNearbyPlaceController.h
//  BFTest
//
//  Created by 伯符 on 16/12/23.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSString *str,CLLocationCoordinate2D currentLocationCoordinate);
@interface BFNearbyPlaceController : UITableViewController

@property (nonatomic,copy) selectBlock selectBlock;

@end
