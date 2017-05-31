//
//  BFChatAddressBar.h
//  BFTest
//
//  Created by 伯符 on 16/8/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BFFriendBarDelegate <NSObject>

- (void)selectIndex:(NSInteger)integer;

@end
@interface BFChatAddressBar : UIView{
    UIImageView *verLineOne;
    UIImageView *verLineTwo;

    UIImageView *bottomLine;
    UIImageView *sliderLine;
}


@property (nonatomic,strong) UIColor *barBackgroundColor;

@property (nonatomic,assign)id <BFFriendBarDelegate>delegate;

- (void)barItemsWith:(NSArray *)titles;

@end
