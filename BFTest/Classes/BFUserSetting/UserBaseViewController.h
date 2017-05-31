//
//  UserBaseViewController.h
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBaseViewController : UIViewController
@property (nonatomic,strong) NSString *leftStr;
@property (nonatomic,strong) NSString *rightStr;
@property (nonatomic,strong) UIButton *rightBar;

- (void)saveUserMsg:(UIButton *)save;

- (void)backpush:(UIButton *)btn;
@end
