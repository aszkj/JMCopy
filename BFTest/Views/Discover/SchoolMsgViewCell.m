//
//  SchoolMsgViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/29.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "SchoolMsgViewCell.h"

@implementation SchoolMsgViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.addschool = [[UITextField alloc]initWithFrame:CGRectMake(UserCellMargin, 0, Screen_width - UserCellMargin*2, 39*ScreenRatio)];
        self.addschool.placeholder = @"添加学校信息";
        self.addschool.textColor = [UIColor blackColor];
        self.addschool.font = BFFontOfSize(15);
        self.addschool.textAlignment = NSTextAlignmentLeft;
        self.addschool.clearsOnBeginEditing = YES;
        self.addschool.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.addschool.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.addschool];
    }
    
    return self;
}

@end
