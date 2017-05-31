//
//  BFHXDelegateManager.m
//  BFTest
//
//  Created by JM on 2017/4/16.
//  Copyright © 2017年 bofuco. All rights reserved.
//


#import "BFHXDelegateManager.h"

static BFHXDelegateManager *delegateManager;
@implementation BFHXDelegateManager

@synthesize isShowingimagePicker = _isShowingimagePicker;

+ (instancetype)shareDelegateManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegateManager = [[BFHXDelegateManager alloc] init];
           });
    return delegateManager;;
}



@end
