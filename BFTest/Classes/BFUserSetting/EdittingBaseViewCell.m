//
//  EdittingBaseViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "EdittingBaseViewCell.h"

@implementation EdittingBaseViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, 10*ScreenRatio, 200*ScreenRatio, 20*ScreenRatio)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = BFFontOfSize(14);
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width - UserCellMargin - 90, 10 *ScreenRatio , 90, 20*ScreenRatio)];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.textColor = [UIColor blackColor];
        self.detailLabel.font = BFFontOfSize(15);
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.hidden = YES;
        
        self.markImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marklogo"]];
        self.markImg.frame = CGRectMake(Screen_width - UserCellMargin - 20, 15*ScreenRatio, 17*ScreenRatio, 13*ScreenRatio);
        self.markImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.markImg];
        self.markImg.hidden = YES;
        
        self.isSelected = NO;
        
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.markImg.hidden = NO;
    }else{
        self.titleLabel.font = BFFontOfSize(14);
        self.markImg.hidden = YES;
    }
}


@end


@implementation PrivacyBaseViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, 5*ScreenRatio, 200*ScreenRatio, 20*ScreenRatio)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = BFFontOfSize(16);
        [self.contentView addSubview:self.titleLabel];
        
        self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, CGRectGetMaxY(self.titleLabel.frame)+3*ScreenRatio , Screen_width - UserCellMargin*2, 15*ScreenRatio)];
        self.subLabel.textAlignment = NSTextAlignmentLeft;
        self.subLabel.textColor = [UIColor lightGrayColor];
        self.subLabel.font = BFFontOfSize(13);
        [self.contentView addSubview:self.subLabel];
        
        self.markImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marklogo"]];
        self.markImg.frame = CGRectMake(Screen_width - UserCellMargin - 20, 15*ScreenRatio, 17*ScreenRatio, 13*ScreenRatio);
        self.markImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.markImg];
        self.markImg.hidden = YES;
        
        self.isSelected = NO;
        
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.subLabel.font = BFFontOfSize(14);

        self.markImg.hidden = NO;
    }else{
        self.titleLabel.font = BFFontOfSize(16);
        self.subLabel.font = BFFontOfSize(13);

        self.markImg.hidden = YES;
    }
}


@end
