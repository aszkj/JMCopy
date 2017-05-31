//
//  OutdateCouponController.m
//  BFTest
//
//  Created by 伯符 on 16/12/19.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "OutdateCouponController.h"
#import "BFSliderCell.h"
@interface OutdateCouponController ()

@end

@implementation OutdateCouponController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.title = @"已过期";
    
    
    UIView *view = [[UIView alloc]init];
    UIImageView *imagV = [[UIImageView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    UIImage *image = [UIImage imageNamed:@"nocoupons"];
    
    self.tableView.backgroundView = view;
    
    [view addSubview:imagV];
    [view addSubview:label];
    
    view.backgroundColor = BFColor(210, 210, 210, 1);
    self.tableView.backgroundColor = BFColor(210, 210, 210, 1);
    
    imagV.contentMode = UIViewContentModeScaleAspectFit;
    imagV.image = image;
    imagV.size = CGSizeMake(100, 100);
    imagV.center = CGPointMake(Screen_width/2, Screen_height/2);
    
    label.size = CGSizeMake(150, 30);
    label.center = CGPointMake(Screen_width/2, Screen_height/2+75);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无优惠券";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = BFColor(150, 150, 150, 1);
    
    
    [self achieveData];
}

- (void)achieveData{
    self.dataArray = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/mobile-app/cards/",BUSINESS_URL];
    NSString *phone = [BFUserLoginManager shardManager].phone;
    NSDictionary *para = @{@"platform_uid":UserwordMsg,@"platform_user_tel":(phone == nil || [phone isKindOfClass:[NSString class]]== NO)?@"123456":phone,@"platform_token":JMTOKEN,@"category":@"EXPIRE",@"_page_item_pos":@0};
    [BFNetRequest getaWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",accessDict);
        if (accessDict[@"success"]) {
            NSDictionary *contentDic = accessDict[@"content"];
            NSArray *array = contentDic[@"clist"];
            for (NSDictionary *dic in array) {
                MyCouponModel *model = [MyCouponModel configureModelWithDic:dic];
                [self.dataArray addObject:model];
            }
            if(self.dataArray.count != 0){
                self.tableView.backgroundView.hidden = YES;
            }else{
                self.tableView.backgroundView.hidden = NO;
            }
            [self.tableView reloadData];
        }else{
        }
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)backItemClick:(UIBarButtonItem *)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *couponIdent = @"BFCouponCell";
    BFCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponIdent];
    if (!cell) {
        cell = [[BFCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponIdent];
    }
    MyCouponModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.shop_name;
    cell.midTitleLabel.text = model.desc;
    cell.subTitleLabel.text = model.expire_date;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.photo_1]];
    return cell;
}

@end
