//
//  BFSliderCell.m
//  BFTest
//
//  Created by 伯符 on 16/7/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFSliderCell.h"
#define CellHeight  59*ScreenRatio
@implementation BFSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*ScreenRatio, 20*ScreenRatio)];
    self.imgView.center = CGPointMake(30*ScreenRatio, CellHeight/2);
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.clipsToBounds = YES;
    [self.contentView addSubview:self.imgView];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150*ScreenRatio, 18*ScreenRatio)];
    self.titleLabel.center = CGPointMake(CGRectGetMaxX(self.imgView.frame) + 55*ScreenRatio, CellHeight/2);
    self.titleLabel.textColor = BFColor(248, 248, 249, 1);
    self.titleLabel.font = BFFontOfSize(17);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenRatio, CellHeight - 0.5, 250*ScreenRatio - 25*ScreenRatio, 0.5)];
    self.line.backgroundColor = BFColor(26, 29, 32, 1);
    [self.contentView addSubview:self.line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end


@implementation BFCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 55*ScreenRatio, 55*ScreenRatio)];
    self.imgView.center = CGPointMake(33*ScreenRatio, BFCouponCellHeight/2);
    self.imgView.layer.cornerRadius = 55*ScreenRatio/2;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    
    self.promotionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(262.4*ScreenRatio, 0, 55*ScreenRatio, 55*ScreenRatio)];
    self.promotionImageView.contentMode = UIViewContentModeScaleAspectFill;

    
    
    [self.contentView addSubview:self.imgView];
     [self.contentView addSubview:self.promotionImageView];
    
    self.midTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*ScreenRatio, 18*ScreenRatio)];
    self.midTitleLabel.center = CGPointMake(CGRectGetMaxX(self.imgView.frame)+15*ScreenRatio + 100*ScreenRatio, 70*ScreenRatio/2);
    self.midTitleLabel.textColor = [UIColor lightGrayColor];
    self.midTitleLabel.font = BFFontOfSize(15);
    self.midTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.midTitleLabel];

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imgView.bounds.size.width + 20*ScreenRatio, 3, 300*ScreenRatio, 18*ScreenRatio)];
//    self.titleLabel.center = CGPointMake(CGRectGetMaxX(self.imgView.frame)+15*ScreenRatio + 100*ScreenRatio, BFCouponCellHeight/2- 9*ScreenRatio - 14*ScreenRatio);
    self.titleLabel.textColor = BFColor(7, 7, 7, 1);
    self.titleLabel.font = BFFontOfSize(17);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+15*ScreenRatio, CGRectGetMaxY(self.midTitleLabel.frame)+5*ScreenRatio, 200*ScreenRatio, 18*ScreenRatio)];
    self.subTitleLabel.textColor = [UIColor lightGrayColor];
    self.subTitleLabel.font = BFFontOfSize(15);
    self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.subTitleLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 40*ScreenRatio)];
    self.priceLabel.center = CGPointMake(Screen_width - 45*ScreenRatio, 70*ScreenRatio/2);
    self.priceLabel.textColor = BFColor(7, 7, 7, 1);
    self.priceLabel.font = BFFontOfSize(23);
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.priceLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 70*ScreenRatio - 0.5, Screen_width, 0.5)];
    line.backgroundColor = BFColor(238, 238, 239, 1);
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(MyCouponModel *)model{
    self.titleLabel.text = model.shop_name;
    self.midTitleLabel.text = model.item_name;
    self.subTitleLabel.text = model.expire_date;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.photo_1]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    UIImage *image = nil;
    if([model.promotion_type isEqualToString:@"N"]){
        image = [UIImage imageNamed:@"promotion_type_N"];
    }
    
    self.promotionImageView.image = image;
}

@end


@implementation BFSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 18*ScreenRatio)];
    self.titleLabel.center = CGPointMake(80*ScreenRatio, self.height/2);
    self.titleLabel.textColor = BFColor(38, 39, 40, 1);
    self.titleLabel.font = BFFontOfSize(17);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

@implementation BFEditDtCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*ScreenRatio, 20*ScreenRatio)];
    self.imgView.center = CGPointMake(30*ScreenRatio, BFEditDtCellHeight/2);
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.clipsToBounds = YES;
    [self.contentView addSubview:self.imgView];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*ScreenRatio, 18*ScreenRatio)];
    self.titleLabel.center = CGPointMake(CGRectGetMaxX(self.imgView.frame) + 55*ScreenRatio, BFEditDtCellHeight/2);
    self.titleLabel.textColor = BFColor(82, 83, 84, 1);
    self.titleLabel.font = BFFontOfSize(17);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];

    self.accessLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenRatio, 18*ScreenRatio)];
    self.accessLabel.center = CGPointMake(Screen_width - 90*ScreenRatio, BFEditDtCellHeight/2);
    self.accessLabel.textColor = BFColor(19, 53, 114, 1);
    self.accessLabel.font = BFFontOfSize(14);
    self.accessLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.accessLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
@end



@implementation BFMatchSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*ScreenRatio, 18*ScreenRatio)];
    self.titleLabel.center = CGPointMake(20*ScreenRatio + 100*ScreenRatio, BFEditDtCellHeight/2);
    self.titleLabel.textColor = BFColor(82, 83, 84, 1);
    self.titleLabel.font = BFFontOfSize(17);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.accessLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenRatio, 18*ScreenRatio)];
    self.accessLabel.center = CGPointMake(Screen_width - 90*ScreenRatio, BFEditDtCellHeight/2);
    self.accessLabel.textColor = BFColor(82, 83, 84, 1);
    self.accessLabel.font = BFFontOfSize(14);
    self.accessLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.accessLabel];
    self.accessLabel.hidden = YES;
    
    self.switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50*ScreenRatio, 18*ScreenRatio)];
    self.switchBtn.center = CGPointMake(Screen_width - 30*ScreenRatio, BFEditDtCellHeight/2);
    self.switchBtn.onTintColor = [UIColor blackColor];
    self.switchBtn.tintColor = BFColor(158, 159, 160, 1);
    self.switchBtn.backgroundColor = BFColor(158, 159, 160, 1);
    self.switchBtn.layer.cornerRadius = 15;
    self.switchBtn.layer.masksToBounds = YES;
    self.switchBtn.thumbTintColor = BFThemeColor;
//    [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchBtn];
    self.switchBtn.hidden = NO;
}

//- (void)switchAction:(UISwitch *)switchbtn{
//    if (switchbtn.on) {
//        switchbtn.thumbTintColor = BFColor(243, 212, 13, 1);
//    }else{
//        switchbtn.thumbTintColor = [UIColor whiteColor];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end

@interface BFAgeSliderCell ()
@end
@implementation BFAgeSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    //standard rsnge slider
    self.rangeSlider = [[TTRangeSlider alloc]initWithFrame:CGRectMake(0, 0, Screen_width - 40*ScreenRatio, 17*ScreenRatio)];
    self.rangeSlider.center = CGPointMake(Screen_width/2, BFEditDtCellHeight/2);
    self.rangeSlider.delegate = self;
    self.rangeSlider.handleDiameter = 20*ScreenRatio;
    self.rangeSlider.minValue = 16;
    self.rangeSlider.maxValue = 50;
    self.rangeSlider.lineHeight = 5;
    self.rangeSlider.tintColor = [UIColor blackColor];
    self.rangeSlider.tintColorBetweenHandles = BFColor(243, 211, 13, 1);
    self.rangeSlider.minDistance = 10;
    self.rangeSlider.selectedMinimum = 16;
    self.rangeSlider.selectedMaximum = 50;
    self.rangeSlider.handleImage = [UIImage imageNamed:@"sliderhandler"];
    [self.contentView addSubview:self.rangeSlider];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (sender == self.rangeSlider){
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        if ([self.delegate respondsToSelector:@selector(sliderChangedmin:max:)]) {
            [self.delegate sliderChangedmin:selectedMinimum max:selectedMaximum];
        }
    }
    
}

@end

@implementation BFSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 39*ScreenRatio, 39*ScreenRatio)];
    self.iconImage.center = CGPointMake(30*ScreenRatio, CellHeight/2);
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImage.layer.cornerRadius = self.iconImage.width/2;
    self.iconImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = BFFontOfSize(17);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.replyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.replyBtn.titleLabel.font = BFFontOfSize(14);
    [self.replyBtn addTarget:self action:@selector(replyuser:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.replyBtn];

    
    self.rankView = [[UIImageView alloc]init];
    self.rankView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.rankView.image = [UIImage imageNamed:@"rank001-1"];

    [self.contentView addSubview:self.rankView];
    
    self.genderView = [[UIImageView alloc]init];
    self.genderView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.ageLabel = [[UILabel alloc]init];
    self.ageLabel.backgroundColor = [UIColor clearColor];
    self.ageLabel.textColor = [UIColor whiteColor];
    self.ageLabel.textAlignment = NSTextAlignmentCenter;
    self.ageLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.genderView addSubview:self.ageLabel];

    [self.contentView addSubview:self.genderView];
    
    self.subtitleLabel = [[UILabel alloc]init];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.font = BFFontOfSize(14);
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.subtitleLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width - 90*ScreenRatio, 9*ScreenRatio, 80*ScreenRatio, 15*ScreenRatio)];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = BFFontOfSize(14);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCommentModel:(BFCommentModel *)commentModel{
    _commentModel = commentModel;
    self.rankView.hidden = YES;
    self.genderView.hidden = YES;
    self.titleLabel.text = commentModel.nikename;
    CGFloat width = [commentModel.nikename getWidthWithHeight:18*ScreenRatio font:17];
    if (width > 230) {
        width = 230;
    }
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10*ScreenRatio, 9*ScreenRatio, width, 18*ScreenRatio);
    self.replyBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5*ScreenRatio, 10*ScreenRatio, 30*ScreenRatio, 18*ScreenRatio);
    
    
    NSString *string;
    if (_commentModel.reply_user.length > 0) {
        string = [NSString stringWithFormat:@"回复%@ %@",_commentModel.reply_user_nikename,commentModel.message];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];

        [attributeString addAttribute:NSForegroundColorAttributeName value:BFColor(19, 53, 114, 1) range:[string rangeOfString:_commentModel.reply_user_nikename]];
        self.subtitleLabel.attributedText = attributeString;
        
    }else{
        string = [NSString stringWithFormat:@"%@",commentModel.message];
        self.subtitleLabel.text = string;
    }
    
    CGFloat height = [_commentModel.message getHeightWithWidth:300*ScreenRatio font:14];
    self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 9*ScreenRatio, Screen_width - 65*ScreenRatio, height);
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:commentModel.head_image] placeholderImage:BFIcomImg];
    self.timeLabel.text = [[NSString alloc]distanceTimeWithBeforeTime:[commentModel.publish_datetime doubleValue]];
    
    self.cellheight = CGRectGetMaxY(self.subtitleLabel.frame);
}

- (void)replyuser:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(replytoUser:)]) {
        [self.delegate replytoUser:self];
    }
}

- (void)setFansModel:(BFFansModel *)fansModel{
    self.rankView.hidden = NO;
    self.genderView.hidden = NO;
    self.titleLabel.text = fansModel.nikename;
    CGFloat width = [fansModel.nikename getWidthWithHeight:18*ScreenRatio font:17];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10*ScreenRatio, 7*ScreenRatio, width, 18*ScreenRatio);
    self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 9*ScreenRatio, 300*ScreenRatio, 15*ScreenRatio);
    self.subtitleLabel.text = fansModel.signature;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:fansModel.mybmp] placeholderImage:BFIcomImg];
    self.timeLabel.text = [[NSString alloc]distanceTimeWithBeforeTime:[fansModel.lasttime doubleValue]];
    self.genderView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, 7*ScreenRatio, 30*ScreenRatio, 17*ScreenRatio);
    self.ageLabel.frame = CGRectMake(10, 0, self.genderView.width - 10, self.genderView.height);
    self.ageLabel.text = fansModel.years;
    self.rankView.frame = CGRectMake(CGRectGetMaxX(self.genderView.frame) + 5,  7*ScreenRatio, 30*ScreenRatio, 17*ScreenRatio);
    NSString *imgStr;
    if ([fansModel.grade isEqualToString:@""]) {
        imgStr = [NSString stringWithFormat:@"rank001-0"];
    }else{
        imgStr = [NSString stringWithFormat:@"rank001-%@",fansModel.grade];
    }
    self.rankView.image = [UIImage imageNamed:imgStr];
    NSString *sex;
    if ([fansModel.sex isEqualToString:@"女"]) {
        sex = [NSString stringWithFormat:@"matchfemale"];
    }else{
        sex = [NSString stringWithFormat:@"matchmale"];
    }
    self.genderView.image = [UIImage imageNamed:sex];
}

- (void)setTopicDic:(NSDictionary *)topicDic{
    _topicDic = topicDic;
    self.titleLabel.text = topicDic[@"theme"];
    self.subtitleLabel.text = [NSString stringWithFormat:@"%@条相关搜索",topicDic[@"search_times"]];
    self.iconImage.image = [UIImage imageNamed:@"topiclogo"];
    CGFloat titlewidth = [topicDic[@"theme"] getWidthWithHeight:18*ScreenRatio font:17];
    if (titlewidth > 270) {
        titlewidth = 270;
    }
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10*ScreenRatio, 9*ScreenRatio, titlewidth, 18*ScreenRatio);
    self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 9*ScreenRatio, 290*ScreenRatio, 15*ScreenRatio);

}

- (void)setUserDic:(NSDictionary *)userDic{
    _userDic = userDic;
    self.titleLabel.text = userDic[@"nikename"];
//    self.subtitleLabel.text = [NSString stringWithFormat:@"%@条相关搜索",userDic[@"search_times"]];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:userDic[@"head_image"]]];
    CGFloat titlewidth = [userDic[@"nikename"] getWidthWithHeight:18*ScreenRatio font:17];
    if (titlewidth > 270) {
        titlewidth = 270;
    }
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10*ScreenRatio, 9*ScreenRatio, titlewidth, 18*ScreenRatio);
    self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 9*ScreenRatio, 290*ScreenRatio, 15*ScreenRatio);
}

- (void)setBlackDic:(NSDictionary *)blackDic{
    _blackDic = blackDic;
    NSString *username = _blackDic[@"nikename"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:_blackDic[@"mybmp"]]];
    self.titleLabel.text = _blackDic[@"nikename"];
    CGFloat width = [username getWidthWithHeight:18*ScreenRatio font:17];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10*ScreenRatio, 15*ScreenRatio, width, 18*ScreenRatio);
}

@end


@implementation BFDtAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 39*ScreenRatio, 39*ScreenRatio)];
    self.iconImage.center = CGPointMake(30*ScreenRatio, CellHeight/2);
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImage.layer.cornerRadius = self.iconImage.width/2;
    self.iconImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = BFFontOfSize(14);
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.behindImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 39*ScreenRatio, 39*ScreenRatio)];
    self.behindImage.center = CGPointMake(Screen_width - 39*ScreenRatio/2 - 5*ScreenRatio, self.behindImage.width/2 + 5*ScreenRatio);
    self.behindImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.behindImage];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*ScreenRatio, 15*ScreenRatio)];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = BFFontOfSize(14);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLabel];

}

- (void)setModel:(BFDtAlertModel *)model{
    NSString *titleStr;
    NSString *timestr = [[NSString alloc]distanceTimeWithBeforeTime:[model.publish_datetime doubleValue]];;

    if ([model.type isEqualToString:@"Z"]) {
        titleStr = [NSString stringWithFormat:@"%@赞了我的动态",model.nikename];
    }else{
        titleStr = [NSString stringWithFormat:@"%@:%@",model.nikename,model.message];
    }
    CGFloat strWidth = Screen_width - self.iconImage.width - self.behindImage.width - 25*ScreenRatio;

    CGFloat height = [titleStr getHeightWithWidth:strWidth font:14];
    CGFloat timeWidth = [timestr getWidthWithHeight:15*ScreenRatio font:14];
    self.titleLabel.text = titleStr;
    self.timeLabel.text = timestr;
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10*ScreenRatio, CGRectGetMinY(self.iconImage.frame), strWidth, height);
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame)+7*ScreenRatio, timeWidth, 15*ScreenRatio);
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    [self.behindImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame)+7*ScreenRatio, timeWidth, 15*ScreenRatio);

}

@end
