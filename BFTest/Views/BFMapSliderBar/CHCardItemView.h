//
//  CHCardItemView.h
//  CHCardView
//
//  Created by yaoxin on 16/10/8.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHCardItemView, CHCardItemModel,BFMatchView;
@protocol CHCardItemViewDelegate <NSObject>
- (void)cardItemViewDidRemoveFromSuperView:(CHCardItemView *)cardItemView direction:(BOOL)isleft match:(BFMatchView *)matchview userModel:(CHCardItemModel *)model;
@end

@interface CHCardItemView : UIView
@property (nonatomic, weak) id <CHCardItemViewDelegate> delegate;
@property (nonatomic, strong) CHCardItemModel *itemModel;
@property (nonatomic, strong) BFMatchView *matchView;

- (void)removeWithLeft:(BOOL)left match:(BFMatchView *)matchview userMsg:(CHCardItemModel *)model;
@end
