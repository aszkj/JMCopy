//
//  BFUserOthersSettingVC.m
//  BFTest
//
//  Created by JM on 2017/4/11.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#define ButtonHeight 40
//#define showBTN YES

#import "BFHXManager.h"
#import "BFUserOthersSettingVC.h"
#import "BFOriginNetWorkingTool+userRelations.h"
#import "BFUserOtherChangeRemarkNameVC.h"
#import "BFUserOtherReportVC.h"

@interface BFUserOthersSettingVC ()

@property (nonatomic,strong)BFUserOthersSettingModel *settingModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelFollowButtonHeightConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeFansButtonHeightConstaint;
@property (weak, nonatomic) IBOutlet UISwitch *addToBlacklistSwitch;


@end

@implementation BFUserOthersSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUI];
    self.title = @"更多";
}

- (void)setModel:(BFUserInfoModel *)model{
    _model = model;
}
- (void)hideButtons{
    self.cancelFollowButtonHeightConstaint.constant = 0;
    self.removeFansButtonHeightConstaint.constant = 0;
}

-(void)setSettingModel:(BFUserOthersSettingModel *)settingModel{
    _settingModel = settingModel;
    //这里要回到主线程 不然会崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUI];
    });
}

- (void)refreshUI{
    self.cancelFollowButtonHeightConstaint.constant = _settingModel.follow.intValue == 1 ? ButtonHeight : 0;
    self.removeFansButtonHeightConstaint.constant =  _settingModel.isMyFans.intValue == 1 ? ButtonHeight : 0;
    [self.addToBlacklistSwitch setOn:_settingModel.black.intValue == 1 animated:NO];
}

- (IBAction)addToBlacklistAction:(UISwitch *)sender {
    NSLog(@"------>%@", sender.isOn ? @"开" : @"关" );
    if(sender.isOn){
        
        [self showAlertViewTitle:nil message:@"拉黑后将不会收到对方发来的消息，可在”设置>黑名单“中解除。是否确认？" sureAction:^{
            //添加到黑名单
            [self addToBlackListMethod];
        } cancelAction:^{
            [UIView animateWithDuration:0.25 animations:^{
                [sender setOn:NO];
            }];
        }];
    }else{
        //加入黑名单
        [self deleteFormBlackListMethod];
    }
}

- (IBAction)cancelFollowButtonAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = [NSString stringWithFormat:@"确定不再关注%@吗？",[self.model.sex isEqualToString:@"男"] ? @"他":@"她"];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //这里调用取消关注的接口
            [self cancelFollowMethod];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消弹窗 不做操作

        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

- (IBAction)removeFansButtonAction:(id)sender {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = [NSString stringWithFormat:@"确定移除该粉丝吗？"];
                         //[self.model.sex isEqualToString:@"男"] ? @"他":@"她"];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //这里调用取消关注的接口
            [self removeFansMethod];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消弹窗 不做操作
            
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}
- (void)deleteFormBlackListMethod{
    
    [BFHXManager deleteBlackListWithOtherJmid:self.model.jmid callBack:^(NSString *code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(code.intValue == 200){
                [self showAlertViewTitle:@"从黑名单中删除成功！" message:nil];
            }else{
                [self showAlertViewTitle:@"从黑名单中删除失败！" message:nil];
            }
        });
    }];
}

- (void)addToBlackListMethod{
    
    [BFHXManager addBlackListWithOtherJmid:self.model.jmid callBack:^(NSString *code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(code.intValue == 200){
                [self showAlertViewTitle:@"添加到黑名单成功！" message:nil];
            }else{
                [self showAlertViewTitle:@"添加到黑名单失败！" message:nil];
            }
        });
    }];
}
/**
 移除粉丝
 */
- (void)removeFansMethod{
    
    AsMyShipType type = self.settingModel.follow.intValue == 0 ? AsMyShipTypeFans : AsMyShipTypeFriend;

    [BFHXManager deleteFansFromOtherJmid:self.model.jmid asMyship:type callBack:^(NSString *code) {
        dispatch_async(dispatch_get_main_queue(), ^{
                        if(code.intValue == 200){
                            [self showAlertViewTitle:@"移除粉丝成功" message:nil];
                            [BFOriginNetWorkingTool getuserRelationsModelWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:self.model.jmid completionHandler:^(BFUserOthersSettingModel *model, NSError *error) {
                                self.settingModel = model;
                            }];
                        }
                    });
    }];
}

/**
 这里调用取消关注的接口
 */
- (void)cancelFollowMethod{
    
    
    AsMyShipType type = self.settingModel.isMyFans.intValue == 0 ? AsMyShipTypeFollow : AsMyShipTypeFriend;

    
    [BFHXManager deleteFollowToOtherJmid:self.model.jmid asMyship:type callBack:^(NSString *code) {
        dispatch_async(dispatch_get_main_queue(), ^{
                        if(code.intValue == 200){
                            [self showAlertViewTitle:@"取消关注成功" message:nil];
                            [BFOriginNetWorkingTool getuserRelationsModelWithSelfJmid:[BFUserLoginManager shardManager].jmId otherJmid:self.model.jmid completionHandler:^(BFUserOthersSettingModel *model, NSError *error) {
                                self.settingModel = model;
                            }];
                        }
                    });
    }];
}

/**
 控制器跳转的准备
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BFUserOtherChangeRemarkNameVC *vc = segue.destinationViewController;
    if( [vc isMemberOfClass:[BFUserOtherReportVC class]]){
        vc.model = self.model;
        vc.settingModel = self.settingModel;
        vc.title = @"举报";
    }
    
    if([vc isMemberOfClass:[BFUserOtherChangeRemarkNameVC class]] ){
        vc.model = self.model;
        vc.settingModel = self.settingModel;
        vc.title = @"设置备注名";
    }

    
}

@end
