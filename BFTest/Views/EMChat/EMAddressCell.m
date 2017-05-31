//
//  EMAddressCell.m
//  BFTest
//
//  Created by 伯符 on 16/11/9.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "EMAddressCell.h"

@interface EMAddressCell ()


@end

@implementation EMAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9*ScreenRatio, 37*ScreenRatio, 37*ScreenRatio)];
        self.headImg.contentMode = UIViewContentModeScaleAspectFill;
        self.headImg.clipsToBounds = YES;
        [self.contentView addSubview:self.headImg];
        
        self.guanzhu = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImg.frame)+7, 17*ScreenRatio, 190*ScreenRatio, 20)];
        self.guanzhu.textAlignment = NSTextAlignmentLeft;
        self.guanzhu.textColor = [UIColor blackColor];
        self.guanzhu.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:self.guanzhu];
        
        
    }
    return self;
}

@end
