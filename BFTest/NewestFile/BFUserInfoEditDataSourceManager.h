//
//  BFUserInfoEditDataSourceManager.h
//  BFTest
//
//  Created by JM on 2017/4/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFUserEditerTableViewAddTagVCSettingModel.h"


@interface BFUserInfoEditDataSourceManager : NSObject

+ (instancetype)shardManager;

//通过主编辑界面对应cell的下标 返回对应的数据源
- (BFUserEditerTableViewAddTagVCSettingModel *)getSettingModelWithIndexPath:(NSIndexPath *)indexPath;

@end
