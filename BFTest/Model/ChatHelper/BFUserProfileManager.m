//
//  BFUserProfileManager.m
//  BFTest
//
//  Created by 伯符 on 16/9/2.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFUserProfileManager.h"

@interface BFUserProfileManager ()

@property (strong, nonatomic) NSMutableArray *UserNames;

@property (strong, nonatomic) NSMutableDictionary *NickNames;

@property (nonatomic) BOOL DownloadHasDone;

@property (nonatomic) BOOL LoadFromLocalDickDone;

@end
@implementation BFUserProfileManager

static BFUserProfileManager *_instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _DownloadHasDone = NO;
        _LoadFromLocalDickDone = NO;
        _UserNames = [NSMutableArray array];
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserMesgDic"];
        if (dic == nil || [dic count] == 0) {
            _NickNames = [NSMutableDictionary dictionary];
            _LoadFromLocalDickDone = YES;
        }
        else
        {
            _LoadFromLocalDickDone = YES;
            _NickNames = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
    }
    return self;
}

- (void)loadUserProfileInBackgroundWithUserID:(NSString *)userID{
    _DownloadHasDone = NO;
    [_UserNames removeAllObjects];
    [_NickNames removeAllObjects];
    
    if (userID == nil || userID.length == 0)
    {
        return;
    }
    
    [self loadUserFriendsWithID:userID];
}

- (void)loadUserFriendsWithID:(NSString *)userID{
    NSLog(@"%@",userID);
    [BFNetRequest postWithURLString:BFADDRESS_URL parameters:@{@"userid":userID} success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",[error description]);
    }];
}

@end
