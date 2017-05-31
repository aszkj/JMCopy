//
//  BFProgressView.h
//  编辑头像模块
//
//  Created by JM on 2017/4/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFProgressView : UIView

@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,assign)CGFloat progress;
@property (nonatomic,assign)CGFloat offsetInside;

@end
