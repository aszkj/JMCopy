//
//  BFSellerView.m
//  BFTest
//
//  Created by 伯符 on 16/7/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFSellerView.h"

#import "BFMapSellerCell.h"
#import "UIImageView+AFNetworking.h"
@interface BFSellerView()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView *sellIcon;
    UILabel *sellname;
    UILabel *address;
    UIView *view2;
}


@end
@implementation BFSellerView

- (void)setSellDic:(NSDictionary *)sellDic{
    NSDictionary *dic = sellDic[@"content"];
    if (dic) {
        _sellDic = dic[@"info"];
        [self.sellView reloadData];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.sellView = [[UITableView alloc]initWithFrame:self.bounds];
    self.sellView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sellView.backgroundColor = [UIColor clearColor];
    self.sellView.scrollEnabled = NO;
    self.sellView.tableFooterView = [[UIView alloc]init];
    self.sellView.delegate = self;
    self.sellView.dataSource = self;
    [self addSubview:self.sellView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *coupons = _sellDic[@"group_coupons"];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"AlertCell";
    BFMapSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[BFMapSellerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    NSArray *coupons = _sellDic[@"group_coupons"];
//    if (coupons.count < 3) {
//        if (indexPath.row < coupons.count) {
//            cell.dic = coupons[indexPath.row];
//        }else{
//            cell.dic = nil;
//        }
//    }else{
//        cell.dic = coupons[indexPath.row];
//    }

    if (coupons.count < 1) {
        cell.dic = nil;
    }else{
        cell.dic = coupons[indexPath.row];
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *addresStr = _sellDic[@"address"];
    addresStr = [_sellDic[@"district_name"] stringByAppendingString:addresStr];
    NSString *sellnameStr = _sellDic[@"name"];
//    NSDictionary *rstDic = _sellDic[@"rst"];
    NSString *score = [NSString stringWithFormat:@"4.5分"];
    CGFloat scorewid = [score getWidthWithHeight:15*ScreenRatio font:12];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    header.backgroundColor = [UIColor clearColor];

    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(self.width - 25*ScreenRatio, 10, 15*ScreenRatio, 15*ScreenRatio);
    [deleteBtn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:deleteBtn];
    
    sellIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2 - 28*ScreenRatio, 10*ScreenRatio, 56*ScreenRatio, 56*ScreenRatio)];
    sellIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSellShop:)];
    [sellIcon addGestureRecognizer:tap];
    sellIcon.layer.cornerRadius = 28*ScreenRatio;
    sellIcon.contentMode = UIViewContentModeScaleAspectFill;
    sellIcon.clipsToBounds = YES;
    [header addSubview:sellIcon];
    
//    UIButton *selladd = [UIButton buttonWithType:UIButtonTypeCustom];
//    selladd.frame = CGRectMake(CGRectGetMaxX(sellIcon.frame)+10*ScreenRatio, CGRectGetMaxY(sellIcon.frame) - 20*ScreenRatio, 20*ScreenRatio, 20*ScreenRatio);
//    [selladd setImage:[UIImage imageNamed:@"selladd"] forState:UIControlStateNormal];
//    [selladd addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
//    [header addSubview:selladd];
    
    CGSize nameSz = [sellnameStr boundingRectWithSize:CGSizeMake(self.width - 40*ScreenRatio, 25*ScreenRatio) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:BFFontOfSize(16)} context:0].size;
    sellname = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2 - (nameSz.width + 10*ScreenRatio)/2, CGRectGetMaxY(sellIcon.frame)+6*ScreenRatio, nameSz.width + 10*ScreenRatio, 20*ScreenRatio)];
    sellname.backgroundColor = [UIColor clearColor];
    sellname.textColor = BFColor(251, 252, 253, 1);
    sellname.font = [UIFont boldSystemFontOfSize:16];
    sellname.textAlignment = NSTextAlignmentCenter;
    [header addSubview:sellname];
    
    UIImage *starGrayImage = [UIImage imageNamed:@"stargray"];
    UIImage *starYellowImage = [UIImage imageNamed:@"starhilight"];
    UIView *heartView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sellname.frame)+ ScreenRatio, 50*ScreenRatio, 10*ScreenRatio)];
    heartView.height = starYellowImage.size.height;
    heartView.width = starGrayImage.size.width * 5;
    UIView *view1 = [[UIView alloc]initWithFrame:heartView.bounds];
    view1.backgroundColor = [UIColor colorWithPatternImage:starGrayImage];
    [heartView addSubview:view1];
    view2 = [[UIView alloc]initWithFrame:heartView.bounds];
    view2.backgroundColor = [UIColor colorWithPatternImage:starYellowImage];
    view2.width = starGrayImage.size.width * 4.5;
    [heartView addSubview:view2];
    [header addSubview:heartView];
    heartView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    heartView.transform = CGAffineTransformTranslate(heartView.transform, - 110, 0);
    UILabel *grade = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(heartView.frame)+5*ScreenRatio, CGRectGetMinY(heartView.frame), scorewid, 15*ScreenRatio)];
    grade.text = score;
    grade.textColor = [UIColor whiteColor];
    grade.textAlignment = NSTextAlignmentCenter;
    grade.font = BFFontOfSize(12);
    [header addSubview:grade];
    
    UILabel *perAverage = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(grade.frame), CGRectGetMinY(heartView.frame), 70*ScreenRatio, 15*ScreenRatio)];
    NSString *average = [NSString stringWithFormat:@"人均:%@",_sellDic[@"capita_consumption"]];
    perAverage.text = average;
    perAverage.textColor = [UIColor whiteColor];
    perAverage.textAlignment = NSTextAlignmentCenter;
    perAverage.font = BFFontOfSize(12);
    [header addSubview:perAverage];
    
    CGSize addSz = [addresStr boundingRectWithSize:CGSizeMake(self.width - 40*ScreenRatio, 18*ScreenRatio) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:BFFontOfSize(13)} context:0].size;
    address = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2 - (addSz.width + 10*ScreenRatio)/2, CGRectGetMaxY(heartView.frame)+ 2*ScreenRatio, addSz.width + 10*ScreenRatio, 18*ScreenRatio)];
    address.backgroundColor = [UIColor clearColor];
    address.textColor = BFColor(145, 146, 148, 1);
    address.font = [UIFont boldSystemFontOfSize:13];
    address.textAlignment = NSTextAlignmentCenter;
    [header addSubview:address];
    
    [sellIcon sd_setImageWithURL:[NSURL URLWithString:_sellDic[@"logo"]] placeholderImage:nil];
    sellname.text = sellnameStr;
    address.text = addresStr;

    
//    UIButton *selltel = [UIButton buttonWithType:UIButtonTypeCustom];
//    selltel.frame = CGRectMake(CGRectGetMaxX(sellname.frame)+ScreenRatio, sellname.top, 20*ScreenRatio, 20*ScreenRatio);
//    [selltel setImage:[UIImage imageNamed:@"selltel"] forState:UIControlStateNormal];
//    [selltel addTarget:self action:@selector(telSelect:) forControlEvents:UIControlEventTouchUpInside];
//    [header addSubview:selltel];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    footview.backgroundColor = [UIColor clearColor];

    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 6*ScreenRatio)];
    line.image = [UIImage imageNamed:@"lineflower"];
    line.contentMode = UIViewContentModeScaleAspectFit;
    [footview addSubview:line];
    
    NSArray *evphotoes = _sellDic[@"env_photos"];
    if (evphotoes.count >= 2) {
        evphotoes = [evphotoes subarrayWithRange:NSMakeRange(0, 2)];
    }
    NSArray *foodphotoes = _sellDic[@"food_photos"];
    if (foodphotoes.count >= 2) {
        foodphotoes = [foodphotoes subarrayWithRange:NSMakeRange(0, 2)];
    }
    NSMutableArray *photoes = [NSMutableArray arrayWithArray:evphotoes];
    [photoes addObjectsFromArray:foodphotoes];
    NSLog(@"%@",photoes);
//    NSArray *photos = _sellDic[@"group_coupons"];
    CGFloat photoWidth = (self.width - 2*5)/4;
    for (int i = 0; i < photoes.count; i ++) {
        NSDictionary *dic = photoes[i];
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(2 + (photoWidth + 2)*i, CGRectGetMaxY(line.frame)+5*ScreenRatio, photoWidth, photoWidth)];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        //此处是坑点
        [imgv sd_setImageWithURL:[NSURL URLWithString:dic[@"thumb"]] placeholderImage:[UIImage imageNamed:@"AppIcon"] options:EMSDWebImageRetryFailed|EMSDWebImageLowPriority|EMSDWebImageProgressiveDownload];
        
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
    return 135*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*ScreenRatio;
}

- (void)reportClick:(UIButton *)btn{
    
    NSLog(@"reportClick");
}

- (void)delete:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(sellerDeleteClick:)]) {
        [self.delegate sellerDeleteClick:tap];
    }
}

- (void)showMapAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, - kMapShowHeight);
        self.sellView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)telSelect:(UIButton *)btn{

    UIWebView *callWebView = [[UIWebView alloc] init];
    NSString *telNum = [NSString stringWithFormat:@"tel://%@",_sellDic[@"tel_1"]];
    NSURL *telURL = [NSURL URLWithString:telNum];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self addSubview:callWebView];

}

- (void)pushSellShop:(UITapGestureRecognizer *)tapgesture{
    if ([self.delegate respondsToSelector:@selector(pushToDetail:)]) {
        [self.delegate pushToDetail:self.shop_id];
    }
}

- (void)gotosell:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(pushToDetail:)]) {
        [self.delegate pushToDetail:self.shop_id];
    }
}

@end
