//
//  BFMapAlertView.h
//  BFTest
//
//  Created by 伯符 on 16/8/4.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, AlertviewButtonType)
{
    AlertviewButtonTypeDelete = 0,
    AlertviewButtonTypeStartPay,
    AlertviewButtonTypeStartUse,
    AlertviewButtonTypeHaveUse,
    AlertviewButtonTypeRefund,
};
@protocol BFMapAlertViewDelete <NSObject>

- (void)alertViewBtnClick:(UIButton *)object;

- (void)selectedRow:(NSInteger)rowIndex;

@end

@interface BFMapAlertView : UIView

@property (nonatomic,strong) NSDictionary *sellDic;

@property (nonatomic,strong) UITableView *sellView;

@property (nonatomic,assign) id<BFMapAlertViewDelete> delegate;


- (void)showMapAlertView;

@end
