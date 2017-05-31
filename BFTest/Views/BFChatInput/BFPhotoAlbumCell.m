//
//  BFPhotoAlbumCell.m
//  BFTest
//
//  Created by 伯符 on 16/7/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFPhotoAlbumCell.h"

@interface BFPhotoAlbumCell (){
    
    UIImageView *disclosureIndicatorView;

}

@end

@implementation BFPhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.clipsToBounds = YES;
    [self.contentView addSubview:self.photoView];
    
    self.photoTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.photoTitle.textColor = [UIColor blackColor];
    self.photoTitle.font = [UIFont systemFontOfSize:17.0f];
    self.photoTitle.textAlignment = NSTextAlignmentLeft;
    self.photoTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.photoTitle.numberOfLines = 1;
    [self.contentView addSubview:self.photoTitle];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    self.countLabel.font = [UIFont systemFontOfSize:12.0f];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.countLabel.numberOfLines = 1;
    [self.contentView addSubview:self.countLabel];
    
    disclosureIndicatorView = [[UIImageView alloc]initWithFrame:CGRectZero];
    disclosureIndicatorView.image = [UIImage imageNamed:@"rtimagepicker_indicator"];
    [self.contentView addSubview:disclosureIndicatorView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imageWidth = self.width/5.0f;
    self.imageView.frame = CGRectMake(5.0, 2.0, imageWidth, imageWidth);
    self.photoTitle.frame = CGRectMake(self.imageView.right + 30.0f, (self.height - 50.0f)/2.0f, Screen_width - self.imageView.right - 80.0f, 20.0f);
    self.countLabel.frame = CGRectMake(self.imageView.right + 30.0f, self.photoTitle.bottom + 15.0f, self.photoTitle.width, 15.0f);
    disclosureIndicatorView.frame = CGRectMake(self.width - 46.0f, (self.height - 46.0f)/2.0f, 46.0f, 46.0f);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
