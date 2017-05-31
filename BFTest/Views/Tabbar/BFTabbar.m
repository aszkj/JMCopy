//
//  BFTabbar.m
//  BFTest
//
//  Created by 伯符 on 16/6/1.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFTabbar.h"
#import "BFButtonView.h"
@interface BFTabbar ()<BFButtonViewDelegate>{
    UIButton *selectedBtn;
    BFButtonView *selectedBtnView;

    NSInteger selectNum;
    NSMutableArray *btnArray;
    UILabel *icon;
    UILabel *dticon;

    UIImageView *back;
}
@end

@implementation BFTabbar

- (void)configureIcon{
    icon = [[UILabel alloc]init];
    icon.font = BFFontOfSize(9);
    icon.textAlignment = NSTextAlignmentCenter;
    icon.textColor = [UIColor whiteColor];
    icon.backgroundColor = BFColor(251, 75, 70, 1);
    icon.layer.cornerRadius = 6*ScreenRatio;
    icon.layer.masksToBounds = YES;
    icon.frame = CGRectMake(62*ScreenRatio, 5*ScreenRatio, 12*ScreenRatio, 12*ScreenRatio);
    icon.hidden = YES;
    [self addSubview:icon];
    
    dticon = [[UILabel alloc]init];
    dticon.font = BFFontOfSize(9);
    dticon.textAlignment = NSTextAlignmentCenter;
    dticon.textColor = [UIColor whiteColor];
    dticon.backgroundColor = BFColor(251, 75, 70, 1);
    dticon.layer.cornerRadius = 6*ScreenRatio;
    dticon.layer.masksToBounds = YES;
    dticon.frame = CGRectMake(Screen_width - 47*ScreenRatio, 5*ScreenRatio, 12*ScreenRatio, 12*ScreenRatio);
    dticon.hidden = YES;
    [self addSubview:dticon];
}

- (instancetype)initWithFrame:(CGRect)frame itemsArray:(NSArray *)items{
    if (self = [super initWithFrame:frame]) {
        self.tag = kTabbarTag;
        self.backgroundColor = BFColor(38, 38, 38, 1);
        back = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom"]];
        back.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:back];
        btnArray = [NSMutableArray array];
        for (int i = 0; i < items.count; i++) {
            NSDictionary *item = items[i];
            BFButtonView *btnView ;
            if (i != 1) {
                btnView = [[BFButtonView alloc]initViewImage:[item objectForKey:kImageKey] frame:CGRectMake(Screen_width/3*i, 0, Screen_width/3, Tabbar_Height)imgframe:CGRectMake(0, 0, 28*ScreenRatio, 28*ScreenRatio)btntag:i selectedimg:[item objectForKey:kSelImgKey]];
            }else{
                btnView = [[BFButtonView alloc]initViewImage:[item objectForKey:kImageKey] frame:CGRectMake(Screen_width/3*i, 0, Screen_width/3, Tabbar_Height)imgframe:CGRectMake(0, - 2, Tabbar_Height, Tabbar_Height)btntag:i selectedimg:[item objectForKey:kSelImgKey]];
                btnView.isSelected = YES;
                selectedBtnView = btnView;
            }
            btnView.delegate = self;
            btnView.tag = i;
            [self addSubview:btnView];
            [self configureIcon];
//            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self setupVersionLabel];
    }
    return self;
}

- (void)setupVersionLabel{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width/3-30, 15, 80, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = [BFUserLoginManager shardManager].version;
    if(IsTestModel){
        [self addSubview:label];
    }
    
}

- (void)bfButtonSelected:(UIButton *)btn btnimg:(BFButtonView *)btnview{
    selectedBtn.selected = NO;
    btn.selected = YES;
    selectNum = btn.tag;
    selectedBtn = btn;
    btnview.isSelected = YES;
    if (btnview != selectedBtnView) {
        selectedBtnView.isSelected = NO;
    }
    selectedBtnView = btnview;
    if ([self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:selectNum];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BFButtonView class]]) {
            [btnArray addObject:subview];
        }
    }
    back.frame = CGRectMake(0, 0, Screen_width, 39*ScreenRatio);
}

- (void)showMesgIconNum:(NSInteger)number{
    if (number == 0) {
        icon.hidden = YES;
        return ;
    }
    
    if (icon.hidden)  icon.hidden = NO;
    if (number > 50) {
        icon.text = @"...";
    }else{
        icon.text = [NSString stringWithFormat:@"%ld",number];
    }
}

- (void)showDTIconNum{
    dticon.hidden = NO;
    ++ self.dtNum;
    dticon.text = [NSString stringWithFormat:@"%ld",self.dtNum];
    
}

- (void)hideDTNum{
    dticon.hidden = YES;
    self.dtNum = 0;
}

@end
