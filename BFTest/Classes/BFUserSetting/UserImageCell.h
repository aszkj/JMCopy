//
//  UserImageCell.h
//  BFTest
//
//  Created by 伯符 on 16/10/24.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACollectionViewReorderableTripletLayout.h"

@class RACollectionViewCell,UserImageCell;

@protocol SelectPhotoDelegate <NSObject>

- (void)selectPhotoWith:(RACollectionViewCell *)collectCell atIndex:(NSInteger)indextag userImageCell:(UserImageCell *)imgCell;

@end

@interface UserImageCell : UITableViewCell<RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource>

@property (nonatomic,strong) UICollectionView *headerView;

@property (nonatomic,strong) NSMutableArray *pictures;

@property (nonatomic,assign) id <SelectPhotoDelegate> delegate;

@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,strong) void(^NewArrayBlock)(NSMutableArray *array);

@end
