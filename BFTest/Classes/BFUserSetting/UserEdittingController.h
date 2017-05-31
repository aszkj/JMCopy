//
//  UserEdittingController.h
//  BFTest
//
//  Created by 伯符 on 16/10/27.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserBaseViewController.h"
#import "UserSettingController.h"
#import "MatchSettingController.h"
typedef NS_ENUM(NSInteger,UserEdittingType) {
    UserEdittingTypeGender,
    UserEdittingTypeMapGender,
    UserEdittingTypeAge,
    UserEdittingTypeAffectState,
    UserEdittingTypeIndustry,
    UserEdittingTypeOccupation,
    UserEdittingTypeSchool,
    UserEdittingTypeFrom,
    UserEdittingTypeLikeAppointAddress,
};
@interface UserEdittingController : UserBaseViewController

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,assign) UserEdittingType editviewType;

@property (nonatomic,assign) NSInteger rowIndex;

@property (nonatomic,strong) NSString *rowStr;

@property (nonatomic,assign) NSInteger dataIndex;

@property (nonatomic,strong) UserSettingController *userSettingVC;


@property (nonatomic,strong) MatchSettingController *matchSettingVC;


@end
