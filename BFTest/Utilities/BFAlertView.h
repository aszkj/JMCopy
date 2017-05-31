//
//  BFAlertView.h
//  BFTest
//
//  Created by 伯符 on 17/3/25.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Action)(UIButton *btn);
@interface BFAlertView : UIView

@property (nonatomic,strong) Action action;


+ (instancetype)alertViewWithContent:(NSString *)content mainBtn:(NSString *)main otherBtn:(NSString *)other;

- (void)show;


@end
