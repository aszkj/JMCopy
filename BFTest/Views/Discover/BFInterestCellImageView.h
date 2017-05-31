//
//  BFInterestCellImageView.h
//  BFTest
//
//  Created by 伯符 on 16/11/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFBaseImageView.h"

@interface BFInterestCellImageView : BFBaseImageView

@property (nonatomic, copy) void(^homeTableCellVideoDidBeginPlayHandle)(UIButton *playBtn);


@end
