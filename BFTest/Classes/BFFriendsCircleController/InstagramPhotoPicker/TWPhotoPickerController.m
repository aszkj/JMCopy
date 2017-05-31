//
//  TWPhotoPickerController.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "TWPhotoPickerController.h"
#import "TWPhotoCollectionViewCell.h"
#import "TWImageScrollView.h"
#import "EditDongtaiController.h"
#import "BFInterestController.h"
@interface TWPhotoPickerController ()<UICollectionViewDataSource, UICollectionViewDelegate,PHPhotoLibraryChangeObserver>
{
    CGFloat beginOriginY;
    BOOL hasAuthorized;

}
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) TWImageScrollView *imageScrollView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,copy) NSArray *fetchResults;
@property (nonatomic,copy) NSArray *assetCollections;
@property (nonatomic,strong) PHFetchResult         *fetchResult;
@property (nonatomic,strong) PHCachingImageManager *imageManager;
@property (nonatomic,strong) BFInterestController *interestVC;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@end

@implementation TWPhotoPickerController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];

}

- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    return _imageManager;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topView];
    [self.view insertSubview:self.collectionView belowSubview:self.topView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    hasAuthorized = NO;

    // Do any additional setup after loading the view.
    [self loadPhotos];
    [self collectionView:_collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

}

#pragma mark - Accessors

- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
    [self updateFetchRequest];
    [self.collectionView reloadData];
}

- (void)updateFetchRequest
{
    if (!hasAuthorized) { return; }
    
    if (self.assetCollection) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];
        
//        if ([self isAutoDeselectEnabled] && self.imagePickerController.selectedAssets.count > 0) {
//            // Get index of previous selected asset
//            PHAsset *asset = [self.imagePickerController.selectedAssets firstObject];
//            
//            NSInteger assetIndex = [self.fetchResult indexOfObject:asset];
//            self.lastSelectedItemIndexPath = [NSIndexPath indexPathForItem:assetIndex inSection:0];
//        }
    } else {
        self.fetchResult = nil;
    }
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void)loadPhotos {

    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hasAuthorized = YES;

                        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                        PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                        self.fetchResults = @[smartAlbums, userAlbums];
                        
                        [self updateAssetCollections];
                        //                        [self resetCachedAssets];
                        
                        [self.collectionView reloadData];
                        
                    });
                } else {
                    //                    [self UnAuthorizedViewHidden:NO];
                }
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            hasAuthorized = YES;
            PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            self.fetchResults = @[smartAlbums, userAlbums];

            [self updateAssetCollections];
            //            [self resetCachedAssets];
            
        }
            break;
        case PHAuthorizationStatusDenied:{

            [self showAlertViewTitle:@"请打开相册访问权限" message:nil];
        }
            
        case PHAuthorizationStatusRestricted:{
            NSLog(@"PHAuthorizationStatusRestricted");
        }

            break;
    }
    
}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = @[
                                        @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                         @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                         @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                         @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                        @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                         @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                         @(PHAssetCollectionSubtypeSmartAlbumScreenshots),
                                         ];
    
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            NSLog(@"%@",assetCollection);
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            NSLog(@"%ld",subtype);
//            if (subtype == PHAssetCollectionSubtypeAlbumRegular || subtype == PHAssetCollectionSubtypeSmartAlbumScreenshots) {
                [userAlbums addObject:assetCollection];
//            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
//                if (!smartAlbums[@(subtype)]) {
//                    smartAlbums[@(subtype)] = [NSMutableArray array];
//                }
//                [smartAlbums[@(subtype)] addObject:assetCollection];
//            }
        }];
    }
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
//    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
//        NSArray *collections = smartAlbums[assetCollectionSubtype];
//        
//        if (collections) {
//            [assetCollections addObjectsFromArray:collections];
//        }
//    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    NSLog(@"%@",assetCollections);
    
    self.assetCollections = assetCollections;
    self.assetCollection = (PHAssetCollection *)self.assetCollections[0];

    [self.collectionView reloadData];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIView *)topView {
    if (_topView == nil) {
        CGFloat handleHeight = 44.0f;
        CGRect rect = CGRectMake(0, 0, Screen_width, Screen_width);
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.backgroundColor = [UIColor blackColor];
        self.topView.clipsToBounds = YES;
        
        rect = CGRectMake(0, CGRectGetHeight(self.topView.bounds)-handleHeight, Screen_width, handleHeight);
        UIView *dragView = [[UIView alloc] initWithFrame:rect];
        dragView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        dragView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.topView addSubview:dragView];
        
        UIImage *img = [UIImage imageNamed:@"cameraroll-picker-grip"];
        rect = CGRectMake((CGRectGetWidth(dragView.bounds)-img.size.width)/2, (CGRectGetHeight(dragView.bounds)-img.size.height)/2, img.size.width, img.size.height);
        UIImageView *gripView = [[UIImageView alloc] initWithFrame:rect];
        gripView.image = img;
        [dragView addSubview:gripView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [dragView addGestureRecognizer:panGesture];
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
//        [dragView addGestureRecognizer:tapGesture];
//        [tapGesture requireGestureRecognizerToFail:panGesture];
        
        rect = CGRectMake(0, 0, Screen_width, CGRectGetHeight(self.topView.bounds)-handleHeight);
        self.imageScrollView = [[TWImageScrollView alloc] initWithFrame:rect];
        [self.topView addSubview:self.imageScrollView];
        [self.topView sendSubviewToBack:self.imageScrollView];
        
        self.maskView = [[UIImageView alloc] initWithFrame:rect];
        self.maskView.image = [UIImage imageNamed:@"straighten-grid"];
        [self.topView insertSubview:self.maskView aboveSubview:self.imageScrollView];
    }
    return _topView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat colum = 4.0, spacing = 2.0;
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing) / colum);
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        layout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.topView.frame), Screen_width, Screen_height-CGRectGetHeight(self.topView.bounds) - Tabbar_Height);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TWPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"TWPhotoCollectionViewCell"];

    }
    return _collectionView;
}


- (void)cropAction {
    if (self.cropBlock) {
//        self.cropBlock(self.imageScrollView.capture);
        EditDongtaiController *editvc = [[EditDongtaiController alloc]init];
        editvc.isImage = YES;
        editvc.sendImage = self.imageScrollView.capture;
        [self.navigationController pushViewController:editvc animated:YES];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect topFrame = self.topView.frame;
            CGFloat endOriginY = self.topView.frame.origin.y;
            NSLog(@"%lf ------ %lf",beginOriginY,endOriginY);
            if (endOriginY > beginOriginY) {
                topFrame.origin.y = (endOriginY - beginOriginY) >= 20 ? 0 : - CGRectGetHeight(self.topView.bounds) + NavBar_Height;
            } else if (endOriginY < beginOriginY) {
                topFrame.origin.y = (beginOriginY - endOriginY) >= NavBar_Height ? -(CGRectGetHeight(self.topView.bounds)-NavBar_Height) : 0;

            }
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = Screen_height - CGRectGetMaxY(topFrame) - 45*ScreenRatio - NavBar_Height;
            [UIView animateWithDuration:.3f animations:^{
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }];
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            beginOriginY = self.topView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            
            CGRect topFrame = self.topView.frame;
            topFrame.origin.y = translation.y + beginOriginY;
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame)- 45*ScreenRatio;
            if (topFrame.origin.y <= NavBar_Height && (topFrame.origin.y >= -(CGRectGetHeight(self.topView.bounds)))) {
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    CGRect topFrame = self.topView.frame;
    topFrame.origin.y = 0;
    
    CGRect collectionFrame = self.collectionView.frame;
    collectionFrame.origin.y = CGRectGetMaxY(topFrame);
    collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame) - 45*ScreenRatio;
    [UIView animateWithDuration:.3f animations:^{
        self.topView.frame = topFrame;
        self.collectionView.frame = collectionFrame;
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TWPhotoCollectionViewCell";
    
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.item;
    
    // Image
    if (self.fetchResult.count != 0) {
        PHAsset *asset = self.fetchResult[indexPath.item];
        CGSize itemSize = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout itemSize];
        CGSize targetSize = CGSizeMake(itemSize.width *[[UIScreen mainScreen] scale], itemSize.height *[[UIScreen mainScreen] scale]);
        [self.imageManager requestImageForAsset:asset
                                     targetSize:targetSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if (cell.tag == indexPath.item) {
                                          cell.imageView.image = result;
                                          
                                      }
                                  }];
    }
    
//    [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];

    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fetchResult.count > 0) {
        PHAsset *asset = self.fetchResult[indexPath.item];
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        PHImageRequestOptions *imgoption = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        imgoption.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:imgoption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result != nil) {
                [self.imageScrollView displayImage:result];
                if (self.topView.frame.origin.y != 0) {
                    [self tapGestureAction:nil];
                }
            }
        }];

    }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"velocity:%f", velocity.y);
    if (velocity.y >= 2.0 && self.topView.frame.origin.y == 0) {
        [self tapGestureAction:nil];
    }
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    
}

@end
