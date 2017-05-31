//
//  BFPhotoPickerController.m
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFPhotoPickerController.h"
#import "BFAssetCollectionController.h"
#import "BFNavigationController.h"
@interface BFPhotoPickerController ()
@property (nonatomic,strong) BFNavigationController *assetNavigationController;
@end

@implementation BFPhotoPickerController

- (instancetype)init{
    if (self = [super init]) {
        self.assetCollectionSubtypes = @[
                                         @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                         @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                         @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                         @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                         @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                         
                                         ];
        self.minimumNumberOfSelection = 1;
        self.numberOfColumnsInPortrait = 4;
        self.numberOfColumnsInLandscape = 7;
        [self setUpAlbumsViewController];
        
        BFAssetCollectionController *albumsViewController = (BFAssetCollectionController *)self.assetNavigationController.topViewController;
        albumsViewController.imagePickerController = self;

    }
    return self;
}

- (void)setUpAlbumsViewController
{
    // Add QBAlbumsViewController as a child
    UICollectionViewFlowLayout *collectionFlow = [[UICollectionViewFlowLayout alloc]init];
    collectionFlow.itemSize = CGSizeMake(77.5, 77.5);
    collectionFlow.minimumLineSpacing = 2;
    collectionFlow.minimumInteritemSpacing = 2;
    BFAssetCollectionController *assetCollection = [[BFAssetCollectionController alloc]initWithCollectionViewLayout:collectionFlow];
    BFNavigationController *navigationController = [[BFNavigationController alloc]initWithRootViewController:assetCollection];
    
    [self addChildViewController:navigationController];
    
    navigationController.view.frame = self.view.bounds;
    [self.view addSubview:navigationController.view];
    
    [navigationController didMoveToParentViewController:self];
    
    self.assetNavigationController = navigationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
