//
//  BFJubaoView.h
//  BFTest
//
//  Created by 伯符 on 17/3/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^jubaoBlock)(NSString *jbmesg);
@interface BFJubaoView : UIView

@property (nonatomic,strong) jubaoBlock block;

- (void)show;

@end
