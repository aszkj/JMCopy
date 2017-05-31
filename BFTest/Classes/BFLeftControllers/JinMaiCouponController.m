//
//  JinMaiCouponController.m
//  BFTest
//
//  Created by 伯符 on 16/12/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "JinMaiCouponController.h"
#import "BFSliderCell.h"
#import "MyCouponModel.h"
#import "BFAppController.h"
@interface JinMaiCouponController ()

@end

@implementation JinMaiCouponController


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
    cell.model = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCouponModel *model = self.dataArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@/mobile-site/jm_voucher/jm_voucher.html?order_number=%@&token=%@&b_t=app",BUSINESS_URL,model.order_number,model.token_number];
    NSLog(@"%@",url);
    BFAppController *vc = [[BFAppController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pathStr = url;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
