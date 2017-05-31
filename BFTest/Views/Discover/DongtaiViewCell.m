//
//  DongtaiViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "DongtaiViewCell.h"
@interface  DongtaiViewCell(){
    UILabel *num;
//    UIButton *addbtn;
    UIImageView *addview;
    UILabel *dongtaiLabel;
}

@property (nonatomic,strong) NSMutableArray *picsArray;
@property (nonatomic,assign) NSInteger maxy;
@end

@implementation DongtaiViewCell

- (NSMutableArray *)picsArray{
    if (!_picsArray) {
        _picsArray = [NSMutableArray array];
    }
    return _picsArray;
}

- (void)setImgDic:(NSDictionary *)imgDic{
    if (imgDic) {
        num.text = [NSString stringWithFormat:@"%@",imgDic[@"num"]];
    }
    NSArray *imgs = imgDic[@"img"];
    if (imgs.count > 0) {
        if (addview) {
            [addview removeFromSuperview];
            [dongtaiLabel removeFromSuperview];
        }
        for (int i = 0; i < imgs.count; i ++) {
            id objectstr = self.picsArray[i];
            if (objectstr) {
                UIImageView *imgv = self.picsArray[i];
                [imgv sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
            }
            
        }
    }else{
        UIImageView *imgv = [self.picsArray firstObject];
        imgv.backgroundColor = BFColor(222, 222, 222, 1);
        addview = [[UIImageView alloc]init];
        addview.frame = CGRectMake(0, 0, 20*ScreenRatio, 20*ScreenRatio);
        addview.center = CGPointMake(imgv.width/2, imgv.height/2);
        addview.image = [UIImage imageNamed:@"selladd"];
        [imgv addSubview:addview];
        
        dongtaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgv.frame)+10*ScreenRatio, CGRectGetMinY(imgv.frame)+imgv.width/2 - 10, 150, 20)];
        if ([self.jmid isEqualToString:JMUSERID]) {
            dongtaiLabel.text = @"发布第一条动态吧";

        }else{
            dongtaiLabel.text = @"暂无动态哦";
        }
        dongtaiLabel.textAlignment = NSTextAlignmentLeft;
        dongtaiLabel.textColor = [UIColor grayColor];
        dongtaiLabel.font = BFFontOfSize(16);
        [self.contentView addSubview:dongtaiLabel];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *dongtai = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, 15, 40, 20)];
        dongtai.text = @"动态";
        dongtai.textAlignment = NSTextAlignmentLeft;
        dongtai.textColor = [UIColor blackColor];
        dongtai.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:dongtai];
        
        num = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dongtai.frame)+5, 15, 30, 20)];
        num.textAlignment = NSTextAlignmentCenter;
        num.textColor = [UIColor blueColor];
        num.font = BFFontOfSize(15);
        [self.contentView addSubview:num];
        
        NSInteger width = (Screen_width - UserCellMargin - 50 - 4*15)/4;
        for (int i = 0; i < 4; i ++) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(13 + (width + 15)*i, CGRectGetMaxY(dongtai.frame)+10, width, width)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            image.layer.cornerRadius = 3;
            image.layer.masksToBounds = YES;
            [self.contentView addSubview:image];
            [self.picsArray addObject:image];
            self.maxy = CGRectGetMaxY(image.frame);
        }
        
        UIImageView *arrows = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        arrows.frame = CGRectMake(Screen_width - UserCellMargin, CGRectGetMaxY(dongtai.frame)+ width/2, 7, self.height - 20);
        arrows.contentMode = UIViewContentModeScaleAspectFit;
        arrows.clipsToBounds = NO;
        [self.contentView addSubview:arrows];
    }
    return self;
}

- (NSInteger)getDongtaiHeight{
    return self.maxy + 20;
}

@end
