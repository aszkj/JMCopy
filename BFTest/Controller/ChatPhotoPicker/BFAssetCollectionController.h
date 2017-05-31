//
//  BFAssetCollectionController.h
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPhotoPickerController.h"
@interface BFAssetCollectionController : UICollectionViewController

@property (nonatomic, weak) BFPhotoPickerController *imagePickerController;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

- (void)scrollToBottomAnimated:(BOOL)animated;

@end
