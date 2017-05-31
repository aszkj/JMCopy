//
//  BFAssetCollectionController.m
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFAssetCollectionController.h"

#import "BFImgCollectionCell.h"
#import "BFPhotoAlbumController.h"
@interface BFAssetCollectionController ()<PHPhotoLibraryChangeObserver,UICollectionViewDelegateFlowLayout>{
    CGFloat albumListAnimateDuration;
    BOOL hasAuthorized;
}

@property (nonatomic,strong) PHFetchResult         *fetchResult;

@property (nonatomic,assign) BOOL disableScrollToBottom;

@property (nonatomic,copy) NSArray *fetchResults;
@property (nonatomic,copy) NSArray *assetCollections;

@property (nonatomic,strong) NSMutableArray *imgSelectArray;
@property (nonatomic,strong) PHCachingImageManager *imageManager;

@property (nonatomic,strong) NSIndexPath  *lastSelectedItemIndexPath;

@property (nonatomic,strong) NSMutableArray *collectAssetArray;

@end

@implementation BFAssetCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)imgSelectArray{
    if (!_imgSelectArray) {
        _imgSelectArray = [NSMutableArray array];
    }
    return _imgSelectArray;
}

- (NSMutableArray *)collectAssetArray{
    if (!_collectAssetArray) {
        _collectAssetArray = [NSMutableArray array];
    }
    return _collectAssetArray;
}

- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    
    return _imageManager;
}

#pragma mark - Accessors

- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
    [self updateFetchRequest];
    [self.collectionView reloadData];
}

- (BOOL)isAutoDeselectEnabled
{
    return (self.imagePickerController.maximumNumberOfSelection == 1
            && self.imagePickerController.maximumNumberOfSelection >= self.imagePickerController.minimumNumberOfSelection);
}

- (BOOL)isMaximumSelectionLimitReached
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.imagePickerController.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
        return (self.imagePickerController.maximumNumberOfSelection <= self.imagePickerController.selectedAssets.count);
    }
    
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure collection view
    self.collectionView.allowsMultipleSelection = self.imagePickerController.allowsMultipleSelection;
    self.collectionView.userInteractionEnabled = YES;
    
    [self.collectionView reloadData];
    
    // Scroll to bottom
    [self scrollToBottomAnimated:NO];
    
//    if(self.toolBarView) {
//        [self.toolBarView SwitchToMode:RTImagePickerToolbarModeImagePicker];
//    }
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.disableScrollToBottom = YES;
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.disableScrollToBottom = NO;
    
//    [self updateCachedAssets];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    [self addbottomBar];
//    albumListAnimateDuration = 0.3f;
    hasAuthorized = NO;
    
    [self.collectionView registerClass:[BFImgCollectionCell class] forCellWithReuseIdentifier:@"AssetCell"];
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hasAuthorized = YES;
                        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                        PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                        self.fetchResults = @[smartAlbums, userAlbums];
                        
                        [self updateAssetCollections];
//                        [self resetCachedAssets];
                        
                        // Configure collection view
                        self.collectionView.allowsMultipleSelection = self.imagePickerController.allowsMultipleSelection;
                        
                        [self.collectionView reloadData];
                        
                        // Scroll to bottom
                        [self scrollToBottomAnimated:NO];
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
            PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
            PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
            self.fetchResults = @[smartAlbums, userAlbums];
            
//            titleButton = [[RTImagePickerTitleButton alloc]initWithFrame:_titleView.bounds];
//            [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [self.titleView addSubview:titleButton];
            
            [self updateAssetCollections];
//            [self resetCachedAssets];
            
        }
            break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
        {
//            [self UnAuthorizedViewHidden:NO];
        }
            break;
    }
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 底部发送框

- (void)addbottomBar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_height - 40*ScreenRatio, Screen_width, 40*ScreenRatio)];
    view.backgroundColor = [UIColor lightGrayColor];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(Screen_width - 50*ScreenRatio, 5*ScreenRatio, 45*ScreenRatio, 30*ScreenRatio);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendPicture:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sendBtn];
    [self.view addSubview:view];
}

#pragma mark - 发送图片

- (void)sendPicture:(UIButton *)btn{
    
    // 在相册内选择图片发送  点击后跳转到聊天界面
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.imagePickerController.delegate respondsToSelector:@selector(bfPickerController:didFinishPickingImages:)]) {
        [self.imagePickerController.delegate bfPickerController:self.imagePickerController didFinishPickingImages:self.imgSelectArray];
    }
    
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
}

#pragma mark - 左返回按钮 跳转所有相册
- (void)addLeftBackItem{
    self.title = @"所有相片";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backClick:(UIBarButtonItem *)btnItem{
    NSLog(@"wwwww");
    BFPhotoAlbumController *photoAlbum = [[BFPhotoAlbumController alloc]init];
    
    photoAlbum.albumArray = self.assetCollections;
    photoAlbum.mediaType = self.imagePickerController.mediaType;
    photoAlbum.collectionView = self;
    [self.navigationController pushViewController:photoAlbum animated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Save indexPath for the last item
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    // Update layout
    [self.collectionViewLayout invalidateLayout];
    
    // Restore scroll position
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.fetchResult) {
        return self.fetchResult.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BFImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.showsOverlayViewWhenSelected = self.imagePickerController.allowsMultipleSelection;
    
    // Image
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
    
    // Video indicator
    /*
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        cell.videoIndicatorView.hidden = NO;
        
        NSInteger minutes = (NSInteger)(asset.duration / 60.0);
        NSInteger seconds = (NSInteger)ceil(asset.duration - 60.0 * (double)minutes);
        cell.videoIndicatorView.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
        
        if (asset.mediaSubtypes & PHAssetMediaSubtypeVideoHighFrameRate) {
            cell.videoIndicatorView.videoIcon.hidden = YES;
        }
        else {
            cell.videoIndicatorView.videoIcon.hidden = NO;
        }
    } else {
        cell.videoIndicatorView.hidden = YES;
    }
     */
    
    // Selection state
    if ([self.imagePickerController.selectedAssets containsObject:asset]) {
        [cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numberOfColumns = self.imagePickerController.numberOfColumnsInPortrait;
    
    CGFloat width = (self.view.width - 2.0 * (numberOfColumns - 1)) / numberOfColumns;
    
    return CGSizeMake(width, width);
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.imagePickerController.delegate respondsToSelector:@selector(bfimagePickerController:shouldSelectAsset:)]) {
        PHAsset *asset = self.fetchResult[indexPath.item];
        return [self.imagePickerController.delegate bfimagePickerController:self.imagePickerController shouldSelectAsset:asset];
    }
    
    if ([self isAutoDeselectEnabled]) {
        return YES;
    }
    
//    BOOL flag = [self isMaximumSelectionLimitReached];
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    BFPhotoPickerController *imagePickerController = self.imagePickerController;
//    NSMutableOrderedSet *selectedAssets = imagePickerController.selectedAssets;
    
    PHAsset *asset = self.fetchResult[indexPath.item];
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    PHImageRequestOptions *imgoption = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    imgoption.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:imgoption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result != nil) {
            [self.imgSelectArray addObject:result];
        }
    }];
//    [self.collectAssetArray addObject:asset];
    
    
//    if ([imagePickerController.delegate respondsToSelector:@selector(bfPickerController:didFinishPickingAssets:)]) {
//            [imagePickerController.delegate bfPickerController:imagePickerController didFinishPickingAssets:@[asset]];
//        }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didDeselectItemAtIndexPath");
    PHAsset *asset = self.fetchResult[indexPath.item];
    
    [self.collectAssetArray removeObject:asset];
}

- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = self.imagePickerController.assetCollectionSubtypes;
    
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            NSLog(@"%@",assetCollection);
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            NSLog(@"%ld",subtype);
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
    NSLog(@"%@",smartAlbums);
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    NSLog(@"%@",assetCollections);
    
    self.assetCollections = assetCollections;
    self.assetCollection = (PHAssetCollection *)self.assetCollections[0];
    
//    [titleButton rt_setTitle:[NSString stringWithFormat:@"%@",self.assetCollection.localizedTitle] arrowAppearance:YES];
    
//    if(!self.albumsTableView) {
//        self.albumsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, -ScreenHeight, ScreenWidth, ScreenHeight - self.navigationController.navigationBar.height) style:UITableViewStylePlain];
//        _albumsTableView.delegate = self;
//        _albumsTableView.dataSource = self;
//        _albumsTableView.backgroundColor = [UIColor blackColor];
//        _albumsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        [self.view addSubview:_albumsTableView];
//    }
    [self.collectionView reloadData];
}

- (void)updateFetchRequest
{
    if (!hasAuthorized) { return; }
    
    if (self.assetCollection) {
        PHFetchOptions *options = [PHFetchOptions new];
        
        switch (self.imagePickerController.mediaType) {
            case RTImagePickerMediaTypeImage:
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                break;
                
            case RTImagePickerMediaTypeVideo:
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
                break;
                
            default:
                break;
        }
        
        self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];

        if ([self isAutoDeselectEnabled] && self.imagePickerController.selectedAssets.count > 0) {
            // Get index of previous selected asset
            PHAsset *asset = [self.imagePickerController.selectedAssets firstObject];
            
            NSInteger assetIndex = [self.fetchResult indexOfObject:asset];
            self.lastSelectedItemIndexPath = [NSIndexPath indexPathForItem:assetIndex inSection:0];
        }
    } else {
        self.fetchResult = nil;
    }
}

#pragma mark - Asset Caching

/*
- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}
 */

/*
- (void)UnAuthorizedViewHidden:(BOOL)hidden
{
    if(!self.unAuthorizedView) {
        self.unAuthorizedView = [[RTImagePickerUnauthorizedView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight - self.toolBarView.height)];
        _unAuthorizedView.permissionTitleLabel.text = @"Flow想开启你的相册";
        _unAuthorizedView.onPermissionButton = ^(){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        };
        _unAuthorizedView.alpha = 0.0f;
        _unAuthorizedView.hidden = YES;
        [self.view addSubview:_unAuthorizedView];
    }
    
    if(hidden) {
        _unAuthorizedView.hidden = NO;
        [UIView animateWithDuration:0.4f animations:^{
            _unAuthorizedView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            _unAuthorizedView.hidden = YES;
        }];
    } else {
        _unAuthorizedView.hidden = YES;
        [UIView animateWithDuration:0.4f animations:^{
            _unAuthorizedView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            _unAuthorizedView.hidden = NO;
        }];
    }
}
 */
- (void)scrollToBottomAnimated:(BOOL)animated
{
    if(self.fetchResult) {
        if (self.fetchResult.count > 0 && !self.disableScrollToBottom) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.fetchResult.count - 1) inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
        }
    }
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    
}


@end
