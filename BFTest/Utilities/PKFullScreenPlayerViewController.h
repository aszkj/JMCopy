//
//  PKFullScreenPlayerViewController.h
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/4.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKFullScreenPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKFullScreenPlayerViewController : UIViewController

@property (nonatomic, strong) PKFullScreenPlayerView *playerView;

@property (nonatomic, strong) NSString *videoPath;

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithVideoPath:(NSString *)videoPath previewImage:(UIImage *)previewImage;

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap;

@end

NS_ASSUME_NONNULL_END
