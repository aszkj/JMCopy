//
//  ClusterCell.m
//  BFTest
//
//  Created by 伯符 on 16/9/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "ClusterCell.h"

@implementation ClusterCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        self.imgView.clipsToBounds = YES;
        [self.contentView addSubview:self.imgView];
    }
    return self;
}
@end
