//
//  RACollectionViewCell.m
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/27/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

#import "RACollectionViewCell.h"

@interface RACollectionViewCell()

@end

@implementation RACollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _label = [[UILabel alloc]init];
        _progressView = [SDPieLoopProgressView progressView];
        _progressView.hidden = YES;
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_progressView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    if(progress == 1){
        _progressView.hidden = YES;
    }else{
        _progressView.hidden = NO;
    }
    _progress = progress;
    _progressView.progress = progress;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.imageView.frame = bounds;
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.label.frame = CGRectMake(10, 10, 50, 30);
    _progressView.size = CGSizeMake( 80, 80);
    _progressView.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    self.label.textColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _imageView.alpha = .7f;
    }else {
        _imageView.alpha = 1.f;
    }
}

@end
