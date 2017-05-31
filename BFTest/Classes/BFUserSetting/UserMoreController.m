//
//  UserMoreController.m
//  BFTest
//
//  Created by 伯符 on 17/3/25.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "UserMoreController.h"
#import "BFSliderCell.h"
#import "JuBaoTableViewController.h"
#import "BFAlertView.h"
#import "EMSDK.h"
#import "BFChatHelper.h"
@interface UserMoreController ()
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation UserMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.title = @"好友设置";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BFColor(247, 247, 247, 1);
}

- (void)initData{
    self.dataArray = @[@"拉黑",@"举报"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *identi = [NSString stringWithFormat:@"EditCell%ld",indexPath.row];
        BFMatchSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
        if (!cell) {
            cell = [[BFMatchSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.titleLabel.text = @"拉黑";
        cell.accessLabel.hidden = NO;
        cell.switchBtn.hidden = NO;
        [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }else{
        NSString *identi = [NSString stringWithFormat:@"EditCell%ld",indexPath.row];
        BFSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
        if (!cell) {
            cell = [[BFSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.titleLabel.text = @"举报";
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        JuBaoTableViewController *vc = [[JuBaoTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*ScreenRatio;
}

- (void)switchAction:(UISwitch *)swtich{
    if (swtich.on) {
        
        BFAlertView *alertview = [BFAlertView alertViewWithContent:@"拉黑后将不会收到对方发来的消息,可在“设置>黑名单”中解除,是否确认?" mainBtn:@"确认" otherBtn:@"取消"];
        [alertview show];
        alertview.action = ^(UIButton *selectBtn){
            if ([selectBtn.titleLabel.text isEqualToString:@"确定"]) {
                swtich.on = YES;
                [[EMClient sharedClient].contactManager addUserToBlackList:self.jmuid completion:^(NSString *aUsername, EMError *aError) {
                    if (!aError) {
                        NSString *url = [NSString stringWithFormat:@"%@/getSmallInfo",ALI_BASEURL];
                        NSDictionary *para;
                        if (UserwordMsg && JMUSERID) {
                            para = @{@"tkname":UserwordMsg,@"tok":JMTOKEN,@"jmid":aUsername};
                        }
                        
                        [BFNetRequest postWithURLString:url parameters:para success:^(id responseObject) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                            NSLog(@"%@",dic);
                            NSMutableDictionary *userdic = [dic[@"userinfo"]firstObject];
                            [userdic setObject:aUsername forKey:@"jmid"];
                            if ([dic[@"s"]isEqualToString:@"t"]) {
                                NSMutableArray *cacheschat = [BFChatHelper getDataArrayFromDB:@"BlackUserCaches"];
                                if (cacheschat) {
                                    for (int i = 0; i < cacheschat.count; i ++) {
                                        NSDictionary *user = cacheschat[i];
                                        if ([userdic[@"jmid"] isEqualToString:user[@"jmid"]]) {
                                            [cacheschat removeObject:user];
                                        }
                                    }
                                    [cacheschat addObject:userdic];
                                    [BFChatHelper saveToLocalDB:cacheschat saveIdenti:@"BlackUserCaches"];
                                }else{
                                    NSMutableArray *ar = [NSMutableArray array];
                                    [ar addObject:userdic];
                                    [BFChatHelper saveToLocalDB:ar saveIdenti:@"BlackUserCaches"];
                                }
                            }
                        } failure:^(NSError *error) {
                            //
                        }];
                    }
                    
                }];
            }else{
                swtich.on = NO;
            }
        };
    }
}



@end
