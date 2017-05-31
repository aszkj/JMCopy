//
//  BFUserOtherChangeRemarkNameVCViewController.m
//  BFTest
//
//  Created by JM on 2017/4/12.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserOtherChangeRemarkNameVC.h"
#import "BFOriginNetWorkingTool+userRelations.h"

@interface BFUserOtherChangeRemarkNameVC ()

@property (weak, nonatomic) IBOutlet UITextField *remarkNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *remarkNameLabel;

@end

@implementation BFUserOtherChangeRemarkNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setSettingModel:(BFUserOthersSettingModel *)settingModel{
    _settingModel = settingModel;
    
//    self.remarkNameLabel.text = settingModel.remarkName;
}

- (void)viewWillAppear:(BOOL)animated{
    [BFOriginNetWorkingTool getNickNameWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:self.model.jmid  completionHandler:^(NSString *code, NSString *nickName, NSString *remarkName, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(code.integerValue == 200){
                self.remarkNameLabel.text = nickName;
                self.remarkNameTextField.text = remarkName;
            }
        });
    }];
}

- (IBAction)saveRemarkNameItem:(UIBarButtonItem *)sender {
    
    
    if(self.remarkNameTextField.text.length > 10){
        [self showAlertViewTitle:@"输入的备注名称大于10个字符！请重新输入！" message:nil];
        return;
    }
    
    [BFOriginNetWorkingTool setRemarkNameWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:self.model.jmid remarkName:self.remarkNameTextField.text completionHandler:^(NSString *code, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!error){
#warning 这里需要再调用户的备注名接口
                [self.remarkNameTextField resignFirstResponder];
                [self viewWillAppear:NO];
                [self showAlertViewTitle:@"修改备注名成功！" message:nil duration:1];
            }else{
                [self showAlertViewTitle:@"修改备注名失败！" message:error.description];
            }
        });
        
    }];
}

@end
