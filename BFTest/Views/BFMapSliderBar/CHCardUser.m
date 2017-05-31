//
//  CHCardUser.m
//  BFTest
//
//  Created by 伯符 on 17/1/6.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "CHCardUser.h"
@interface CHCardUser (){
    UILabel *nameLabel;
    UIImageView *gender;
    UILabel *ageLabel;
    UIImageView *bacImage;
    UILabel *metaddress;
    UIImageView *rankView;
    UIImageView *genderView;
    UIImageView *vipView;
    UILabel *metaddressL;
}

@end
@implementation CHCardUser

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self congfigureUI];
    }
    return self;
}

- (void)congfigureUI{
    bacImage = [[UIImageView alloc]initWithFrame:self.bounds];
    bacImage.contentMode = UIViewContentModeScaleAspectFill;
    bacImage.clipsToBounds = YES;
    [self addSubview:bacImage];
    
    UIView *botview = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 35*ScreenRatio, self.width, 35*ScreenRatio)];
    botview.backgroundColor = [UIColor blackColor];
    [bacImage addSubview:botview];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenRatio, 0, 150*ScreenRatio, 20*ScreenRatio)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = BFFontOfSize(16);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [botview addSubview:nameLabel];
    
    gender = [[UIImageView alloc]initWithFrame:CGRectMake(floor(10*ScreenRatio), floor(CGRectGetMaxY(nameLabel.frame)), floor(23*ScreenRatio), floor(11*ScreenRatio))];
    gender.contentMode = UIViewContentModeScaleAspectFill;
    [botview addSubview:gender];
    
    ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(floor(10*ScreenRatio),floor(0), floor(15*ScreenRatio), floor(11*ScreenRatio))];
    ageLabel.adjustsFontSizeToFitWidth = YES;
    ageLabel.textColor = [UIColor whiteColor];
    ageLabel.font = BFFontOfSize(9);
    ageLabel.textAlignment = NSTextAlignmentCenter;
    [gender addSubview:ageLabel];
    
    metaddressL = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2 + 5*ScreenRatio, CGRectGetMinY(gender.frame), 50*ScreenRatio, 11*ScreenRatio)];
    metaddressL.text = @"约会地点";
    metaddressL.textColor = [UIColor lightGrayColor];
    metaddressL.font = BFFontOfSize(11);
    metaddressL.textAlignment = NSTextAlignmentCenter;
    [botview addSubview:metaddressL];
    
    rankView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(gender.frame)+5, floor(CGRectGetMaxY(nameLabel.frame)), 23*ScreenRatio, 11*ScreenRatio)];
    rankView.contentMode = UIViewContentModeScaleAspectFit;
    rankView.image = [UIImage imageNamed:@"rank001-1"];
    
    [botview addSubview:rankView];
    
    vipView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rankView.frame)+3, floor(CGRectGetMaxY(nameLabel.frame)), 23*ScreenRatio, 11*ScreenRatio)];
    vipView.contentMode = UIViewContentModeScaleAspectFit;
    [botview addSubview:vipView];
    
    
    metaddress = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(metaddressL.frame), CGRectGetMinY(gender.frame), 27*ScreenRatio, 11*ScreenRatio)];
    metaddress.backgroundColor = BFColor(183, 134, 197, 1);
    metaddress.layer.cornerRadius = 3;
    metaddress.layer.masksToBounds = YES;
    metaddress.textColor = [UIColor whiteColor];
    metaddress.font = BFFontOfSize(11);
    metaddress.textAlignment = NSTextAlignmentCenter;
    [botview addSubview:metaddress];
}

- (void)setCardModel:(CHCardItemModel *)cardModel{
    
    [bacImage sd_setImageWithURL:[NSURL URLWithString:cardModel.photo]];
    nameLabel.text = cardModel.name;
    ageLabel.text = cardModel.age;
    UIImage *img;
    
    if ([cardModel.sex isEqualToString:@"0"]) {
        img = [UIImage imageNamed:@"matchmale"];
    }else{
        img = [UIImage imageNamed:@"matchfemale"];
    }
    gender.image = img;

    NSString *imgStr;
    if ([cardModel.grade isEqualToString:@""]) {
        imgStr = [NSString stringWithFormat:@"rank001-0"];
    }else{
        imgStr = [NSString stringWithFormat:@"rank001-%@",cardModel.grade];
    }
    rankView.image = [UIImage imageNamed:imgStr];
    
    NSString *vipStr;
    if ([cardModel.vipGrade isEqualToString:@""]) {
        vipStr = [NSString stringWithFormat:@"vip0"];
    }else{
        vipStr = [NSString stringWithFormat:@"vip%@",cardModel.vipGrade];
    }
    vipView.image = [UIImage imageNamed:vipStr];
    if (cardModel.datePlace) {
        
        if (cardModel.datePlace.length > 0) {
            
            metaddress.text = cardModel.datePlace;
            CGFloat width = [metaddress.text getWidthWithHeight:11*ScreenRatio font:11];
            
            metaddress.frame = CGRectMake(CGRectGetMaxX(metaddressL.frame)+5, CGRectGetMinY(gender.frame),width, 11*ScreenRatio);

           
        }
    }
    
}

@end
