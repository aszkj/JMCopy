//
//  BFOriginNetWorkingTool.h
//  BFTest
//
//  Created by JM on 2017/3/29.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFOriginNetWorkingTool : NSObject

+ (instancetype)shardManager;

+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(NSDictionary *responseObject))success
                  failure:(void (^)(NSError *error))failure;

+ (void)getWithURLString:(NSString *)URLString
             parameters:(id)parameters
                success:(void (^)(NSDictionary *responseObject))success
                failure:(void (^)(NSError *))failure;
@end






































/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the magical animal protecting
 *　　　　　　　　　┃　　　┃ +
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 我自己封装的工具类  自求多福吧
 */
