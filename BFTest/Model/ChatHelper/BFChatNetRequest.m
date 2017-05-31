//
//  BFChatNetRequest.m
//  BFTest
//
//  Created by 伯符 on 16/11/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFChatNetRequest.h"

static BFChatNetRequest *helper = nil;

@implementation BFChatNetRequest

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[BFChatNetRequest alloc] init];
    });
    return helper;
}

- (BOOL)agreeFridApply:(NSString *)fridID{
    
    __block BOOL isAgree;
    NSString *url;
    if (UserwordMsg && JMTOKEN) {
        url = [NSString stringWithFormat:@"%@/getUlikest?tkname=%@&tok=%@&likest=%@",ALI_BASEURL,UserwordMsg,JMTOKEN,fridID];
    }else{
        
        return NO;
    }
    [BFNetRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",accessDict);
        NSMutableArray *dataArray = accessDict[@"data"];
        if (dataArray.count != 0) {
            NSString *username = [[dataArray firstObject]objectForKey:@"name"];
            isAgree = [self postUsername:username];
        }else{
            isAgree = NO;
        }
    } failure:^(NSError *error) {
        isAgree = NO;
    }];
    return isAgree;
}

- (BOOL)postUsername:(NSString *)name{
    
    __block BOOL isAgree;
//    NSString *str = @"http://101.201.101.125:8000/insertfriend";
    NSString *str = [NSString stringWithFormat:@"%@/insertfriend",ALI_BASEURL];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"tkname":UserwordMsg,@"useridtwo":name,@"tok":JMTOKEN,@"version":@"1"};
    }else{
        return NO;
    }
    
    [BFNetRequest postWithURLString:str parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"s"]isEqualToString:@"t"]) {
            isAgree = YES;
        }else{
            isAgree = NO;
        }
    } failure:^(NSError *error) {
        isAgree = NO;

    }];
    return isAgree;

}

- (BOOL)deleteFrid:(NSString *)username{
    __block BOOL isAgree;
//    NSString *str = @"http://101.201.101.125:8000/deletefriend";
    NSString *str = [NSString stringWithFormat:@"%@/deletefriend",ALI_BASEURL];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"tkname":UserwordMsg,@"useridtwo":username,@"tok":JMTOKEN,@"version":@"1"};
    }else{
        return NO;
    }
    [BFNetRequest postWithURLString:str parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic:%@",dic);
        if ([[dic objectForKey:@"s"]isEqualToString:@"t"]) {
            isAgree = YES;
        }else{
            isAgree = NO;
        }
    } failure:^(NSError *error) {
        isAgree = NO;
        
    }];
    return isAgree;
}

@end
