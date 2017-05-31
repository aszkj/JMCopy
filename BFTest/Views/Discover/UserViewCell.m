//
//  UserViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserViewCell.h"

@interface UserViewCell (){
    UILabel *fromLabel;
    UILabel *hangyeLabel;
    UILabel *occupationLabel;
    UILabel *schoolLabel;
}

@end
@implementation UserViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, 15, 80, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        UILabel *from = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, CGRectGetMaxY(self.titleLabel.frame) + 15, 60, 20)];
        from.text = @"来自：";
        from.textAlignment = NSTextAlignmentLeft;
        from.textColor = [UIColor lightGrayColor];
        from.font = BFFontOfSize(15);
        [self.contentView addSubview:from];
        
        fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(from.frame)+10, CGRectGetMaxY(self.titleLabel.frame) + 15, Screen_width - UserCellMargin - 40, 20)];
        fromLabel.textAlignment = NSTextAlignmentLeft;
        fromLabel.textColor = [UIColor lightGrayColor];
        fromLabel.font = BFFontOfSize(15);
        [self.contentView addSubview:fromLabel];
        
        UILabel *hangye = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, CGRectGetMaxY(from.frame) + 10, 60, 20)];
        hangye.text = @"行业：";
        hangye.textAlignment = NSTextAlignmentLeft;
        hangye.textColor = [UIColor lightGrayColor];
        hangye.font = BFFontOfSize(15);
        [self.contentView addSubview:hangye];
        
        hangyeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hangye.frame)+10, CGRectGetMaxY(from.frame) + 10, Screen_width - UserCellMargin - 40, 20)];
        hangyeLabel.textAlignment = NSTextAlignmentLeft;
        hangyeLabel.textColor = [UIColor lightGrayColor];
        hangyeLabel.font = BFFontOfSize(15);
        [self.contentView addSubview:hangyeLabel];
        
        UILabel *occupation = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, CGRectGetMaxY(hangye.frame) + 10, 60, 20)];
        occupation.text = @"职业：";
        occupation.textAlignment = NSTextAlignmentLeft;
        occupation.textColor = [UIColor lightGrayColor];
        occupation.font = BFFontOfSize(15);
        [self.contentView addSubview:occupation];
        
        occupationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(occupation.frame)+10, CGRectGetMaxY(hangye.frame) + 10, Screen_width - UserCellMargin - 40, 20)];
        occupationLabel.textAlignment = NSTextAlignmentLeft;
        occupationLabel.textColor = [UIColor lightGrayColor];
        occupationLabel.font = BFFontOfSize(15);
        [self.contentView addSubview:occupationLabel];
        
        UILabel *school = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, CGRectGetMaxY(occupation.frame) + 10, 60, 20)];
        school.text = @"学校：";
        school.textAlignment = NSTextAlignmentLeft;
        school.textColor = [UIColor lightGrayColor];
        school.font = BFFontOfSize(15);
        [self.contentView addSubview:school];
        
        schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(school.frame)+10, CGRectGetMaxY(occupation.frame) + 10, Screen_width - UserCellMargin - 40, 20)];
        schoolLabel.textAlignment = NSTextAlignmentLeft;
        schoolLabel.textColor = [UIColor lightGrayColor];
        schoolLabel.font = BFFontOfSize(15);
        [self.contentView addSubview:schoolLabel];
        
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(school.frame)+15, Screen_width, 0.5)];
        bottomLine.backgroundColor = BFColor(243, 243, 242, 1);
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    fromLabel.text = dic[@"jmlocation"];
    hangyeLabel.text = dic[@"industry"];
    schoolLabel.text = dic[@"school"];
    occupationLabel.text = dic[@"occupation"];
}

@end
