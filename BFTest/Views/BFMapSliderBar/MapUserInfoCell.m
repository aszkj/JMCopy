//
//  MapUserInfoCell.m
//  BFTest
//
//  Created by 伯符 on 16/11/10.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "MapUserInfoCell.h"

@interface MapUserInfoCell (){
    UILabel *firstLNum;
    UILabel *secLNum;
}

@end

@implementation MapUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40*ScreenRatio, 20*ScreenRatio)];
        self.firstLabel.center = CGPointMake(45*ScreenRatio, self.height/2);
        self.firstLabel.textColor = [UIColor grayColor];
        self.firstLabel.font = BFFontOfSize(16);
        self.firstLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.firstLabel];
        
        firstLNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.firstLabel.frame)+5*ScreenRatio, CGRectGetMinY(self.firstLabel.frame), 40*ScreenRatio, 20*ScreenRatio)];
        firstLNum.textColor = [UIColor whiteColor];
        firstLNum.text = @"43";
        firstLNum.font = BFFontOfSize(16);
        firstLNum.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:firstLNum];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 15)];
        line.center = CGPointMake((kMapPopViewHeight)/2 - 1, self.height/2);
        line.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:line];
        
        self.secLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + 20*ScreenRatio, CGRectGetMinY(self.firstLabel.frame), 40*ScreenRatio, 20*ScreenRatio)];
        self.secLabel.textColor = [UIColor grayColor];
        self.secLabel.font = BFFontOfSize(16);
        self.secLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.secLabel];
        
        secLNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.secLabel.frame)+5*ScreenRatio, CGRectGetMinY(self.firstLabel.frame), 40*ScreenRatio, 20*ScreenRatio)];
        secLNum.textColor = [UIColor whiteColor];
        secLNum.text = @"140";
        secLNum.font = BFFontOfSize(16);
        secLNum.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:secLNum];
    }
    
    return self;
}

@end
