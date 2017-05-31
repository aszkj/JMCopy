//
//  BFScrollSelctView.h
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^SelectImgBlock)(UIImage *image);


@interface BFScrollSelctView : UIImageView

@property (nonatomic,assign) BOOL imgSelected;

@property (nonatomic,weak) UIButton *uprightBtn;

@property (nonatomic,copy) SelectImgBlock imgSelectBlock;

- (void)selectedImg:(SelectImgBlock)block;

@end
