//
//  BFDiscountCoupon.h
//  BFTest
//
//  Created by 伯符 on 2017/5/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFCouponDelete <NSObject>

- (void)couponDeleteClick:(id)object;

@end

@interface BFDiscountCoupon : UITableView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) id<BFCouponDelete> userDelegate;

- (void)showMapAlertView;

@end
