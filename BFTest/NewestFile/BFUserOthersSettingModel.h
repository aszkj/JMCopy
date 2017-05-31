//
//  BFUserOthersSettingModel.h
//  BFTest
//
//  Created by JM on 2017/4/12.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFUserOthersSettingModel : NSObject


@property (nonatomic,copy)NSString *remarkName;
@property (nonatomic,copy)NSString *follow;
@property (nonatomic,copy)NSString *followTime;
@property (nonatomic,copy)NSString *black;
@property (nonatomic,copy)NSString *blackTime;
@property (nonatomic,copy)NSString *hidden;
@property (nonatomic,copy)NSString *hiddenTime;
@property (nonatomic,copy)NSString *isMyFans;

/*
 "remarkName": "xxxx",                   \\备注名
 "follow": 1,                            \\是否关注他(0:否,1是)
 "followTime": "2016-01-01 11:00:00",    \\何时关注他
 "black": 1,                             \\是否拉黑(0:否,1是)
 "blackTime": "2016-01-01 11:00:00",     \\拉黑时间
 "hidden": 0,                    \\是否对他隐身(0:否,1是)
 "hiddenTime": "2016-01-01 11:00:00",    \\设置隐身时间
 "isMyFans": 1                           \\是否我的粉丝
 */


@end
