//
//  BFTabbar.h
//  BFTest
//
//  Created by 伯符 on 16/6/1.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFTabbarDelegate <NSObject>

- (void)selectIndex:(NSInteger)integer;

@end

@interface BFTabbar : UIView

@property (nonatomic,assign)id <BFTabbarDelegate> delegate;

@property (nonatomic,assign) NSInteger dtNum;

- (instancetype)initWithFrame:(CGRect)frame itemsArray:(NSArray *)items;

- (void)showMesgIconNum:(NSInteger)number;

- (void)showDTIconNum;

- (void)hideDTNum;
@end
