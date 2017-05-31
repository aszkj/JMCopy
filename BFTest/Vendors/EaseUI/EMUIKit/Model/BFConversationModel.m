//
//  BFConversationModel.m
//  BFTest
//
//  Created by 伯符 on 16/11/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFConversationModel.h"
#import "BFChatHelper.h"
@implementation BFConversationModel

- (instancetype)initWithConversation:(EMConversation *)conversation
{
    self = [super init];
    if (self) {
        NSLog(@"%@",conversation.ext);
        _conversation = conversation;
        NSString *conversationID = _conversation.conversationId;
        NSDictionary *dic = [BFChatHelper getDataFromDB:@"address"];
        NSArray *array = dic[@"data"];
        if (array.count > 0) {
            // 从本地缓存获取
           self = [self configureDataDic:dic buddy:conversationID];
        }else{
            
        }
//        if (conversation.type == EMConversationTypeChat) {
//            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//        }
//        else{
//            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
//        }
    }
    
    return self;
}

- (instancetype)configureDataDic:(NSDictionary *)dic buddy:(NSString *)buddy{
    NSMutableArray *dataArray = dic[@"data"];
    for (NSDictionary *dic in dataArray) {
        if ([buddy isEqualToString:dic[@"jmid"]]) {
            BFSearchFrid *frid = [BFSearchFrid configureModelWithDic:dic];
            self.avatarURLPath = frid.mybmp;
            self.title = frid.nikename;
        }
        return self;
    }
    return 0;
}


@end
