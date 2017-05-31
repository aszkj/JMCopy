//
//  UserTableViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/21.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [UIColor lightGrayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.nameLabel];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.textColor = [UIColor blackColor];
        self.detailLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.detailLabel];
        
        UIImageView *arrows = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        arrows.frame = CGRectMake(Screen_width - 20, 10, 7, self.height - 20);
        arrows.contentMode = UIViewContentModeScaleAspectFit;
        arrows.clipsToBounds = NO;
        [self.contentView addSubview:arrows];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(9, 6, 100*ScreenRatio, self.height - 12);
    self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 19, 6, self.width - (CGRectGetMaxX(self.nameLabel.frame) + 19) - 20, self.height - 12);
    
}



@end
