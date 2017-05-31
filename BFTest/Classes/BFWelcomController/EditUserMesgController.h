//
//  EditUserMesgController.h
//  BFTest
//
//  Created by 伯符 on 17/3/4.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTabbarController.h"

@interface EditUserMesgController : UIViewController{
    UITextField *nicknameTF;
    UITextField *birthTF;
    UIButton *selectBtn;
    NSString *selectSex;
    UIImageView *icon;
    NSString *imgPath;
    NSString *constellationStr;
    NSString *agestr;
    UIView *back2;
    BOOL imageExist;
}

@property (nonatomic,copy) NSString *userword;
@property (nonatomic,copy) NSString *pass;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *token;
@property (strong, nonatomic) NSDate* birthday;
@property (nonatomic,strong) UIDatePicker *datePicker;

- (void)achieveUserData;
- (void)configureUI;
- (void)getAgeWith:(NSDate*)birthday;

@end
