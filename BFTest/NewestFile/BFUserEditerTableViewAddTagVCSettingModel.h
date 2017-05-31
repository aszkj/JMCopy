//
//  BFUserEditerTableViewAddTagVCSettingModel.h
//  BFTest
//
//  Created by JM on 2017/4/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BFUserEditerTableViewAddTagVCSettingModel : NSObject

@property (nonatomic,strong)NSMutableArray *infoArrM;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign)BOOL showAddTagView;
@property (nonatomic,assign)BOOL isMultipleSeleced;
@property (nonatomic,copy)NSString *keyForUserModel;


@end
