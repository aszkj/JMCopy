//
//  AppointmentCouponController.m
//  BFTest
//
//  Created by 伯符 on 16/12/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "AppointmentCouponController.h"
#import "BFSliderCell.h"

@interface AppointmentCouponController ()

@end

@implementation AppointmentCouponController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *couponIdent = @"BFCouponCell";
    BFCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponIdent];
    if (!cell) {
        cell = [[BFCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponIdent];
    }
    MyCouponModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.coupon_name;
    cell.midTitleLabel.text = model.desc;
    cell.subTitleLabel.text = model.expire_date;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.photo_1]];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.cut];
    return cell;
}


@end
