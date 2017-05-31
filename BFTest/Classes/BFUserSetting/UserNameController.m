//
//  UserNameController.m
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserNameController.h"

#define MAX_LIMIT_NUMS 10
@interface UserNameController ()<UITextViewDelegate>{
    UITextView *userNameTV;
}
@property (nonatomic,strong) UILabel *wordNumLabel;
@end

@implementation UserNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

- (void)buildUI{
    
    self.title = self.comeFrom ? self.comeFrom : @"用户名";
    self.rightStr = @"完成";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BFColor(243, 243, 242, 1);
    userNameTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 90)];
    userNameTV.textAlignment = NSTextAlignmentLeft;
    userNameTV.text = self.placeholderStr;
    userNameTV.delegate = self;
    userNameTV.font = BFFontOfSize(15);
    [self.view addSubview:userNameTV];
    self.wordNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width - 20 - 60, CGRectGetMaxY(userNameTV.frame)+5, 60*ScreenRatio, 20)];
    self.wordNumLabel.textColor = [UIColor grayColor];
    self.wordNumLabel.textAlignment = NSTextAlignmentCenter;
    NSInteger maxWords ;
    if (self.rowIndex == 3) {
        maxWords = 100;
    }else{
        maxWords = 10;
    }
    self.wordNumLabel.text = [NSString stringWithFormat:@"%ld",maxWords];
    [self.view addSubview:self.wordNumLabel];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    return YES;
}

- (void)saveUserMsg:(UIButton *)save{
    
    NSInteger maxWords ;
    if (self.rowIndex == 3 || self.rowIndex == 9) {
        maxWords = 100;
    }else{
        maxWords = 10;
    }
    NSString *name = userNameTV.text;
    NSString *ishasname = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (userNameTV.text.length > maxWords) {
        NSString *alert = [NSString stringWithFormat:@"请输入%ld字符以内",maxWords];
        [self showAlertViewTitle:alert message:nil];
        return;
    }
    
    if ([self.title isEqualToString:@"用户名"] && ishasname.length == 0) {
        [self showAlertViewTitle:@"请输入用户名" message:nil];
    }
//    if (self.rowIndex == 3 || self.rowIndex == 9 || self.rowIndex == 9) {
//        // 来自 ---- 创建自己的标签   或者 兴趣爱好标签
//        [self.userSettingVC.dataArray replaceObjectAtIndex:self.rowIndex withObject:userNameTV.text];
//        [self.navigationController popToViewController:self.userSettingVC animated:YES];
//    }else{
        [self.userSettingVC.dataArray replaceObjectAtIndex:self.rowIndex withObject:userNameTV.text];
    [self.userSettingVC.userList reloadData];
        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}
@end
