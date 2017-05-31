//
//  RACollectionViewCell.h
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/27/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDProgressView.h"

@interface RACollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property(nonatomic,strong) SDPieLoopProgressView *progressView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat progress;

@end
