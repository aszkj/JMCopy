//
//  BFSliderCell.h
//  BFTest
//
//  Created by 伯符 on 16/7/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouponModel.h"
#import "TTRangeSlider.h"
#import "BFInterestModel.h"
#define BFCouponCellHeight        75*ScreenRatio
#define BFSettingCellHeight       45*ScreenRatio
#define BFEditDtCellHeight       45*ScreenRatio


@interface BFSliderCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *line;

@end

@interface BFCouponCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UIImageView *promotionImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *midTitleLabel;

@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) MyCouponModel *model;
@end

@interface BFSettingCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end

@interface BFEditDtCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *accessLabel;

@end

@interface BFMatchSwitchCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *accessLabel;

@property (nonatomic,strong) UISwitch *switchBtn;

@end

@class BFSearchCell;

@protocol RelyUserDelegate <NSObject>

- (void)replytoUser:(BFSearchCell *)cell;

@end

@interface BFSearchCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *subtitleLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *rankView;

@property (nonatomic,strong) UIImageView *genderView;

@property (nonatomic,strong) UILabel *ageLabel;

@property (nonatomic,assign) CGFloat cellheight;

@property (nonatomic,strong) BFCommentModel *commentModel;

@property (nonatomic,strong) BFFansModel *fansModel;

@property (nonatomic,strong) UIButton *replyBtn;

@property (nonatomic,assign) id<RelyUserDelegate> delegate;

@property (nonatomic,strong) NSDictionary *topicDic;

@property (nonatomic,strong) NSDictionary *userDic;

@property (nonatomic,strong) NSDictionary *blackDic;
@end

@protocol BFAgeSliderCellValueChange <NSObject>

- (void)sliderChangedmin:(float)valueone max:(float)valuetwo;

@end

@interface BFAgeSliderCell : UITableViewCell<TTRangeSliderDelegate>

@property (nonatomic,strong)TTRangeSlider *rangeSlider;

@property (nonatomic,strong) id<BFAgeSliderCellValueChange> delegate;

@end

@interface BFDtAlertCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *behindImage;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) BFDtAlertModel *model;

@end


