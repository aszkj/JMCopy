//
//  BFDiscoverBottomView.h
//  BFTest
//
//  Created by 伯符 on 16/12/9.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DiscoverButtonType)
{
    DiscoverButtonTypeDynamic,
    DiscoverButtonTypeLive,
    DiscoverButtonTypeCha,
};

@protocol BFDiscoverBottomViewDelegate<NSObject>

- (void)discoverViewClick:(UIButton *)btn;

@end

@interface BFDiscoverBottomView : UIView

@property (nonatomic,assign) id <BFDiscoverBottomViewDelegate> delegate;

- (void)show;

- (void)resign;

@end
