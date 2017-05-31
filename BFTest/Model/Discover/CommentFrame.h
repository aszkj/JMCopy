//
//  CommentFrame.h
//  BFTest
//
//  Created by 伯符 on 16/11/24.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFInterestModel.h"
@interface CommentFrame : NSObject

@property (nonatomic,strong) NSDictionary *commentDic;
+ (CGFloat)returnHeightWith:(NSDictionary *)dic;

@end
