//
//  BFPhotoPickerController.h
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

@class BFPhotoPickerController;

@protocol BFPhotoPickerControllerDelegate <NSObject>

@optional
- (void)bfPickerController:(BFPhotoPickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets;
- (void)bfPickerController:(BFPhotoPickerController *)imagePickerController didFinishPickingImages:(NSMutableArray<UIImage *> *)images;
- (void)bfPickerController:(BFPhotoPickerController *)imagePickerController didFinishPickingVideoWithFileName:(NSString *)fileName withCaptureImage:(UIImage *)image;
- (void)bfPickerControllerDidCancel:(BFPhotoPickerController *)imagePickerController;

- (BOOL)bfimagePickerController:(BFPhotoPickerController *)imagePickerController shouldSelectAsset:(PHAsset *)asset;
- (void)bfimagePickerController:(BFPhotoPickerController *)imagePickerController didSelectAsset:(PHAsset *)asset;
- (void)bfimagePickerController:(BFPhotoPickerController *)imagePickerController didDeselectAsset:(PHAsset *)asset;

@end

typedef NS_ENUM(NSUInteger, RTImagePickerMediaType) {
    RTImagePickerMediaTypeAny = 0,
    RTImagePickerMediaTypeImage,
    RTImagePickerMediaTypeVideo
};

@interface BFPhotoPickerController : UIViewController

@property (nonatomic, weak) id<BFPhotoPickerControllerDelegate>     delegate;

@property (nonatomic, strong, readonly) NSMutableOrderedSet *selectedAssets;


@property (nonatomic, copy) NSArray *assetCollectionSubtypes;

@property (nonatomic, assign) RTImagePickerMediaType mediaType;

@property (nonatomic, assign) BOOL  allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, assign) BOOL showsNumberOfSelectedAssets;

@property (nonatomic, assign) NSUInteger numberOfColumnsInPortrait;
@property (nonatomic, assign) NSUInteger numberOfColumnsInLandscape;

@end
