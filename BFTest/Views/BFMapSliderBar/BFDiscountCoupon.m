//
//  BFDiscountCoupon.m
//  BFTest
//
//  Created by 伯符 on 2017/5/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFDiscountCoupon.h"
#import "BFSliderCell.h"
@interface BFDiscountCoupon ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel *titleLabel;
    UILabel *subLabel;
    
}
@property (nonatomic,strong)NSMutableArray *dataArray;

@end
@implementation BFDiscountCoupon

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.scrollEnabled = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *couponIdent = @"BFCouponCell";
    BFCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponIdent];
    if (!cell) {
        cell = [[BFCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponIdent];
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.imgView.frame = CGRectMake(0, 0, 55*ScreenRatio, 55*ScreenRatio);
        cell.imgView.center = CGPointMake(33*ScreenRatio, BFCouponCellHeight/2);
        
        cell.titleLabel.frame = CGRectMake(0, 0, self.width - 55*ScreenRatio - 20*ScreenRatio, 18*ScreenRatio);
        cell.titleLabel.center = CGPointMake(CGRectGetMaxX(cell.imgView.frame)+15*ScreenRatio + CGRectGetWidth(cell.titleLabel.frame)/2, BFCouponCellHeight/2- 9*ScreenRatio - 14*ScreenRatio);
        
        cell.midTitleLabel.frame = CGRectMake(0, 0, self.width - 55*ScreenRatio - 20*ScreenRatio, 18*ScreenRatio);
        cell.midTitleLabel.center = CGPointMake(CGRectGetMaxX(cell.imgView.frame)+15*ScreenRatio + CGRectGetWidth(cell.titleLabel.frame)/2, 70*ScreenRatio/2);
        cell.subTitleLabel.frame = CGRectMake(CGRectGetMaxX(cell.imgView.frame)+15*ScreenRatio, CGRectGetMaxY(cell.midTitleLabel.frame)+5*ScreenRatio, self.width - 55*ScreenRatio - 20*ScreenRatio, 18*ScreenRatio);
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.midTitleLabel.font = BFFontOfSize(12);
        cell.subTitleLabel.font = BFFontOfSize(12);
    }
    NSDictionary *model = self.dataArray[indexPath.row];

    
    cell.titleLabel.text = model[@"coupon_name"];
    cell.midTitleLabel.text = model[@"desc"];

    cell.subTitleLabel.text = model[@"expire_date"];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model[@"image_url"]]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    header.backgroundColor = [UIColor clearColor];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(self.width - 25*ScreenRatio, 10, 15*ScreenRatio, 15*ScreenRatio);
    [deleteBtn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:deleteBtn];
    
    NSString *title = @"恭喜获得天降红包";
    CGSize nameSz = [title boundingRectWithSize:CGSizeMake(160*ScreenRatio, 25*ScreenRatio) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:BFFontOfSize(16)} context:0].size;

    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, nameSz.width + 10*ScreenRatio, 20*ScreenRatio)];
    titleLabel.center = CGPointMake(self.width/2, 15*ScreenRatio);
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
    
    NSString *subtitle = @"优惠券已放入账户中,请在我的卡包查看";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:subtitle];
    
    subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+15*ScreenRatio, self.width, 20*ScreenRatio)];
    subLabel.backgroundColor = [UIColor clearColor];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, subtitle.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BFThemeColor range:[subtitle rangeOfString:@"我的卡包"]];
    subLabel.attributedText = attributeString;

    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.font = [UIFont boldSystemFontOfSize:13];
    [header addSubview:subLabel];
    return header;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67*ScreenRatio;
}

- (void)reportClick:(UIButton *)btn{
    NSLog(@"reportClick");
}

- (void)delete:(UIButton *)btn{
    if ([self.userDelegate respondsToSelector:@selector(couponDeleteClick:)]) {
        [self.userDelegate couponDeleteClick:btn];
    }
}

- (void)showMapAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, - kMapShowHeight);
    } completion:^(BOOL finished) {
        
    }];
}



- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSArray *array = [dataDic[@"content"] objectForKey:@"clist"];
    for (NSDictionary *dic in array) {
        [self.dataArray addObject:dic];
    }
    [self reloadData];
}


@end
