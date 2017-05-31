//
//  BFChatNetRequest.h
//  BFTest
//
//  Created by 伯符 on 16/11/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFChatNetRequest : NSObject

+ (instancetype)shareHelper;

- (BOOL)agreeFridApply:(NSString *)fridID;

- (BOOL)deleteFrid:(NSString *)username;

@end
