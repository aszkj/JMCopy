//
//  BFClusterView.h
//  BFTest
//
//  Created by 伯符 on 16/9/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFMapItemModel.h"
@protocol BFClusterViewDelete <NSObject>

- (void)clusterDeleteClick:(id)object;

- (void)didSelectedMapModelItem:(BFMapItemModel *)model;

@end
@interface BFClusterView : UIView


@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,strong) UICollectionView *itemsView;

@property (nonatomic,assign) id<BFClusterViewDelete> delegate;

- (void)showMapAlertView;

@end
