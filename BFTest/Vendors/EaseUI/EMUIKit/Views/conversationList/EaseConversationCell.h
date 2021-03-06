/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import <UIKit/UIKit.h>

#import "IConversationModel.h"
#import "IModelCell.h"
#import "EaseImageView.h"
#import "BFConversationModel.h"
static CGFloat EaseConversationCellMinHeight = 60;

@interface EaseConversationCell : UITableViewCell<IModelCell>

@property (strong, nonatomic) EaseImageView *avatarView;

@property (strong, nonatomic) UILabel *detailLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSString *iconurl;

@property (strong, nonatomic) id<IConversationModel> conmodel;
@property (strong,nonatomic) BFConversationModel *model;

@property (nonatomic) BOOL showAvatar;//default is "YES"

@property (nonatomic,strong) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) UIFont *detailLabelFont UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) UIColor *detailLabelColor UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) UIFont *timeLabelFont UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) UIColor *timeLabelColor UI_APPEARANCE_SELECTOR;

@end
