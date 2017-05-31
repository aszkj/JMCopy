//
//  BFUserLeftView+_new.m
//  BFTest
//
//  Created by JM on 2017/4/5.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserLeftView+new.h"

@implementation BFUserLeftView (new)
- (void)setUserDic:(NSDictionary *)userDic{
    
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    
    NSString *imgStr = manager.photo;
    NSString *name = manager.name;
    NSString *signature;
    if (userDic[@"signature"]) {
        signature = userDic[@"signature"];
    }else{
        signature = @"";
    }
    UIImage *iconback;
    if (imgStr != nil && imgStr.length > 0) {
        NSURL *imgUrl = [NSURL URLWithString:imgStr];
//        iconback = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl] scale:1.0];
        [view sd_setImageWithURL:imgUrl];

        [[NSUserDefaults standardUserDefaults]setObject:imgStr forKey:@"UserIcon"];
        [self.iconImageView sd_setImageWithURL:imgUrl];
        nameLabel.text = [name stringByRemovingPercentEncoding];
        assign.text = [NSString stringWithFormat:@"%@",signature];
    }else{
        iconback = [UIImage yy_imageWithColor:[UIColor blackColor]];
        self.iconImageView.image = BFIcomImg;
        nameLabel.text = @"请编辑用户名";
        assign.text = @"我的签名...";
        view.image = iconback;
    }
    [self refreshIconImageAndBackgroundImage:[NSURL URLWithString:manager.photo]];
   
    [self.leftList setBackgroundColor:[UIColor clearColor]];
    
}
@end
