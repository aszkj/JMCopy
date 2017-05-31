//
//  BFMapAlertCell.m
//  BFTest
//
//  Created by 伯符 on 16/7/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFMapAlertCell.h"

@interface BFMapAlertCell (){
    UIImageView *iconView;
    UILabel *titleLabel;
    UILabel *subtitleLabel;
}
@end

@implementation BFMapAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ScreenRatio, 9*ScreenRatio, 37*ScreenRatio, 37*ScreenRatio)];
    iconView.contentMode = UIViewContentModeScaleToFill;
    iconView.clipsToBounds = YES;
    iconView.image = [UIImage imageNamed:@"alert"];
    [self.contentView addSubview:iconView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+10*ScreenRatio, 5*ScreenRatio, 100*ScreenRatio, 20*ScreenRatio)];
    titleLabel.textColor = BFColor(255, 255, 255, 1);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    
    subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+10*ScreenRatio, CGRectGetMaxY(titleLabel.frame)+ScreenRatio, 180*ScreenRatio, 17*ScreenRatio)];
    subtitleLabel.textColor = BFColor(255, 255, 255, 1);
    subtitleLabel.font = BFFontOfSize(14);
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:subtitleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subtitleLabel.frame)+5*ScreenRatio, self.width, 0.5)];
    line.backgroundColor = BFColor(75, 76, 77, 1);
    [self.contentView addSubview:line];
}

- (void)setDic:(NSDictionary *)dic{
    iconView.image = [UIImage imageNamed:dic[@"alerImg"]];
    titleLabel.text = dic[@"alertTitle"];
    subtitleLabel.text = dic[@"alertSub"];
    if ([dic[@"alertSub"] isEqualToString:@""]) {
        subtitleLabel.hidden = YES;
        titleLabel.frame = CGRectMake(CGRectGetMaxX(iconView.frame)+10*ScreenRatio, 15*ScreenRatio, 100*ScreenRatio, 20*ScreenRatio);
    }
}

@end
