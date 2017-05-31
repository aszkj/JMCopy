//
//  BFPhotoPicker.h
//  BFTest
//
//  Created by 伯符 on 16/7/7.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BFPhotoPickerDelegate <NSObject>

- (void)sendPicture:(NSMutableArray *)imgArray;

- (void)photoAccessibleAlert;

@end

@interface BFPhotoPicker : UIView

@property (nonatomic,assign) id<BFPhotoPickerDelegate> delegate;

@end
