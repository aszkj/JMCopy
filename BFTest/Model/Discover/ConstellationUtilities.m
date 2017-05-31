//
//  ConstellationUtilities.m
//  BFTest
//
//  Created by 伯符 on 17/2/24.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "ConstellationUtilities.h"

@implementation ConstellationUtilities

+ (UIImage *)returnImgBase:(NSString *)name{
    NSString *imgStr;
    if ([name containsString:@"白羊"]) {
        imgStr = @"白羊.png";
    }else if ([name containsString:@"处女"]){
        imgStr = @"处女.png";
    }else if ([name containsString:@"金牛"]){
        imgStr = @"金牛.png";
    }else if ([name containsString:@"巨蟹"]){
        imgStr = @"巨蟹.png";
    }else if ([name containsString:@"摩羯"]){
        imgStr = @"摩羯.png";
    }else if ([name containsString:@"射手"]){
        imgStr = @"射手.png";
    }else if ([name containsString:@"狮子"]){
        imgStr = @"狮子.png";
    }else if ([name containsString:@"双鱼"]){
        imgStr = @"双鱼.png";
    }else if ([name containsString:@"双子"]){
        imgStr = @"双子.png";
    }else if ([name containsString:@"水瓶"]){
        imgStr = @"水瓶.png";
    }else if ([name containsString:@"天秤"]){
        imgStr = @"天秤.png";
    }else if ([name containsString:@"天蝎"]){
        imgStr = @"天蝎.png";
    }
    return [UIImage imageNamed:imgStr];
    
}

@end
