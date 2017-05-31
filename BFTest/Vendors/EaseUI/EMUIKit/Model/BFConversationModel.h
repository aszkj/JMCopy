//
//  BFConversationModel.h
//  BFTest
//
//  Created by 伯符 on 16/11/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFConversationModel : NSObject

@property (strong, nonatomic, readonly) EMConversation *conversation;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
