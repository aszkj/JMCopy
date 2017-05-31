//
//  BFInterestCell.m
//  BFTest
//
//  Created by 伯符 on 16/7/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFInterestCell.h"
#import "BFButtonView.h"
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@interface BFInterestCell ()<BFButtonViewDelegate,MLEmojiLabelDelegate>{
    UIView *backView;
    UIImageView *icon;
    UILabel *fromPlaceLabel;
    UILabel *nameLabel;
    
    UILabel *timeLabel;
    UIImageView *mainPic;
    UIButton *locateBtn;
//    UILabel *statementLabel;
    MLEmojiLabel *statementLabel;
    BFButtonView *zanBtn;
    BFButtonView *commentBtn;
    BFButtonView *shareBtn;
    BFButtonView *jubaoBtn;
//    UILabel *comNumLabel;
    UIButton *allComBtn;

    UIView *comtView;
    UIView *botmSecline;
    UIView *line;
}

@property (nonatomic,assign) NSInteger zanNum;
@property (nonatomic,assign) CGRect locaRec;
@property (nonatomic,assign) BOOL isMore;
@property (nonatomic,assign) BOOL shrink;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) UILabel *zanLabel;
@property (nonatomic,strong) UIImageView *zanImageview;

@property (nonatomic,strong) NSMutableArray *commentArray;

@end

@implementation BFInterestCell

- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.layer.cornerRadius = 8*ScreenRatio;
        [_moreBtn setBackgroundColor:BFColor(234, 235, 236, 1)];
        _moreBtn.titleLabel.font = BFFontOfSize(15);
        [_moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UILabel *)zanLabel{
    if (!_zanLabel) {
        _zanLabel = [[UILabel alloc]init];
        _zanLabel.textColor = [UIColor blackColor];
        _zanLabel.textAlignment = NSTextAlignmentLeft;
        _zanLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _zanLabel;
}

- (UIImageView *)zanImageview{
    if (!_zanImageview) {
        _zanImageview = [[UIImageView alloc]init];
        _zanImageview.image = [UIImage imageNamed:@"zanselect"];
        _zanImageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zanImageview;
}

- (BFInterestCellImageView *)videoCover{
    if (!_videoCover) {
        BFInterestCellImageView *img = [[BFInterestCellImageView alloc] init];
        
        [self.contentView addSubview:img];
        _videoCover = img;
        img.backgroundColor = BFColor(234,237,240, 1);
        img.userInteractionEnabled = YES;
        __weak __typeof(self)weakSelf = self;
        img.homeTableCellVideoDidBeginPlayHandle = ^(UIButton *playBtn) {
//            if (weakSelf.searchCellFrame) {
//                if ([weakSelf.delegate respondsToSelector:@selector(homeTableViewCell:didClickVideoWithVideoUrl:videoCover:)]) {
//                    NHHomeServiceDataElementGroupLargeImageUrl *urlVideoModel = weakSelf.searchCellFrame.group.video_360P.url_list.firstObject;
//                    [weakSelf.delegate homeTableViewCell:weakSelf didClickVideoWithVideoUrl:urlVideoModel.url videoCover:weakSelf.videoCover];
//                }
//            } else {
                if ([weakSelf.videoDelegate respondsToSelector:@selector(homeTableViewCell:didClickVideoWithVideoUrl:videoCover:)]) {
//                    NHHomeServiceDataElementGroupLargeImageUrl *urlVideoModel = weakSelf.cellFrame.model.group.video_360P.url_list.firstObject;
//                    NSString *url = @"http://ic.snssdk.com/neihan/video/playback/?video_id=818a423f344b467b86623f34af175a7a&quality=360p&line=0&is_gif=0";
                    [weakSelf.videoDelegate homeTableViewCell:weakSelf didClickVideoWithVideoUrl:self.videourl videoCover:weakSelf.videoCover];
                }
//            }
        };
    }
    return _videoCover;
}

/*
- (BFBaseImageView *)largeImageCover {
    if (!_largeImageCover) {
        BFBaseImageView *img = [[BFBaseImageView alloc] init];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [self.contentView addSubview:img];
        _largeImageCover = img;
        img.backgroundColor = BFColor(234, 237, 240, 1);
        img.userInteractionEnabled  = YES;
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverImageTapGest:)]];
    }
    return _largeImageCover;
}
 */

- (UIImageView *)largeImageCover{
    if (!_largeImageCover) {
        _largeImageCover = [[UIImageView alloc]init];
        _largeImageCover.userInteractionEnabled = YES;
        _largeImageCover.contentMode = UIViewContentModeScaleAspectFill;
        _largeImageCover.clipsToBounds = YES;
        [self.contentView addSubview:_largeImageCover];
        _largeImageCover.backgroundColor = BFColor(234, 237, 240, 1);
        UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverImageTapGest:)];
        tapgest.numberOfTapsRequired = 2;
        
        [_largeImageCover addGestureRecognizer:tapgest];

    }
    return _largeImageCover;
}

- (void)coverImageTapGest:(UITapGestureRecognizer *)tapGest {
    /*
    NHBaseImageView *imageView = (NHBaseImageView *)tapGest.view;
    NHHomeServiceDataElementGroupLargeImageUrl *urlModel = nil;
    if (self.cellFrame) {
        urlModel = self.cellFrame.model.group.large_image.url_list.firstObject;
    } else {
        urlModel = self.searchCellFrame.group.large_image.url_list.firstObject;
    }
    if (!urlModel) return;
    
    if ([self.delegate respondsToSelector:@selector(homeTableViewCell:didClickImageView:currentIndex:urls:)]) {
        [self.delegate homeTableViewCell:self didClickImageView:imageView currentIndex:0 urls:@[[NSURL URLWithString:urlModel.url]]];
    }
     */
    if (!zanBtn.selectImgview.highlighted) {
        [zanBtn dongtaiClick:zanBtn.pressBtn];
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    self.backgroundColor = BFColor(234, 235, 236, 1);
    
    backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    icon = [[UIImageView alloc]init];
    icon.userInteractionEnabled = YES;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    [backView addSubview:icon];
    [icon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectUserIcon:)]];
    
    nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = BFFontOfSize(16);
    [backView addSubview:nameLabel];
    
    self.guanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanzhuBtn.tag = 999 + 6;
    [self.guanzhuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"guanzhulogo"] forState:UIControlStateNormal];
    [backView addSubview:self.guanzhuBtn];
    
    fromPlaceLabel = [[UILabel alloc]init];
    fromPlaceLabel.textColor = [UIColor grayColor];
    fromPlaceLabel.textAlignment = NSTextAlignmentLeft;
    fromPlaceLabel.font = BFFontOfSize(15);
    [backView addSubview:fromPlaceLabel];
    
    timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = BFFontOfSize(13);
    [backView addSubview:timeLabel];
    
    locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locateBtn.tag = 999 + 1;
    locateBtn.layer.cornerRadius = 8*ScreenRatio;
    [locateBtn setBackgroundColor:BFColor(234, 235, 236, 1)];
    locateBtn.titleLabel.font = BFFontOfSize(13);
    [locateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [locateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:locateBtn];
    
    /*
    statementLabel = [[UILabel alloc]init];
    statementLabel.font = BFFontOfSize(16);
    statementLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = statementLabel.font.lineHeight * 3;
    }
    statementLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:statementLabel];
    */
    statementLabel = [MLEmojiLabel new];
    statementLabel.numberOfLines = 0;
    statementLabel.font = [UIFont systemFontOfSize:17.0f];
    statementLabel.delegate = self;
    statementLabel.textAlignment = NSTextAlignmentLeft;
    statementLabel.backgroundColor = [UIColor clearColor];
    statementLabel.isNeedAtAndPoundSign = YES;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = statementLabel.font.lineHeight * 3;
    }
    
    //测试TTT原生方法
//    [statementLabel addLinkToURL:[NSURL URLWithString:@"http://sasasadan.com"] withRange:[statementLabel.text rangeOfString:@"TableView"]];
    
    //这句测试剪切板
    [statementLabel performSelector:@selector(copy:) withObject:nil afterDelay:0.01f];
    [backView addSubview:statementLabel];

    
    line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line];
    
    botmSecline = [[UIView alloc]init];
    botmSecline.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:botmSecline];
    
    zanBtn = [[BFButtonView alloc]initButtonFrame:CGRectMake(0, 0, 45*ScreenRatio, 45*ScreenRatio) imgRect:CGRectMake(0, 0, 18*ScreenRatio, 18*ScreenRatio) img:@"zan" btntag:999 + 2];
    zanBtn.delegate = self;
    [backView addSubview:zanBtn];
    
    commentBtn = [[BFButtonView alloc]initButtonFrame:CGRectMake(0, 0, 45*ScreenRatio, 45*ScreenRatio) imgRect:CGRectMake(0, 0, 18*ScreenRatio, 18*ScreenRatio) img:@"comment" btntag:999 + 3];
    commentBtn.delegate = self;
    [backView addSubview:commentBtn];

    /*
    shareBtn = [[BFButtonView alloc]initButtonFrame:CGRectMake(0, 0, 45*ScreenRatio, 45*ScreenRatio) imgRect:CGRectMake(0, 0, 18*ScreenRatio, 18*ScreenRatio) img:@"share" btntag:999 + 4];
    shareBtn.delegate = self;

    [backView addSubview:shareBtn];
     */
     
    jubaoBtn = [[BFButtonView alloc]initButtonFrame:CGRectMake(0, 0, 45*ScreenRatio, 45*ScreenRatio) imgRect:CGRectMake(0, 0, 18*ScreenRatio, 18*ScreenRatio) img:@"detailpoint" btntag:999 + 4];
    jubaoBtn.delegate = self;
    [backView addSubview:jubaoBtn];
    
    
    allComBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allComBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    allComBtn.titleLabel.font = BFFontOfSize(17);
    allComBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    allComBtn.tag = 999 + 7;
    [allComBtn addTarget:self action:@selector(allCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:allComBtn];
    allComBtn.hidden = YES;

}

- (void)allCommentBtnClick:(UIButton *)btn{
    if ([self.videoDelegate respondsToSelector:@selector(commentBtnClickWithCell:)]) {
        [self.videoDelegate commentBtnClickWithCell:self];
    }
}

- (void)dongtaiButton:(UIImageView *)btn btnimg:(BFButtonView *)btnview{
    if (btnview.tag == 999 + 3) {
        // 评论
        if ([self.videoDelegate respondsToSelector:@selector(commentBtnClickWithCell:)]) {
            [self.videoDelegate commentBtnClickWithCell:self];
        }
    }else if (btnview.tag == 999 + 2){
        // 点赞
        BFInterestModel *cellModel = self.cellModel;
        if (btn.highlighted) {
            cellModel.zan += 1;
            cellModel.is_zan = YES;
        }else{
            cellModel.is_zan = NO;
            cellModel.zan -= 1;
        }
        if ([self.videoDelegate respondsToSelector:@selector(zanBtnClickWithcell:model:)]) {
            [self.videoDelegate zanBtnClickWithcell:self model:cellModel];
        }
    }else if (btnview.tag == 999 + 4){
        // 举报
        if ([self.videoDelegate respondsToSelector:@selector(jubaoBtnClikWithCell:)]) {
            [self.videoDelegate jubaoBtnClikWithCell:self];
        }
    }
}

- (void)setModelFrame:(BFInterestModelFrame *)modelFrame{
    _modelFrame = modelFrame;
    BFInterestModel *cellModel = modelFrame.interestModel;
    self.cellModel = cellModel;
    self.shrink = modelFrame.shrinkMore;
    self.isMore = modelFrame.haveMoreBtn;
    [backView addSubview:self.moreBtn];
    if ([cellModel.type isEqualToString:@"I"]){
        [self.videoCover removeFromSuperview];
        self.videoCover = nil;
//        [self.largeImageCover setImageWithUrl:cellModel.resource];
        [self.largeImageCover sd_setImageWithURL:[NSURL URLWithString:cellModel.resource]];
    }else{
        [self.largeImageCover removeFromSuperview];
        self.largeImageCover = nil;
        self.videourl = cellModel.resource;
        [self.videoCover setImageWithURL:[NSURL URLWithString:cellModel.video_index]];
    }
    if (self.isMore && modelFrame.shrinkMore) {
        [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        statementLabel.numberOfLines = 3;

    }else if(self.isMore && !modelFrame.shrinkMore){
        [self.moreBtn setTitle:@"收回" forState:UIControlStateNormal];
        statementLabel.numberOfLines = 0;
    }else{
        [self.moreBtn setTitle:@"" forState:UIControlStateNormal];
        statementLabel.numberOfLines = 0;
    }
    
    if (modelFrame.haszan) {
        zanBtn.isZan = cellModel.is_zan;
        [backView addSubview:self.zanImageview];
        [backView addSubview:self.zanLabel];
        self.zanLabel.text = [NSString stringWithFormat:@"%ld次赞",cellModel.zan];
    }
    
    [icon sd_setImageWithURL:[NSURL URLWithString:cellModel.head_image]];
    nameLabel.text = cellModel.nikename;
    timeLabel.text = [[NSString alloc]distanceTimeWithBeforeTime:[cellModel.publish_datetime doubleValue]];
//    statementLabel.attributedText = [NSString attStringWithString:cellModel.message keyWord:@""];
    statementLabel.text = cellModel.message;
    fromPlaceLabel.text = cellModel.location;
    mainPic.image = [UIImage imageNamed:cellModel.resource];
    [locateBtn setTitle:cellModel.location forState:UIControlStateNormal];
    CGRect titleRec = [cellModel.location boundingRectWithSize:CGSizeMake(100*ScreenRatio, 16*ScreenRatio) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:BFFontOfSize(13)} context:nil];
    self.locaRec = titleRec;
    
    if (modelFrame.interestModel.comments.count != 0) {
        UILabel *label = [backView viewWithTag:77];
        [label removeFromSuperview];
        UILabel *label2 = [backView viewWithTag:78];
        [label2 removeFromSuperview];
        
        allComBtn.hidden = NO;

        allComBtn.frame = modelFrame.comNumFrame;
        NSString *title = [NSString stringWithFormat:@"所有%ld条评论",modelFrame.interestModel.comments_num];
        [allComBtn setTitle:title forState:UIControlStateNormal];
        
        NSInteger comCount = modelFrame.interestModel.comments.count > 2 ? 2 : modelFrame.interestModel.comments.count;
        
        for (int i = 0; i < comCount; i ++) {
            NSDictionary *comdic = modelFrame.interestModel.comments[i];
//            CGRect labelrect = [modelFrame.commentFrameArray[i] CGRectValue];
            UILabel *label = [[UILabel alloc]initWithFrame:[modelFrame.commentFrameArray[i] CGRectValue]];
            label.tag = 77 + i;
            label.font = BFFontOfSize(17);
            label.textColor = [UIColor blackColor];
            
            [backView addSubview:label];
            
            NSString *string;
            NSString *reply_user = comdic[@"reply_user"];
            if (reply_user.length > 0) {
                string = [NSString stringWithFormat:@"%@回复%@ %@",comdic[@"nikename"],comdic[@"reply_user_nikename"],comdic[@"message"]];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
                
                [attributeString addAttribute:NSForegroundColorAttributeName value:BFColor(19, 53, 114, 1) range:[string rangeOfString:comdic[@"reply_user_nikename"]]];
                label.attributedText = attributeString;
                
            }else{
                label.text = [NSString stringWithFormat:@"%@: %@",comdic[@"nikename"],comdic[@"message"]];

            }
            
        }
    }else{
        allComBtn.hidden = YES;
        UILabel *label = [backView viewWithTag:77];
        [label removeFromSuperview];
        UILabel *label2 = [backView viewWithTag:78];
        [label2 removeFromSuperview];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    backView.frame = CGRectMake(0, 0, Screen_width, self.height - 5*ScreenRatio);
    icon.frame = self.modelFrame.iconFrame;
    icon.layer.cornerRadius = self.modelFrame.iconFrame.size.width/2;
    icon.layer.masksToBounds = YES;
    nameLabel.frame = self.modelFrame.nameFrame;
//    guanzhuBtn.frame = self.modelFrame.guanzhuFrame;
    fromPlaceLabel.frame = self.modelFrame.fromPlaceFrame;
    timeLabel.frame = self.modelFrame.timeFrame;
//    upline.frame = self.modelFrame.uplineFrame;
    if ([_cellModel.type isEqualToString:@"I"]){
        self.largeImageCover.frame = self.modelFrame.videoFrame;
    }else{
        self.videoCover.frame = self.modelFrame.videoFrame;
    }
    locateBtn.frame = self.modelFrame.locateFrame;
    statementLabel.frame = self.modelFrame.stateFrame;
    self.moreBtn.frame = self.modelFrame.moreBtnFrame;
    zanBtn.frame = self.modelFrame.zanFrame;
    jubaoBtn.frame = self.modelFrame.jubaoFrame;
//    CGFloat spacing = (Screen_width - 20*ScreenRatio*2 - 45*ScreenRatio*3)/2;
    botmSecline.frame = self.modelFrame.botlineSecFrame;
    self.zanImageview.frame = self.modelFrame.zanLogoFrame;
    self.zanLabel.frame = self.modelFrame.zanNumFrame;
    commentBtn.frame = self.modelFrame.commentFrame;
    shareBtn.frame = self.modelFrame.shareFrame;
    line.frame = self.modelFrame.botlineFrame;
    comtView.frame = self.modelFrame.replyFrame;
}

- (void)moreClick:(UIButton *)btn{
    if ([self.videoDelegate respondsToSelector:@selector(moreBtnClick:withCell:isHaveMore:)]) {
        [self.videoDelegate moreBtnClick:statementLabel withCell:self isHaveMore:!self.shrink];
    }
    self.shrink = !self.shrink;
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            if ([self.videoDelegate respondsToSelector:@selector(selectTopics:linkstr:)]) {
                [self.videoDelegate selectTopics:MLEmojiLabelLinkTypePoundSign linkstr:link];
            }
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}

- (void)selectUserIcon:(UITapGestureRecognizer *)recg{
    if ([self.videoDelegate respondsToSelector:@selector(selectUserIcon:)]) {
        [self.videoDelegate selectUserIcon:self.cellModel.uid];
    }
}

@end
