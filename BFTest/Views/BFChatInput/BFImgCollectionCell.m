//
//  BFImgCollectionCell.m
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFImgCollectionCell.h"

@interface BFImgCollectionCell()

@property (nonatomic,strong) UIView *overlayView;
@property (nonatomic,strong) UIImageView *markView;
@end

@implementation BFImgCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        self.overlayView = [[UIView alloc]initWithFrame:self.bounds];
        self.overlayView.backgroundColor = [UIColor clearColor];
        [self.imageView addSubview:self.overlayView];
        self.overlayView.hidden = YES;
        
        self.markView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 25, 6, 15, 15)];
        self.markView.image = [UIImage imageNamed:@"norbutton"];
        [self.imageView addSubview:self.markView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.overlayView.backgroundColor = [UIColor darkGrayColor];
    self.overlayView.alpha = 0.6f;
    self.overlayView.hidden = ! selected;
    if (selected) {
        self.markView.image = [UIImage imageNamed:@"selbutton"];
    }else{
        self.markView.image = [UIImage imageNamed:@"norbutton"];
    }
}

@end
