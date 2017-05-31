//
//  BFTitleButton.m
//  BFTest
//
//  Created by 伯符 on 16/12/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFTitleButton.h"

@implementation BFTitleButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{

    return CGRectMake(0, 0, contentRect.size.width - 20, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width - 20, 0, 20, contentRect.size.height);
}

@end
