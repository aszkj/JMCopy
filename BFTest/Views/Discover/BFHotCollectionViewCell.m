//
//  BFHotCollectionViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/8/4.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFHotCollectionViewCell.h"
@interface BFHotCollectionViewCell ()
@property (nonatomic,strong) UIImageView *videoImg;
@end
@implementation BFHotCollectionViewCell

- (UIImageView *)videoImg{
    if (!_videoImg) {
        _videoImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 20*ScreenRatio, 5*ScreenRatio, 15*ScreenRatio, 15*ScreenRatio)];
        _videoImg.image = [UIImage imageNamed:@"dtvideo"];
        _videoImg.contentMode = UIViewContentModeScaleToFill;
        _videoImg.clipsToBounds = YES;
    }
    return _videoImg;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        self.imgView.clipsToBounds = YES;
        [self.contentView addSubview:self.imgView];
        
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 25, self.width, 25)];
//        self.titleLabel.textAlignment = NSTextAlignmentLeft;
//        self.titleLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
//        self.titleLabel.font = BFFontOfSize(13);
//        self.titleLabel.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.titleLabel];
        
        self.tagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 5 - 30, 10, 30, 15)];
        self.tagImageView.layer.cornerRadius = 4;
        self.tagImageView.layer.masksToBounds = YES;
        self.tagImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.tagImageView];
        
        
    }
    return self;
}


- (void)setDic:(NSDictionary *)dic{
    if (dic[@"thumbnail"]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"thumbnail"]]];
    }
    if ([dic[@"type"] isEqualToString:@"V"]) {
        [self.contentView addSubview:self.videoImg];
    }else{
        [_videoImg removeFromSuperview];
        _videoImg = nil;
    }
}

@end
