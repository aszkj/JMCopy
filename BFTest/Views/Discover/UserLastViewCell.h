//
//  UserLastViewCell.h
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ButtonType) {
    ButtonTypeShop,
    ButtonTypeChat,
    ButtonTypeFocus,
    ButtonTypeBlack,
};

@protocol SelectShopOrChatDelegate <NSObject>
- (void)selectShopOrChat:(UIButton *)btn;
@end

@interface UserLastViewCell : UITableViewCell

@property (nonatomic,assign) id <SelectShopOrChatDelegate> delegate;

@property (nonatomic,strong) UILabel *jinmaiNum;

@property (nonatomic,strong) NSString *jmid;

- (NSInteger)getLastViewHeight;


@end
