//
//  CreateMyselfCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "CreateMyselfCell.h"

@interface CreateMyselfCell (){
    UIImageView *addselfView;
}

@end

@implementation CreateMyselfCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        addselfView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addself"]];
        addselfView.frame = CGRectMake(UserCellMargin, 15*ScreenRatio, 15*ScreenRatio, 15*ScreenRatio);
        addselfView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:addselfView];
        
        UILabel *selflabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addselfView.frame)+10   , 11*ScreenRatio, 150*ScreenRatio, 20*ScreenRatio)];
        selflabel.text = @"创建我自己的标签";
        selflabel.textAlignment = NSTextAlignmentLeft;
        selflabel.textColor = [UIColor lightGrayColor];
        selflabel.font = BFFontOfSize(15);
        [self.contentView addSubview:selflabel];
    }
    return self;
}

@end
