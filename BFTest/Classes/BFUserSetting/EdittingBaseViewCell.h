//
//  EdittingBaseViewCell.h
//  BFTest
//
//  Created by 伯符 on 16/10/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EdittingBaseViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIImageView *markImg;

@property (nonatomic,assign) BOOL isSelected;
@end

@interface PrivacyBaseViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subLabel;

@property (nonatomic,strong) UIImageView *markImg;

@property (nonatomic,assign) BOOL isSelected;
@end
