//
//  PrivilegeCouponController.m
//  BFTest
//
//  Created by 伯符 on 16/12/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "PrivilegeCouponController.h"
#import "BFSliderCell.h"
@interface PrivilegeCouponController ()

@end

@implementation PrivilegeCouponController

- (void)viewDidLoad {
    [super viewDidLoad];

}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MyCouponModel *model = self.dataArray[indexPath.row];
//    NSString *url = [NSString stringWithFormat:@"%@/mobile-site/jm_voucher/jm_voucher.html?order_number=%@&token=%@&b_t=app",BUSINESS_URL,model.order_number,model.token_number];
//    NSLog(@"%@",url);
//    BFAppController *vc = [[BFAppController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.pathStr = url;
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *couponIdent = @"BFCouponCell";
    BFCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponIdent];
    if (!cell) {
        cell = [[BFCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponIdent];
    }
    MyCouponModel *model = self.dataArray[indexPath.row];
//    cell.model = model;
    cell.titleLabel.text = model.coupon_name;
    cell.midTitleLabel.text = model.desc;
    cell.subTitleLabel.text = model.expire_date;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.photo_1]];
    UIImage *image = nil;
    if([model.promotion_type isEqualToString:@"N"]){
        image = [UIImage imageNamed:@"promotion_type_N"];
    }
    
    cell.promotionImageView.image = image;

//    cell.priceLabel.text = [NSString stringWithFormat:@"¥66"];
    return cell;
}


@end
