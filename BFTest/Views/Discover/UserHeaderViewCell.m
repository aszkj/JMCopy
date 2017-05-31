//
//  UserHeaderViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserHeaderViewCell.h"
#import "UserSettingController.h"
#import "AdView.h"
#import "ConstellationUtilities.h"
@interface UserHeaderViewCell (){
    
    UIImageView *genderView;
    UIImageView *constellationView;
    UILabel *constellationLabel;
    UILabel *ageLabel;
    UILabel *distimeLabel;
    UILabel *likeNumLabel;
    UILabel *relationshipLabel;
    UIImageView *heard;
    UIView *botline;
    UILabel *label;
}
@property (nonatomic,strong) NSMutableArray *imgsUrlAr;

@property (nonatomic,strong) AdView *adView;
@end
@implementation UserHeaderViewCell

- (AdView *)adView{
    if (!_adView) {
        _adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, Screen_width, Screen_width) imageLinkURL:self.imgsUrlAr placeHoderImageName:nil pageControlShowStyle:UIPageControlShowStyleBottom];
        _adView.scrollEnabled = NO;
        //    [adView setAdTitleArray:self.titleAr withShowStyle:AdTitleShowStyleCenter];
        //        __weak UserHeaderViewCell *headerCell = self;
        _adView.callBack = ^(NSInteger index,NSString * imageURL)
        {
            // 点击轮播图跳转
            //            if ([headerCell.delegate respondsToSelector:@selector(selectScrollImg)]) {
            //                [headerCell.delegate selectScrollImg];
            //            }
        };
    }
    return _adView;
}

- (NSMutableArray *)imgsUrlAr{
    if (!_imgsUrlAr) {
        _imgsUrlAr = [NSMutableArray array];
    }
    return _imgsUrlAr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_width, Screen_width, 90*ScreenRatio)];
        genderView = [[UIImageView alloc]initWithFrame:CGRectMake(15*ScreenRatio, 10*ScreenRatio, 43*ScreenRatio, 18*ScreenRatio)];
        genderView.contentMode = UIViewContentModeScaleToFill;
        genderView.clipsToBounds = NO;
        [bottomView addSubview:genderView];
        
        constellationView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(genderView.frame) + 7, 10*ScreenRatio, 23*ScreenRatio, 18*ScreenRatio)];
        constellationView.contentMode = UIViewContentModeScaleAspectFill;
        constellationView.clipsToBounds = NO;
        [bottomView addSubview:constellationView];
        
        constellationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(constellationView.frame), 10*ScreenRatio, 50*ScreenRatio, 18*ScreenRatio)];
        constellationLabel.textColor = [UIColor blackColor];
        constellationLabel.textAlignment = NSTextAlignmentCenter;
        constellationLabel.font = BFFontOfSize(15);
        [bottomView addSubview:constellationLabel];
        
        relationshipLabel = [[UILabel alloc]init];
        relationshipLabel.backgroundColor = BFColor(243, 211, 14, 1);
        relationshipLabel.layer.cornerRadius = 6;
        relationshipLabel.layer.masksToBounds = YES;
        relationshipLabel.textColor = [UIColor blackColor];
        relationshipLabel.textAlignment = NSTextAlignmentCenter;
        relationshipLabel.font = BFFontOfSize(15);
        [bottomView addSubview:relationshipLabel];
        
        ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(genderView.frame) - 10, 18*ScreenRatio)];
        ageLabel.backgroundColor = [UIColor clearColor];
        ageLabel.textColor = [UIColor whiteColor];
        ageLabel.textAlignment = NSTextAlignmentCenter;
        ageLabel.font = [UIFont boldSystemFontOfSize:14];
        [genderView addSubview:ageLabel];
        
        distimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width - 150, 10*ScreenRatio, 135, 20*ScreenRatio)];
        distimeLabel.backgroundColor = [UIColor clearColor];
        distimeLabel.textColor = [UIColor lightGrayColor];
        distimeLabel.textAlignment = NSTextAlignmentRight;
        distimeLabel.font = BFFontOfSize(14);
        [bottomView addSubview:distimeLabel];
        
        botline = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(genderView.frame)+10*ScreenRatio, Screen_width, 2)];
        botline.backgroundColor = BFColor(243, 243, 242, 1);
        [bottomView addSubview:botline];

        heard = [[UIImageView alloc]initWithFrame:CGRectMake(15*ScreenRatio, CGRectGetMaxY(botline.frame)+10*ScreenRatio, 20*ScreenRatio, 20*ScreenRatio)];
        heard.contentMode = UIViewContentModeScaleAspectFill;
        heard.clipsToBounds = NO;
        heard.image = [UIImage imageNamed:@"heartred"];
        [bottomView addSubview:heard];
        
        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(heard.frame)+10*ScreenRatio, CGRectGetMaxY(botline.frame)+10*ScreenRatio, 0, 20*ScreenRatio)];
        likeNumLabel.font = BFFontOfSize(18);
        likeNumLabel.textColor = [UIColor redColor];
        likeNumLabel.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:likeNumLabel];
        
        label = [[UILabel alloc]init];
        label.font = BFFontOfSize(14);
        label.text = @"人喜欢了你";
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:label];
        
        
        [self.contentView addSubview:bottomView];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    
    NSString *otherbmp = dic[@"otherbmp"];
    NSArray *imgArray = [otherbmp componentsSeparatedByString:@","];
    for (NSString *str in imgArray) {
        if (str.length > 0) {
            [self.imgsUrlAr addObject:str];
        }
    }
    NSString *iconImg = dic[@"mybmp"];
    if (iconImg && iconImg.length > 0) {
        [self.imgsUrlAr insertObject:iconImg atIndex:0];
    }
    if (self.imgsUrlAr.count != 0) {
        [self.contentView addSubview:self.adView];
    }
    if ([dic[@"sex"] isEqualToString:@"女"]) {
        genderView.image = [UIImage imageNamed:@"matchfemale"];
    }else{
        genderView.image = [UIImage imageNamed:@"matchmale"];

    }

    
    NSString *constellation = dic[@"constellation"];
    NSString *emotionalstate = dic[@"emotionalstate"];
    ageLabel.text = dic[@"age"];
    constellationView.image = [ConstellationUtilities returnImgBase:constellation];
    constellationLabel.text = constellation;
    if (emotionalstate.length > 0) {
        relationshipLabel.text = dic[@"emotionalstate"];

    }else{
        relationshipLabel.text = @"保密";
    }
    CGFloat relationWidth = [relationshipLabel.text getWidthWithHeight:18*ScreenRatio font:15];
    relationshipLabel.frame = CGRectMake(CGRectGetMaxX(constellationLabel.frame) + 7, 10*ScreenRatio, relationWidth, 18*ScreenRatio);
    NSString *likenum = [NSString stringWithFormat:@"%@",dic[@"like"]];
    CGRect labelRt = [likenum boundingRectWithSize:CGSizeMake(MAXFLOAT, 20*ScreenRatio) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:BFFontOfSize(18),NSForegroundColorAttributeName:[UIColor redColor]} context:nil];
    likeNumLabel.text = [NSString stringWithFormat:@"%@",dic[@"like"]];
    likeNumLabel.frame = CGRectMake(CGRectGetMaxX(heard.frame)+10*ScreenRatio, CGRectGetMaxY(botline.frame)+10*ScreenRatio, labelRt.size.width, 20*ScreenRatio);
    label.frame = CGRectMake(CGRectGetMaxX(likeNumLabel.frame)+5*ScreenRatio, CGRectGetMaxY(botline.frame)+10*ScreenRatio, 100*ScreenRatio, 20*ScreenRatio);
    distimeLabel.text = [[NSString alloc]distanceTimeWithBeforeTime:[dic[@"time"] doubleValue]];

}

+ (NSInteger)getUserHeaderHeight{
    return Screen_width + 90*ScreenRatio;
}

@end
