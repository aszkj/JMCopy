//
//  BFOriginNetWorkingTool.m
//  BFTest
//
//  Created by JM on 2017/3/29.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFOriginNetWorkingTool.h"

//这里对网络请求的次数进行计数
static int i = 1;

//这里切换网络请求的打印日志  json 还是 dict
static BOOL isDict = YES;

@interface BFOriginNetWorkingTool()

@property (nonatomic,strong)NSURLSession *session;

@end

@implementation BFOriginNetWorkingTool

+ (instancetype)shardManager{
    
    static BFOriginNetWorkingTool *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[BFOriginNetWorkingTool alloc] init];
        [_instance setupSession];
    });
    
    return _instance;
}
- (void)setupSession{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type"  : @"application/json"};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    //1.创建NSURLSession
    self.session = session;
}

//将字典转为对应的JSON字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if(parseError){
        NSLog(@"字典转JSON失败->%@",parseError);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (void)postWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSURL *url = [NSURL URLWithString:URLString];
    
    //创建一个请求对象，设置请求方法为POST，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *dic = parameters;
    NSString *urlLastComponent = [URLString lastPathComponent];
    int time = i++;
    NSString *json = [self dictionaryToJson:dic];
    
   

    if(isDict){
        NSLog(@"\n\n\n\n\n======*********  这是第 %zd 次调用Java后台的接口，接口名称为 %@ ********====== \n\n URL---> %@ \n\n上传的参数是  \n\n %@ \n",time,urlLastComponent,url.absoluteURL,dic);
    }else{
        
        NSLog(@"\n\n\n\n\n======*********  这是第 %zd 次调用Java后台的接口，接口名称为 %@ ********====== \n\n URL---> %@ \n\n上传的参数是  \n\n %@ \n",time,urlLastComponent,url.absoluteURL,json);
    }
    
    
    request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [BFOriginNetWorkingTool shardManager].session;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSLog(@"head ->%@",response);
        
        if(error){
            NSLog(@"%@",error);
            failure(error);
        }else{
            //解析数据
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *json = [[NSString alloc]initWithData:data encoding:kCFStringEncodingUTF8];

            if(isDict){
            NSLog(@"\n======*********  这是第 %zd 次 从Java后台返回数据，接口名称为 %@，返回的数据是  ********======\n\n %@ \n\n",time,urlLastComponent,dict);
            }else{
            NSLog(@"\n======*********  这是第 %zd 次 从Java后台返回数据，接口名称为 %@，返回的数据是  ********======\n\n %@ \n\n",time,urlLastComponent,json);
            }
            
            NSLog(@"\n 第 %zd 次调接口 之前 manager的数据\n %@ \n",time,[BFUserLoginManager shardManager].description);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"\n 第 %zd 次调接口 之后 manager的数据\n %@ \n",time,[BFUserLoginManager shardManager].description);
            });
            success(dict);
        }
    }];
    //3.执行Task
    [dataTask resume];
}
+ (void)getWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSURL *url = [NSURL URLWithString:URLString];
    
    //创建一个请求对象，设置请求方法为GET，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [BFOriginNetWorkingTool shardManager].session;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSLog(@"head ->%@",response);
        if(error){
            NSLog(@"%@",error);
            failure(error);
        }else{
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"回调数据 dict -> %@",dict);
            success(dict);
        }
    }];
    //3.执行Task
    [dataTask resume];

}




@end
