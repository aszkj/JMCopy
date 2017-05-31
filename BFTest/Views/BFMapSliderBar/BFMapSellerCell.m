//
//  BFMapSellerCell.m
//  BFTest
//
//  Created by 伯符 on 16/7/29.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFMapSellerCell.h"


@interface BFMapSellerCell (){
    UILabel *subtitleLabel;
    UIView *seperateLine;
}
@end

@implementation BFMapSellerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    CGFloat iconWidth = self.height - 23*ScreenRatio;
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth)];
    self.iconView.center = CGPointMake(23 *ScreenRatio, self.height/2);
    self.iconView.contentMode = UIViewContentModeScaleToFill;
    self.iconView.clipsToBounds = YES;
    [self.contentView addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame)+10*ScreenRatio, 5*ScreenRatio, self.width - iconWidth - 10*ScreenRatio - 20*ScreenRatio, 25*ScreenRatio)];
//    titleLabel.text = [NSString stringWithFormat:@"$143 双人餐！免费Wifi"];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];

//    seperateLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, self.width, 0.5)];
//    seperateLine.backgroundColor = BFColor(48, 48, 49, 1);
//    [self.contentView addSubview:seperateLine];
    
}


- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    if (_dic) {
        NSString *total = _dic[@"total"];
        NSString *price = _dic[@"price"];
        NSString *textStr = [NSString stringWithFormat:@"%@ ¥%@", total,price];
        //中划线
        NSDictionary *attribtDic1 = @{NSFontAttributeName :BFFontOfSize(14),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor whiteColor]};
        NSDictionary *attribtDic2 = @{NSFontAttributeName :BFFontOfSize(19),NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr];
        [attribtStr addAttributes:attribtDic1 range:NSMakeRange(0, total.length)];
        [attribtStr addAttributes:attribtDic2 range:NSMakeRange(total.length, price.length + 2)];
        
        NSLog(@"%@",attribtStr);
//        titleLabel.attributedText = attribtStr;
        
        self.titleLabel.text = @"新用户首次下单立减10元!";
        self.titleLabel.font = BFFontOfSize(14);
        self.titleLabel.textColor = BFColor(135, 138, 139, 1);
        self.iconView.image = [UIImage imageNamed:@"newercustom"];
    }else{
//        seperateLine.hidden = YES;
        self.titleLabel.text = @"新用户首次下单立减10元!";
        self.titleLabel.font = BFFontOfSize(14);
        self.titleLabel.textColor = BFColor(135, 138, 139, 1);
        self.iconView.image = [UIImage imageNamed:@"newercustom"];
    }
    
}

@end
