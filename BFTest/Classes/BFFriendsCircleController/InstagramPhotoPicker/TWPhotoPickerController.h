//
//  TWPhotoPickerController.h
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
@interface TWPhotoPickerController : UIViewController

@property (strong, nonatomic) NSMutableArray *assets;

@property (nonatomic, strong) PHAssetCollection *assetCollection;

@property (strong, nonatomic) UIImageView *maskView;

- (void)cropAction;

@property (nonatomic, copy) void(^cropBlock)(UIImage *image);

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
