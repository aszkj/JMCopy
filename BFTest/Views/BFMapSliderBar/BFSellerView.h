//
//  BFSellerView.h
//  BFTest
//
//  Created by 伯符 on 16/7/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BFSellerViewDelete <NSObject>

- (void)sellerDeleteClick:(id)object;

- (void)pushToDetail:(NSInteger)shopid;

@end
@interface BFSellerView : UIView

@property (nonatomic,strong) NSDictionary *sellDic;

@property (nonatomic,strong) UITableView *sellView;

@property (nonatomic,assign) NSInteger shop_id;

@property (nonatomic,assign) id<BFSellerViewDelete> delegate;


- (void)showMapAlertView;


@end
