//
//  BFButtonView.h
//  BFTest
//
//  Created by 伯符 on 16/7/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BFChatInputBar.h"
@class BFButtonView;
typedef NS_ENUM(NSUInteger, BFButtonViewType){
    BFButtonViewTypePhoto,
    BFButtonViewTypeCamera,
};

@protocol BFButtonViewDelegate <NSObject>

- (void)bfButtonSelected:(UIButton *)btn btnimg:(BFButtonView *)btnview;

- (void)dongtaiButton:(UIImageView *)zanview btnimg:(BFButtonView *)btnview;

@end

@interface BFButtonView : UIView

@property (nonatomic,assign) id<BFButtonViewDelegate> delegate;
@property (nonatomic,assign) BFButtonViewType btnViewType;
@property (nonatomic,strong) UIImageView *selectImgview;
@property (nonatomic,strong) UIButton *pressBtn;

@property (nonatomic,strong) UIImageView *centerImg;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isZan;

@property (nonatomic,assign) BOOL stateHightLight;

- (void)dongtaiClick:(UIButton *)btn;

- (void)btnClick:(UIButton *)btn;

- (instancetype)initViewImage:(NSString *)img imgframe:(CGRect)frame text:(NSString *)title ;

- (instancetype)initViewImage:(NSString *)img imgframe:(CGRect)frame inputBar:(BFChatInputBar *)inputbar btntag:(NSInteger)tag;

- (instancetype)initViewImage:(NSString *)img frame:(CGRect)frame imgframe:(CGRect)imgFrame btntag:(NSInteger)tag selectedimg:(NSString *)selectimg;

- (instancetype)initButtonFrame:(CGRect)buttonrect imgRect:(CGRect)imgrec img:(NSString *)imgstr btntag:(NSInteger)tag;
@end
