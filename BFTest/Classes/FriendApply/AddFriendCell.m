/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "AddFriendCell.h"

@implementation AddFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(5*ScreenRatio, 5*ScreenRatio, 40 * ScreenRatio, 40 *ScreenRatio)];
        _iconImg.clipsToBounds = YES;
        _iconImg.layer.cornerRadius = 20*ScreenRatio;
        [self.contentView addSubview:_iconImg];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150*ScreenRatio, 25*ScreenRatio)];
        _nameLabel.center = CGPointMake(CGRectGetMaxX(_iconImg.frame)+150*ScreenRatio/2 + 7*ScreenRatio, 50*ScreenRatio/2);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = BFFontOfSize(15);
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}


@end
