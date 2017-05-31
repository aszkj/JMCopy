//
//  BFInterestCell.h
//  BFTest
//
//  Created by 伯符 on 16/7/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFInterestModel.h"
#import "BFInterestCellImageView.h"
#import "BFInterestModelFrame.h"
#import "MLEmojiLabel.h"

@class BFInterestCell,BFBaseImageView;

@protocol BFHomeTableViewCellDelegate <NSObject>

/** 播放视频*/
- (void)homeTableViewCell:(BFInterestCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(BFInterestCellImageView *)baseImageView;


- (void)moreBtnClick:(UILabel *)label withCell:(BFInterestCell *)cell isHaveMore:(BOOL)more;

// 点赞
- (void)zanBtnClickWithcell :(BFInterestCell *)cell model:(id)data;
// 评论
- (void)commentBtnClickWithCell:(BFInterestCell *)cell;
// 举报
- (void)jubaoBtnClikWithCell:(BFInterestCell *)cell;

// 点击话题
- (void)selectTopics:(MLEmojiLabelLinkType)linktype linkstr:(NSString *)linkStr;
// 点击用户头像
- (void)selectUserIcon:(NSString *)userid;

@end

@interface BFInterestCell : UITableViewCell

@property (nonatomic,copy) NSString *videourl;

/** 视频封面*/
@property (nonatomic, strong) BFInterestCellImageView *videoCover;

/** 大图*/
//@property (nonatomic, weak) BFBaseImageView *largeImageCover;

@property (nonatomic, strong) UIImageView *largeImageCover;

@property (nonatomic,strong) BFInterestModel *cellModel;

@property (nonatomic,strong) BFInterestModelFrame *modelFrame;

@property (nonatomic, assign) id <BFHomeTableViewCellDelegate> videoDelegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIButton *guanzhuBtn;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath,BFInterestCell *cell,BOOL more);

@end
