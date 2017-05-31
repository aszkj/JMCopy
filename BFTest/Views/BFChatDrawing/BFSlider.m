//
//  BFSlider.m
//  BFTest
//
//  Created by 伯符 on 16/5/12.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFSlider.h"

@implementation BFSlider

- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 5, Screen_width - 50, 16);
}

@end
