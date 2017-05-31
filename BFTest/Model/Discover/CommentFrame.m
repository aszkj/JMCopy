//
//  CommentFrame.m
//  BFTest
//
//  Created by 伯符 on 16/11/24.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "CommentFrame.h"

@implementation CommentFrame


+ (CGFloat)returnHeightWith:(NSDictionary *)dic{
    NSString *mesg = dic[@"message"];
    CGFloat height = [mesg getHeightWithWidth:300*ScreenRatio font:14];
    return height;
}

@end
