//
//  BFPhotoAlbumController.h
//  BFTest
//
//  Created by 伯符 on 16/7/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "BFAssetCollectionController.h"

@interface BFPhotoAlbumController : UITableViewController

@property (nonatomic,strong) NSArray *albumArray;

@property (nonatomic,assign) NSUInteger mediaType;

@property (nonatomic,strong) BFAssetCollectionController *collectionView;
@end
