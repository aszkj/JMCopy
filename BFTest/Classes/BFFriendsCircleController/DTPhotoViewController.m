//
//  DTPhotoViewController.m
//  BFTest
//
//  Created by 伯符 on 16/12/29.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "DTPhotoViewController.h"
#import <Photos/Photos.h>
#import "BFPhotoAlbumCell.h"
#import "BFImageCreatUtils.h"
#import "BFFriMediaClusterController.h"
@interface DTPhotoViewController ()

@property (nonatomic,copy) NSArray *fetchResults;

@property (nonatomic,copy) NSArray *assetCollections;

@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end

@implementation DTPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self getPhotoes];
}

- (void)backClick:(UIBarButtonItem *)backItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)getPhotoes{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                self.fetchResults = @[smartAlbums, userAlbums];
                
                [self updateAssetCollections];
                
            });
        } else {
        }
    }];

}

- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = @[
                                         @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                         @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                         @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                         @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                         
                                         ];
    
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
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
    self.assetCollections = assetCollections;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetCollections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BFPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoAlbumCell"];
    if (!cell) {
        cell = [[BFPhotoAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhotoAlbumCell"];
    }
    cell.tag = indexPath.row;
    
    // Thumbnail
    PHAssetCollection *assetCollection = self.assetCollections[indexPath.row];
    PHFetchOptions *options = [PHFetchOptions new];
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    PHImageManager *imgManager = [PHImageManager defaultManager];
    if (fetchResult.count >= 1) {
        [imgManager requestImageForAsset:fetchResult[fetchResult.count - 1] targetSize:CGSizeMake(80*[[UIScreen mainScreen]scale], 80*[[UIScreen mainScreen]scale]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (cell.tag == indexPath.row) {
                cell.imageView.image = result;
            }
        }];
    }else{
        cell.imageView.image = [BFImageCreatUtils placeholderImageWithSize:CGSizeMake(60, 60)];
    }
    // Album title
    cell.photoTitle.text = assetCollection.localizedTitle;
    
    // Number of photos
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (long)fetchResult.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.fridmediaVC.photovc.assetCollection = self.assetCollections[indexPath.row];
    [self.fridmediaVC titleTapToAlbum:self.titleBtn];
}



@end
