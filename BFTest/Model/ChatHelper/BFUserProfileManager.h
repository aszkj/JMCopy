//
//  BFUserProfileManager.h
//  BFTest
//
//  Created by 伯符 on 16/9/2.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFUserProfileManager : NSObject

+(instancetype) shareInstance;

- (void)loadUserProfileInBackgroundWithUserID:(NSString *)userID;

- (NSString*)getNicknameByUserName:(NSString *)username;

@end
