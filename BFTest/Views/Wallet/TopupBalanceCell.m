//
//  TopupBalanceCell.m
//  BFTest
//
//  Created by 伯符 on 16/12/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "TopupBalanceCell.h"

@implementation TopupBalanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*ScreenRatio, 30*ScreenRatio)];
    self.icon.center = CGPointMake(30*ScreenRatio, 45*ScreenRatio/2);
    self.icon.layer.cornerRadius = 15*ScreenRatio;
    self.icon.layer.masksToBounds = YES;
    [self addSubview:self.icon];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65*ScreenRatio, 20*ScreenRatio)];
    self.nameLabel.center = CGPointMake(CGRectGetMaxX(self.icon.frame)+45*ScreenRatio, 45*ScreenRatio/2);
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor blackColor];
    [self addSubview:self.nameLabel];
    
    self.checkmark = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*ScreenRatio, 20*ScreenRatio)];
    self.checkmark.image = [UIImage imageNamed:@"checkmark"];
    self.checkmark.center = CGPointMake(Screen_width - 40*ScreenRatio - 20*ScreenRatio, 45*ScreenRatio/2);
    self.checkmark.layer.cornerRadius = 10*ScreenRatio;
    self.checkmark.layer.masksToBounds = YES;
    [self addSubview:self.checkmark];
    self.checkmark.hidden = YES;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*ScreenRatio - 0.5, Screen_width - 40*ScreenRatio, 0.5)];
    line1.backgroundColor = BFColor(239, 240, 241, 1);
    [self addSubview:line1];
    
}



@end
