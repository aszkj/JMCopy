//
//  UserLastViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserLastViewCell.h"
@interface UserLastViewCell(){
    CGFloat cellheight;
}
@property (nonatomic,strong)UIView *chatView;
@end
@implementation UserLastViewCell

- (UIView *)chatView{
    if (!_chatView) {
        _chatView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.jinmaiNum.frame)+ 15*ScreenRatio, Screen_width, 45 *ScreenRatio)];
        _chatView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_chatView];
        UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chatBtn.tag = ButtonTypeChat;
        chatBtn.backgroundColor = [UIColor clearColor];
        chatBtn.frame = _chatView.bounds;
        [_chatView addSubview:chatBtn];
        [chatBtn addTarget:self action:@selector(selectStarShop:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *chatimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chatyellow"]];
        chatimg.frame = CGRectMake(0, 0, 20*ScreenRatio, 17*ScreenRatio);
        chatimg.center = CGPointMake(Screen_width/2 - 18*ScreenRatio, _chatView.height/2);
        [_chatView addSubview:chatimg];
        
        UILabel *chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(chatimg.frame)+10, CGRectGetMinY(chatimg.frame), 40, 20)];
        chatLabel.text = @"对话";
        chatLabel.textAlignment = NSTextAlignmentCenter;
        chatLabel.textColor = [UIColor whiteColor];
        chatLabel.font = [UIFont boldSystemFontOfSize:15];
        [_chatView addSubview:chatLabel];
    }
    return _chatView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, 15, 80, 20)];
        titleLabel.text = @"近脉号";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        
        self.jinmaiNum = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, CGRectGetMaxY(titleLabel.frame) + 5*ScreenRatio, 200*ScreenRatio, 20)];
        self.jinmaiNum.textAlignment = NSTextAlignmentLeft;
        self.jinmaiNum.textColor = [UIColor lightGrayColor];
        self.jinmaiNum.font = BFFontOfSize(16);
        [self.contentView addSubview:self.jinmaiNum];
        
          /*
        UIView *starStore = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.jinmaiNum.frame)+ 10, Screen_width, 100 *ScreenRatio)];
        starStore.backgroundColor = BFColor(235, 236, 237, 1);
        [self.contentView addSubview:starStore];
        
      
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = ButtonTypeShop;
        btn.frame= CGRectMake(0, 0, 50*ScreenRatio, 50*ScreenRatio);
        btn.center = CGPointMake(Screen_width/2, 45*ScreenRatio);
        [btn setBackgroundImage:[UIImage imageNamed:@"starstore"] forState:UIControlStateNormal];
        [starStore addSubview:btn];
        [btn addTarget:self action:@selector(selectStarShop:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *starImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"starstore"]];
        starImg.frame = CGRectMake(0, 0, 50*ScreenRatio, 50*ScreenRatio);
        starImg.center = CGPointMake(Screen_width/2, 45*ScreenRatio);
        [starStore addSubview:starImg];
        
        UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        starLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(btn.frame)+ 15);
        starLabel.text = @"星店";
        starLabel.textAlignment = NSTextAlignmentCenter;
        starLabel.textColor = [UIColor blackColor];
        starLabel.font = BFFontOfSize(15);
        [starStore addSubview:starLabel];
        */
        
    }
    return self;
}


- (NSInteger)getLastViewHeight{
    return cellheight;
}

- (void)selectStarShop:(UIButton *)btn{
    // 跳转星店或者对话窗口
    if ([self.delegate respondsToSelector:@selector(selectShopOrChat:)]) {
        [self.delegate selectShopOrChat:btn];
    }
}

- (void)setJmid:(NSString *)jmid{
    _jmid = jmid;
    self.jinmaiNum.text = _jmid;
    cellheight = CGRectGetMaxY(self.jinmaiNum.frame) + 7 *ScreenRatio;

}

@end
