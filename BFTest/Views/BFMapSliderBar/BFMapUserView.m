//
//  BFMapUserView.m
//  BFTest
//
//  Created by 伯符 on 16/9/18.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFMapUserView.h"
#import "MapUserInfoCell.h"
#import "BFDataGenerator.h"
#import "BFMapSellerCell.h"
#import "BFChatViewController.h"
@interface BFMapUserView ()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView *userIcon;
    UILabel *username;
    UILabel *jmuid;
    UILabel *address;
    UIView *view2;
    UIImageView *genderView;
    UILabel *ageLabel;
    UIImageView *rankView;
    UIImageView *vipView;
    UIButton *selladd;
}
@property (nonatomic,strong) NSArray *daArray;

@property (nonatomic,strong) MPMoviePlayerController *player;

@property (nonatomic,strong) NSMutableArray *imgsArray;

@property (nonatomic,assign) BOOL videopath;
@end

@implementation BFMapUserView

- (NSMutableArray *)imgsArray{
    if (!_imgsArray) {
        _imgsArray = [NSMutableArray array];
        
    }
    return _imgsArray;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    NSLog(@"ffffff");
    [self getPlayerNotifications];
    
    [self.player play];
}
- (void)getPlayerNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerStateChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self.player pause];

     [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
//        self.daArray = @[@{@"firstTl":@"关注",@"secTl":@"粉丝"},@{@"firstTl":@"送礼",@"secTl":@"收礼"}];
        self.videopath = NO;
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"UserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];

        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*ScreenRatio, 5*ScreenRatio, self.width - 30*ScreenRatio, 20*ScreenRatio)];
        titleLabel.tag = 100;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
    }
    UILabel *titleLabel = [cell viewWithTag:100];
    titleLabel.text = _model.signature;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *usernameStr = _model.name;
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    header.backgroundColor = [UIColor clearColor];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(self.width - 25*ScreenRatio, 10, 17*ScreenRatio, 17*ScreenRatio);
    [deleteBtn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:deleteBtn];
    
    userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2 - 30*ScreenRatio, 10*ScreenRatio, 60*ScreenRatio, 60*ScreenRatio)];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:BFIcomImg];
    userIcon.layer.cornerRadius = 30*ScreenRatio;
    userIcon.contentMode = UIViewContentModeScaleAspectFill;
    userIcon.clipsToBounds = YES;
    [header addSubview:userIcon];
    userIcon.userInteractionEnabled = YES;
    [userIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapiconToUser:)]];
    
    if (self.videopath) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BridgeLoop-640p.mp4" ofType:nil]];
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [self.player setControlStyle:MPMovieControlStyleNone];
        [self.player prepareToPlay];
        [self.player.view setFrame:userIcon.bounds];
        self.player.view.layer.cornerRadius = 30*ScreenRatio;

        [userIcon addSubview:self.player.view];
        [userIcon sendSubviewToBack:self.player.view];
        self.player.scalingMode = MPMovieScalingModeAspectFill;
    }
    // 关注按钮
    selladd = [UIButton buttonWithType:UIButtonTypeCustom];
    selladd.frame = CGRectMake(CGRectGetMaxX(userIcon.frame)+10*ScreenRatio, CGRectGetMaxY(userIcon.frame) - 20*ScreenRatio, 20*ScreenRatio, 20*ScreenRatio);
    [selladd addTarget:self action:@selector(foucs:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:selladd];
    NSDictionary *relations = _model.relations;
    if (relations == nil || [relations[@"follow"] intValue] == 0) {
        self.hasfocus = NO;
    }else{
        self.hasfocus = YES;
    }
    
    CGSize nameSz = [usernameStr boundingRectWithSize:CGSizeMake(100*ScreenRatio, 25*ScreenRatio) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:BFFontOfSize(16)} context:0].size;
    username = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, nameSz.width + 10*ScreenRatio, 20*ScreenRatio)];
    username.center = CGPointMake(self.width/2, CGRectGetMaxY(userIcon.frame)+ 15*ScreenRatio);
    username.text = usernameStr;
    username.textColor = [UIColor whiteColor];
    username.font = [UIFont boldSystemFontOfSize:16];
    username.textAlignment = NSTextAlignmentCenter;
    [header addSubview:username];

    rankView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*ScreenRatio, 29*ScreenRatio)];
    rankView.center = CGPointMake(self.width/2, CGRectGetMaxY(username.frame)+ 15*ScreenRatio);
    rankView.contentMode = UIViewContentModeScaleAspectFit;
    
    rankView.image = [UIImage imageNamed:@"rank001-1"];
    NSString *imgStr;
    if ([_model.grade isEqualToString:@""]) {
        imgStr = [NSString stringWithFormat:@"rank001-0"];
    }else{
        imgStr = [NSString stringWithFormat:@"rank001-%@",_model.grade];
    }
    rankView.image = [UIImage imageNamed:imgStr];
    [header addSubview:rankView];
    
    genderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*ScreenRatio, 29*ScreenRatio)];
    genderView.center = CGPointMake(self.width/2 - CGRectGetWidth(rankView.frame) - 5*ScreenRatio, CGRectGetMaxY(username.frame)+ 15*ScreenRatio);
    genderView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *sex;
    if ([_model.sex isEqualToString:@"1"]) {
        sex = [NSString stringWithFormat:@"matchfemale"];
    }else{
        sex = [NSString stringWithFormat:@"matchmale"];
    }
    genderView.image = [UIImage imageNamed:sex];
    [header addSubview:genderView];

    vipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*ScreenRatio, 29*ScreenRatio)];
    vipView.center = CGPointMake(self.width/2 + CGRectGetWidth(rankView.frame) + 5*ScreenRatio, CGRectGetMaxY(username.frame)+ 15*ScreenRatio);
    vipView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *vipStr;
    if ([_model.vipGrade isEqualToString:@""] || _model.vipGrade == nil) {
        vipStr = [NSString stringWithFormat:@"vip0"];
    }else{
        vipStr = [NSString stringWithFormat:@"vip%@",_model.vipGrade];
    }
    vipView.image = [UIImage imageNamed:vipStr];
    [header addSubview:vipView];
    
    ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*ScreenRatio, 0, 20*ScreenRatio, 29*ScreenRatio)];
    ageLabel.backgroundColor = [UIColor clearColor];
    ageLabel.text = _model.age;
    ageLabel.textColor = [UIColor whiteColor];
    ageLabel.textAlignment = NSTextAlignmentRight;
    ageLabel.font = [UIFont boldSystemFontOfSize:9];
    [genderView addSubview:ageLabel];
    
    address = [[UILabel alloc]initWithFrame:CGRectMake(20*ScreenRatio,  CGRectGetMaxY(genderView.frame), 55*ScreenRatio, 15*ScreenRatio)];
    if ([_model.haunt isKindOfClass:[NSString class]]) {
//        address.text = _model.haunt;
    }
    address.textColor = [UIColor whiteColor];
    address.textAlignment = NSTextAlignmentCenter;
    address.font = BFFontOfSize(15);
    [header addSubview:address];
    
//    UILabel *jinmaiNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60*ScreenRatio, 15*ScreenRatio)];
//    jinmaiNum.center = CGPointMake(self.width/2 - 30*ScreenRatio - 5*ScreenRatio, CGRectGetMaxY(genderView.frame)+7*ScreenRatio);
//    jinmaiNum.text = @"近脉号:";
//    jinmaiNum.textColor = [UIColor grayColor];
//    jinmaiNum.textAlignment = NSTextAlignmentRight;
//    jinmaiNum.font = BFFontOfSize(15);
//    [header addSubview:jinmaiNum];
//    
//    jmuid = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*ScreenRatio, 15*ScreenRatio)];
//    jmuid.center = CGPointMake(self.width/2 + 40*ScreenRatio, CGRectGetMaxY(genderView.frame)+7*ScreenRatio);
//    jmuid.text = _model.jmid;
//    jmuid.textColor = [UIColor grayColor];
//    jmuid.textAlignment = NSTextAlignmentCenter;
//    jmuid.font = BFFontOfSize(15);
//    [header addSubview:jmuid];
    
//    UILabel *assign = [[UILabel alloc]initWithFrame:CGRectMake( 7*ScreenRatio, CGRectGetMaxY(jmuid.frame)+10*ScreenRatio, CGRectGetWidth(header.frame) - 14*ScreenRatio, 15*ScreenRatio)];
//    assign.text = [NSString stringWithFormat:@"深圳市sd撒撒气二二就看见是打深大色粉开撒打算的分"];
//    assign.textColor = [UIColor grayColor];
//    assign.textAlignment = NSTextAlignmentCenter;
//    assign.font = BFFontOfSize(13);
//    [header addSubview:assign];
    
    /*
    if (addresStr != nil && addresStr.length > 0) {
        [userIcon sd_setImageWithURL:[NSURL URLWithString:self.sellDic[@"logo"]] placeholderImage:nil];
        username.text = sellnameStr;
        address.text = addresStr;
    }else{
        userIcon.image = [UIImage imageNamed:@"starbucks"];
        username.text = @"探鱼海岸城店";
        address.text = @"南山区文新路33号海岸城西座";
    }
     */
    
    return header;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    footview.backgroundColor = [UIColor clearColor];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 6*ScreenRatio)];
    line.image = [UIImage imageNamed:@"lineflower"];
    line.contentMode = UIViewContentModeScaleAspectFit;
    NSArray *activityPhotos = _model.listUserPhotos;
    CGFloat photoWidth = (self.width - 2*5)/4;
    if (activityPhotos.count > 1) {

        for (int i = 1; i < activityPhotos.count; i ++) {
            UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(2 + (photoWidth + 2) * (i - 1), CGRectGetMaxY(line.frame)+5*ScreenRatio, photoWidth, photoWidth)];
            imgv.contentMode = UIViewContentModeScaleAspectFill;
            imgv.clipsToBounds = YES;
            [imgv sd_setImageWithURL:[NSURL URLWithString:activityPhotos[i]] placeholderImage:nil];
            [footview addSubview:imgv];
        }
    }else{
        UILabel *dongtaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 190, 20)];
        dongtaiLabel.center = CGPointMake(footview.width/2, (self.width - 2*5)/8+8*ScreenRatio);
        dongtaiLabel.text = @"该用户还没发布更多照片";
        dongtaiLabel.textAlignment = NSTextAlignmentCenter;
        dongtaiLabel.textColor = [UIColor whiteColor];
        dongtaiLabel.font = [UIFont boldSystemFontOfSize:16];
        [footview addSubview:dongtaiLabel];
    }
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+10*ScreenRatio + photoWidth, self.width, 6*ScreenRatio)];
    line2.image = [UIImage imageNamed:@"lineflower"];
    line2.contentMode = UIViewContentModeScaleAspectFit;
    [footview addSubview:line2];
    [footview addSubview:line];

    UIButton *matchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    matchBtn.frame = CGRectMake(0,0, 60*ScreenRatio, 20*ScreenRatio);
    matchBtn.center = CGPointMake(self.width/2, 120*ScreenRatio - 20*ScreenRatio);
    [matchBtn setImage:[UIImage imageNamed:@"liaoliaologo"] forState:UIControlStateNormal];
    [matchBtn addTarget:self action:@selector(gotochat:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:matchBtn];
    
    return footview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 135*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30*ScreenRatio;
}

- (void)reportClick:(UIButton *)btn{
    NSLog(@"reportClick");
}

- (void)foucs:(UIButton *)tap{
    
    NSString *jmid = _model.jmid;
    if ([self.userDelegate respondsToSelector:@selector(focusUserID:)]) {
        [self.userDelegate focusUserID:jmid];
    }
}

- (void)delete:(UIButton *)btn{
    if ([self.userDelegate respondsToSelector:@selector(userDeleteClick:)]) {
        [self.userDelegate userDeleteClick:btn];
    }
}

- (void)showMapAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, - kMapShowHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setSellDic:(NSDictionary *)sellDic{
    _sellDic = sellDic;
    [self reloadData];
}


- (void)setModel:(BFUserInfoModel *)model{
    _model = model;
    [self reloadData];

}

- (void)setHasfocus:(BOOL)hasfocus{
    if (hasfocus) {
        [selladd setImage:[UIImage imageNamed:@"hasfocus"] forState:UIControlStateNormal];
        selladd.enabled = NO;
    }else{
        [selladd setImage:[UIImage imageNamed:@"selladd"] forState:UIControlStateNormal];
        selladd.enabled = YES;

    }
}

- (void)moviePlayerStateChangeNotification:(NSNotification *)notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    switch (playbackState) {
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped:
        case MPMoviePlaybackStateInterrupted:{
            moviePlayer.controlStyle = MPMovieControlStyleNone;
            [self.player play];
            break;
        }
        default:
            break;
    }
}


- (void)gotochat:(UIButton *)btn{
    
    NSString *jmid = _model.jmid;
    NSString *nickename = _model.name;
    NSString *usericon = _model.photo;
    if ([self.userDelegate respondsToSelector:@selector(pushtoUserChatID:nickname:icon:)]) {
        [self.userDelegate pushtoUserChatID:jmid nickname:nickename icon:usericon];
    }

}

- (void)tapiconToUser:(UITapGestureRecognizer *)tap{
    NSString *jmid = _model.jmid;
    NSString *nickename = _model.name;

    if ([self.userDelegate respondsToSelector:@selector(pushtoUserMain:name:)]) {
        [self.userDelegate pushtoUserMain:jmid name:nickename];
    }
}

@end
