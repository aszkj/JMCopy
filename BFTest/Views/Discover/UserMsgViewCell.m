//
//  UserMsgViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserMsgViewCell.h"
@interface UserMsgViewCell(){
    UIView *bottomLine;
}
@end
@implementation UserMsgViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, 15, 100*ScreenRatio, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, CGRectGetMaxY(self.titleLabel.frame) + 15, Screen_width - UserCellMargin*2, 20)];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailLabel.textColor = [UIColor lightGrayColor];
        self.detailLabel.font = BFFontOfSize(15);
        [self.contentView addSubview:self.detailLabel];
        
        bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = BFColor(243, 243, 242, 1);
        [self.contentView addSubview:bottomLine];
    }
    return self;
}

- (void)setDetailStr:(NSString *)detailStr{
    _detailStr = detailStr;
    CGRect rect = [_detailStr boundingRectWithSize:CGSizeMake(self.detailLabel.width, 100*ScreenRatio) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:BFFontOfSize(15),NSForegroundColorAttributeName:[UIColor lightGrayColor]} context:nil];
    self.detailLabel.frame = CGRectMake(UserCellMargin, CGRectGetMaxY(self.titleLabel.frame) + 15, Screen_width - UserCellMargin*2, rect.size.height);
    self.detailLabel.text = _detailStr;
    bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.detailLabel.frame)+15, Screen_width, 0.5);
}


- (NSInteger)getMsgCellHeight{
    return CGRectGetMaxY(bottomLine.frame);
}

@end
