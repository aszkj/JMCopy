//
//  BFMatchView.m
//  BFTest
//
//  Created by 伯符 on 17/1/5.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFMatchView.h"
#import "VIGRadarView.h"
#import "CHCardView.h"
#import "CHCardItemView.h"
#import "CHCardItemModel.h"
#import "YYModel.h"

@interface BFMatchView ()<CHCardViewDelegate, CHCardViewDataSource>{
    UILabel *mark;
    UIImageView *backimg;
    UIImageView *deleteicon;
    UIView *matchback;
    UIView *successback;
    NSString *userimg;
    CHCardItemModel *otherModel;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) VIGRadarView *radarView;

@property (nonatomic, weak) CHCardView *cardView;

@end
@implementation BFMatchView

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        
        deleteicon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*ScreenRatio, 10*ScreenRatio)];
        deleteicon.userInteractionEnabled = YES;
        deleteicon.center = CGPointMake(frame.size.width - 15*ScreenRatio, 15*ScreenRatio);
        deleteicon.contentMode = UIViewContentModeScaleToFill;
        deleteicon.clipsToBounds = YES;
        deleteicon.image = [UIImage imageNamed:@"chahao"];
        [self addSubview:deleteicon];
        
        self.settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0*ScreenRatio, 5*ScreenRatio, 50*ScreenRatio, 25*ScreenRatio)];
        self.settingBtn.hidden = YES;
        [self addSubview:self.settingBtn];
        [self.settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        [self.settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.settingBtn.titleLabel.font = BFFontOfSize(14);
        [self.settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(frame.size.width - 55*ScreenRatio, 0, 55*ScreenRatio, 30*ScreenRatio);
        [deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
    return self;
}

- (void)btnClick:(UIButton *)tap{
    if ([self.delegate respondsToSelector:@selector(matchDeleteClick:)]) {
        [self.delegate matchDeleteClick:tap];
    }
}

-(VIGRadarView *)radarView {
    if (!_radarView) {
        CGFloat wid = 200*ScreenRatio;
        _radarView = [[VIGRadarView alloc] initWithFrame:CGRectMake(self.width/2 - wid/2, self.height/2 - wid/2, wid, wid)];
        _radarView.scanSpeed = 0.5;
    }
    return _radarView;
}

- (void)startedRadarScan:(NSString *)imgstr{
    userimg = imgstr;
    if (matchback) {
        [matchback removeFromSuperview];
    }
    if (successback) {
        [successback removeFromSuperview];
    }
    backimg = [[UIImageView alloc]initWithFrame:self.bounds];
    backimg.image = [UIImage imageNamed:@"beijing.jpg"];
    backimg.contentMode = UIViewContentModeScaleAspectFill;
    backimg.clipsToBounds = YES;
    [self addSubview:backimg];
    UIImageView *header = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45*ScreenRatio, 45*ScreenRatio)];
    header.layer.cornerRadius = 45*ScreenRatio/2;
    header.layer.masksToBounds = YES;
    header.center = backimg.center;
    [header sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:BFIcomImg];
    header.contentMode = UIViewContentModeScaleAspectFill;
    header.clipsToBounds = YES;
    mark = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 25*ScreenRatio , self.width, 20*ScreenRatio)];
    mark.textAlignment = NSTextAlignmentCenter;
    mark.textColor = [UIColor whiteColor];
    mark.font = BFFontOfSize(13);
    mark.text = @"正在搜寻附近的人...";

    [backimg addSubview:self.radarView];
    [backimg addSubview:header];
    [self sendSubviewToBack:backimg];
    [backimg addSubview:mark];
    [self.radarView start];
}

- (void)showMatchUserview:(NSMutableArray *)data{
    matchback = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:matchback];
    [self sendSubviewToBack:matchback];
    
    CGFloat widbtn = 45*ScreenRatio;
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(widbtn, self.height - widbtn - 10*ScreenRatio, widbtn, widbtn)];
    [matchback addSubview:leftBtn];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"dislikeicon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(disLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 2 * widbtn, self.height - widbtn - 10*ScreenRatio, widbtn, widbtn)];
    [matchback addSubview:rightBtn];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"likeicon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.settingBtn.hidden = NO;
    [self bringSubviewToFront:self.settingBtn];
    [self loadData:data];
}

- (void)matchSuccessView:(NSDictionary *)dic userModel:(CHCardItemModel *)model{
    otherModel = model;
    self.settingBtn.hidden = YES;
    if (matchback) {
        [matchback removeFromSuperview];
        [_cardView removeFromSuperview];
        _cardView = nil;
    }
    if (backimg) {
        [backimg removeFromSuperview];
    }
    successback = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:successback];
    [self sendSubviewToBack:successback];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width - 40*ScreenRatio, 15*ScreenRatio)];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.center = CGPointMake(self.width/2, 40*ScreenRatio);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = [NSString stringWithFormat:@"你和%@互相喜欢了对方",model.name];

    [successback addSubview:titleLabel];
    
    UIImageView *icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 90*ScreenRatio)];
    icon1.center = CGPointMake(self.width/2 - 35*ScreenRatio, CGRectGetMaxY(titleLabel.frame)+50*ScreenRatio);
    icon1.layer.cornerRadius = 45*ScreenRatio;
    icon1.layer.borderColor = [UIColor whiteColor].CGColor;
    icon1.layer.borderWidth = 3;
    icon1.layer.masksToBounds = YES;
    icon1.contentMode = UIViewContentModeScaleToFill;
    icon1.clipsToBounds = YES;
    NSString *imgStr = [BFUserLoginManager shardManager].photo;
    NSLog(@"%@",imgStr);
    [icon1 sd_setImageWithURL:[NSURL URLWithString:imgStr]];

    [successback addSubview:icon1];
    
    
    UIImageView *icon2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 90*ScreenRatio)];
    icon2.center = CGPointMake(self.width/2 + 35*ScreenRatio, CGRectGetMaxY(titleLabel.frame)+50*ScreenRatio);
    icon2.layer.cornerRadius = 45*ScreenRatio;
    icon2.layer.borderColor = [UIColor whiteColor].CGColor;
    icon2.layer.borderWidth = 3;
    icon2.layer.masksToBounds = YES;
    icon2.contentMode = UIViewContentModeScaleToFill;
    icon2.clipsToBounds = YES;
    [icon2 sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    [successback addSubview:icon2];
    [successback bringSubviewToFront:icon1];
    UILabel *botlabel = [[UILabel alloc] initWithFrame:CGRectMake(20*ScreenRatio, CGRectGetMaxY(icon1.frame)+20*ScreenRatio, self.width - 40*ScreenRatio, 20*ScreenRatio)];
    botlabel.textAlignment = NSTextAlignmentCenter;
    botlabel.textColor = [UIColor whiteColor];
    botlabel.font = [UIFont systemFontOfSize:15];
    botlabel.text = @"得到约会券一张!到 我的卡包 查看";
    [successback addSubview:botlabel];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20*ScreenRatio, CGRectGetMaxY(botlabel.frame)+15*ScreenRatio, self.width - 40*ScreenRatio, 30*ScreenRatio)];
    [successback addSubview:sendBtn];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"sendicon"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendmsg:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *gosearch = [[UIButton alloc] initWithFrame:CGRectMake(20*ScreenRatio, CGRectGetMaxY(sendBtn.frame)+15*ScreenRatio, self.width - 40*ScreenRatio, 30*ScreenRatio)];
    [successback addSubview:gosearch];
    [gosearch setBackgroundImage:[UIImage imageNamed:@"searchicon2"] forState:UIControlStateNormal];
    [gosearch addTarget:self action:@selector(gosearch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)disLikeBtnClick:(UIButton *)btn {
    [self.cardView deleteTheTopItemViewWithLeft:YES matchview:self];
}

- (void)likeBtnClick:(UIButton *)btn {
    [self.cardView deleteTheTopItemViewWithLeft:NO matchview:self];
}

- (void)loadData:(NSMutableArray *)data {
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    for (NSDictionary *dic in data) {
        CHCardItemModel *itemModel = [CHCardItemModel yy_modelWithDictionary:dic];
        [self.dataArray addObject:itemModel];
    }
    [self.cardView reloadData];
    if (backimg) {
        [backimg removeFromSuperview];
    }

}


- (CHCardView *)cardView {
    if (!_cardView) {
        CHCardView *cardView = [[CHCardView alloc] initWithFrame:CGRectMake(30*ScreenRatio, 30*ScreenRatio, self.width - 60*ScreenRatio, self.width - 60*ScreenRatio)];
        [self addSubview:cardView];
        [self bringSubviewToFront:deleteicon];
        _cardView = cardView;
        cardView.delegate = self;
        cardView.dataSource = self;
    }
    return _cardView;
}

- (void)setTinktext:(NSString *)tinktext{
    _tinktext = tinktext;
    mark.text = tinktext;
}

#pragma mark - CHCardViewDelegate
- (NSInteger)numberOfItemViewsInCardView:(CHCardView *)cardView {
    return self.dataArray.count;
}

- (CHCardItemView *)cardView:(CHCardView *)cardView itemViewAtIndex:(NSInteger)index {
    CHCardItemView *itemView = [[CHCardItemView alloc] initWithFrame:cardView.bounds];
    itemView.matchView = self;
    itemView.itemModel = self.dataArray[index];
    return itemView;
}

- (void)cardViewNeedMoreData:(CHCardView *)cardView {

//    [self loadData:nil];
//
//    [self.cardView reloadData];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        if ([self.delegate respondsToSelector:@selector(achieveMoreData)]) {
            [self.delegate achieveMoreData];
        }
    });
    
}

- (void)settingBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(pushToSettingVC)]) {
        [self.delegate pushToSettingVC];
    }
}

- (void)sendmsg:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(pushtoUserChatID:nickname:icon:)]) {
        [self.delegate pushtoUserChatID:otherModel.jmid nickname:otherModel.name icon:otherModel.photo];
    }
}

- (void)gosearch:(UIButton *)btn{
//    [self startedRadarScan:userimg];
    if ([self.delegate respondsToSelector:@selector(achieveMoreData)]) {
        [self.delegate achieveMoreData];
    }

}

@end
