//
//  BFPayAlertView.h
//  BFTest
//
//  Created by 伯符 on 16/12/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BalancePayWay)
{
    BalancePayWayWeixin,
    BalancePayWayAli,
};


@protocol BFStartedPayDelegate <NSObject>

- (void)starttoPay:(BalancePayWay)payWay;

@end
@interface BFPayAlertView : UIView

@property (nonatomic,assign) id <BFStartedPayDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame number:(CGFloat)num;

@end
