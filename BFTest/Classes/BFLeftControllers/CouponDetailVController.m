//
//  CouponDetailVController.m
//  BFTest
//
//  Created by 伯符 on 16/12/19.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "CouponDetailVController.h"

@interface CouponDetailVController (){
    UIImageView *mainView;
    UILabel *name;
    UILabel *position;
    UILabel *time;
}

@end

@implementation CouponDetailVController

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 0)];
    header.backgroundColor = [UIColor clearColor];
    
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(20*ScreenRatio, 10*ScreenRatio, 60*ScreenRatio, 60*ScreenRatio)];
    mainView.image = [UIImage imageNamed:[BFDataGenerator randomIconImageName]];
    mainView.contentMode = UIViewContentModeScaleAspectFill;
    mainView.clipsToBounds = YES;
    [header addSubview:mainView];
    
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    footview.backgroundColor = [UIColor clearColor];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 6*ScreenRatio)];
    line.image = [UIImage imageNamed:@"lineflower"];
    line.contentMode = UIViewContentModeScaleAspectFit;
    [footview addSubview:line];
    NSArray *photos = _sellDic[@"group_coupons"];
    CGFloat photoWidth = (self.width - 2*5)/4;
    for (int i = 0; i < photos.count; i ++) {
        NSDictionary *dic = photos[i];
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(2 + (photoWidth + 2)*i, CGRectGetMaxY(line.frame)+5*ScreenRatio, photoWidth, photoWidth)];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        [imgv sd_setImageWithURL:[NSURL URLWithString:dic[@"photo_1"]] placeholderImage:nil];
        [footview addSubview:imgv];
    }
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+10*ScreenRatio + photoWidth, self.width, 6*ScreenRatio)];
    line2.image = [UIImage imageNamed:@"lineflower"];
    line2.contentMode = UIViewContentModeScaleAspectFit;
    [footview addSubview:line2];
    
    UIButton *matchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    matchBtn.frame = CGRectMake(0,0, 60*ScreenRatio, 20*ScreenRatio);
    matchBtn.center = CGPointMake(self.width/2, 120*ScreenRatio - 20*ScreenRatio);
    [matchBtn setImage:[UIImage imageNamed:@"gologo"] forState:UIControlStateNormal];
    [matchBtn addTarget:self action:@selector(gotosell:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:matchBtn];
    
    return footview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Screen_width + 100*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*ScreenRatio;
}
 */

@end
