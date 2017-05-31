//
//  BFNetRequest.m
//  BFTest
//
//  Created by 伯符 on 16/5/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFNetRequest.h"
@interface BFNetRequest ()
@end

@implementation BFNetRequest


+ (void)netWorkStatus:(void (^)(AFNetworkReachabilityStatus netStatus))netStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        netStatus(status);
    }];
}


//
//+ (void)getaWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure




+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    [BFNetRequest netWorkStatus:^(AFNetworkReachabilityStatus netStatus) {
        if (netStatus == AFNetworkReachabilityStatusReachableViaWWAN ||  netStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            static AFHTTPSessionManager *manager;
            if(manager == nil){
                manager = [AFHTTPSessionManager manager];
            }
            //设置请求格式
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            // /先导入证书
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"jinmailife.com" ofType:@"cer"];//证书的路径
            NSData *certData = [NSData dataWithContentsOfFile:cerPath];
            NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
            
            AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:set];
            
            security.allowInvalidCertificates = YES;
            security.validatesDomainName = NO;
            
            manager.securityPolicy = security;
            

            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
            [manager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            /**
             *  请求超时的时间
             */
            //    manager.requestSerializer.timeoutInterval = 5;
            [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }else{
            [UIViewController showUpLabelText:@"当前网络不可用，请检查网络设置"];
        }
    }];
}

#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    [BFNetRequest netWorkStatus:^(AFNetworkReachabilityStatus netStatus) {
        if (netStatus == AFNetworkReachabilityStatusReachableViaWWAN ||  netStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //设置请求格式
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            // /先导入证书
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"jinmailife.com" ofType:@"cer"];//证书的路径
            NSData *certData = [NSData dataWithContentsOfFile:cerPath];
            
            AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            security.allowInvalidCertificates = YES;
            security.validatesDomainName = YES;
            security.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
            manager.securityPolicy = security;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }else{
            [UIViewController showUpLabelText:@"当前网络不可用，请检查网络设置"];
        }
    }];
    
}

// 上传图片
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(NSData *)uploadParam
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *error))failure{
    
    [BFNetRequest netWorkStatus:^(AFNetworkReachabilityStatus netStatus) {
        if (netStatus == AFNetworkReachabilityStatusReachableViaWWAN ||  netStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //设置请求格式
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            // /先导入证书
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"jinmailife.com" ofType:@"cer"];//证书的路径
            NSData *certData = [NSData dataWithContentsOfFile:cerPath];
            
            AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            security.allowInvalidCertificates = YES;
            security.validatesDomainName = YES;
            security.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
            manager.securityPolicy = security;

            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xhtml+xml", nil];
            [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            
            [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//            [manager.requestSerializer setValue:@"http://192.168.1.198:8000/upload" forHTTPHeaderField:@"Referer"];
            [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:uploadParam name:@"userfile" fileName:@"test.jpg" mimeType:@"image/jpg"];
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }else{
            NSLog(@"没有网络");
            [UIViewController showUpLabelText:@"当前网络不可用，请检查网络设置"];
        }
    }];
}

+ (void)deleteWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure{
    [BFNetRequest netWorkStatus:^(AFNetworkReachabilityStatus netStatus) {
        if (netStatus == AFNetworkReachabilityStatusReachableViaWWAN ||  netStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //设置请求格式
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
            [manager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            /**
             *  请求超时的时间
             */
            //    manager.requestSerializer.timeoutInterval = 5;
            [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        
        }else{
            [UIViewController showUpLabelText:@"当前网络不可用，请检查网络设置"];
        }
    }];
}


+ (void)getaWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    
    [BFNetRequest netWorkStatus:^(AFNetworkReachabilityStatus netStatus) {
        if (netStatus == AFNetworkReachabilityStatusReachableViaWWAN ||  netStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //设置请求格式
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
            [manager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            /**
             *  请求超时的时间
             */
            //    manager.requestSerializer.timeoutInterval = 5;
            [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }else{
            [UIViewController showUpLabelText:@"当前网络不可用，请检查网络设置"];
        }
    }];
    
}

@end
