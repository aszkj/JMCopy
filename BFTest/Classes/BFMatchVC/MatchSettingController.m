//
//  MatchSettingController.m
//  BFTest
//
//  Created by 伯符 on 17/1/11.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "MatchSettingController.h"
#import "BFSliderCell.h"
#import "UserEdittingController.h"
#import "BFChatHelper.h"
@interface MatchSettingController ()<BFAgeSliderCellValueChange>{
    NSString *selectSex;
    NSString *ageonestr;
    NSString *agetwostr;
    NSString *shieldFrid;
    NSString *likeEachOtherFocus;
}
@property (nonatomic,strong)BFAgeSliderCell *cell;

@property (nonatomic,strong)UILabel *agesliderL;

@end

@implementation MatchSettingController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"啵一下设置";
    selectSex = @"女";
    [self configureBarItem];
    [self achieveData];

}

- (void)achieveData{
    NSDictionary *dic = [BFChatHelper getDataFromDB:@"BoSetting"];
    if (dic && dic[@"selectSex"]) {
        self.gender = dic[@"selectSex"];
        ageonestr = dic[@"ageonestr"];
        agetwostr = dic[@"agetwostr"];
        shieldFrid = dic[@"shieldFrid"];
        likeEachOtherFocus = dic[@"likeEachOtherFocus"];
        
        [self.tableView reloadData];
    }else{
        // 设置默认值
        NSString *genderStr = [BFUserLoginManager shardManager].sex;

        self.gender = [genderStr isEqualToString:@"0"] ? @"男":@"女";
        ageonestr = @"16";
        agetwostr = @"50";
        shieldFrid = @"0";
        likeEachOtherFocus = @"1";
        [self.tableView reloadData];

    }
}

- (void)configureBarItem{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 40, 18);
    [back setTitle:@"取消" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:back];
    [back addTarget:self action:@selector(backpush:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBar;
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(0, 0, 40, 18);
    [save setTitle:@"确认" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *saveBtem = [[UIBarButtonItem alloc]initWithCustomView:save];
    [save addTarget:self action:@selector(saveUserMsg:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = saveBtem;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)backpush:(UIButton *)btn{
    
    [self showAlertViewTitle:@"是否放弃本次修改？" message:nil  sureAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } cancelAction:^{
        
    }];
}

// 保存设置
- (void)saveUserMsg:(UIButton *)btn{
    
    [self showAlertViewTitle:@"设置成功" message:nil];
    NSLog(@"%@",self.gender);

    [BFChatHelper saveToLocalDB:@{@"selectSex":self.gender,@"ageonestr":ageonestr,@"agetwostr":agetwostr,@"likeEachOtherFocus":likeEachOtherFocus,@"shieldFrid":shieldFrid} saveIdenti:@"BoSetting"];

}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? 2 : 1;
//    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellident = @"BFSliderCell";
        BFMatchSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
        if (!cell) {
            cell = [[BFMatchSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.titleLabel.text = @"向我显示";
        cell.accessLabel.hidden = NO;
        cell.switchBtn.hidden = YES;
        if (self.gender.length > 0) {
            cell.accessLabel.text = self.gender;
            selectSex = self.gender;
        }else{
            cell.accessLabel.text = @"男";
            selectSex = @"男";

        }
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString *cellident = @"BFAgeSliderCell";
        BFAgeSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
        if (!cell) {
            cell = [[BFAgeSliderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
            cell.delegate = self;
        }
        self.cell = cell;
        self.cell.rangeSlider.selectedMinimum = [ageonestr intValue];
        self.cell.rangeSlider.selectedMaximum = [agetwostr intValue];

        return cell;
    }
    
    if (indexPath.section == 2 || indexPath.section == 3) {
        
        static NSString *cellident = @"BFSwitchCell";
        BFMatchSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
        if (!cell) {
            cell = [[BFMatchSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];

        }
        [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.switchBtn.tag = indexPath.row;
        NSString *str ;
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                str = @"屏蔽近脉生活好友";
                cell.switchBtn.on = [shieldFrid intValue];

            }else{
//                str = @"屏蔽近脉生活好友";
                str = @"互相喜欢自动关注对方";
                cell.switchBtn.on = [likeEachOtherFocus intValue];

            }
        }
//        else{
//            str = @"互相喜欢自动关注对方";
//            [cell.switchBtn setOn:YES animated:YES];
//        }
        cell.titleLabel.text = str;
        cell.accessLabel.hidden = YES;
        return cell;
    }

    
    return nil;
}
/*
- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    
    self.agesliderL.text = age;
}
*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 35*ScreenRatio)];
        back.backgroundColor = BFColor(235, 236, 237, 1);
        UILabel *metaddressL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*ScreenRatio, 20*ScreenRatio)];
        metaddressL.center = CGPointMake(30*ScreenRatio, back.height/2);
        metaddressL.text = @"年龄";
        metaddressL.textColor = [UIColor blackColor];
        metaddressL.font = BFFontOfSize(13);
        metaddressL.textAlignment = NSTextAlignmentCenter;
        [back addSubview:metaddressL];
        
        self.agesliderL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*ScreenRatio, 20*ScreenRatio)];
        self.agesliderL.center = CGPointMake(CGRectGetMaxX(metaddressL.frame) + 60*ScreenRatio + 10*ScreenRatio, back.height/2);
        self.agesliderL.textColor = [UIColor redColor];
        self.agesliderL.font = BFFontOfSize(13);
        self.agesliderL.textAlignment = NSTextAlignmentLeft;
        [back addSubview:self.agesliderL];
        if (!ageonestr || !agetwostr) {
            ageonestr = @"16";
            agetwostr = @"35";
        }
        NSString *str = [NSString stringWithFormat:@"%@ - %@",ageonestr,agetwostr];
        self.agesliderL.text = str;

        
        return back;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 35*ScreenRatio;
    }else{
        return 15*ScreenRatio;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*ScreenRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UserEdittingController *vc = [[UserEdittingController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.matchSettingVC = self;
        vc.editviewType = UserEdittingTypeMapGender;
        vc.titleStr = @"性别";

    }
}

- (void)sliderChangedmin:(float)valueone max:(float)valuetwo{
    NSString *str = [NSString stringWithFormat:@"%d - %d",(int)valueone,(int)valuetwo];
    ageonestr = [NSString stringWithFormat:@"%d",(int)valueone];
    agetwostr = [NSString stringWithFormat:@"%d",(int)valuetwo];
    self.agesliderL.text = str;
}

- (void)switchAction:(UISwitch *)swtich{
    if (swtich.tag == 0) {
        shieldFrid = [NSString stringWithFormat:@"%d",swtich.on];
    }else{
        likeEachOtherFocus = [NSString stringWithFormat:@"%d",swtich.on];
    }
    
}


@end
