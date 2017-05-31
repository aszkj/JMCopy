//
//  PrivacyController.m
//  BFTest
//
//  Created by 伯符 on 17/3/22.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "PrivacyController.h"
#import "EdittingBaseViewCell.h"

@interface PrivacyController (){
    PrivacyBaseViewCell *currentCell;
    NSString *jubaoContent;
    UIButton *save  ;
}
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray *subdataArray;

@end

@implementation PrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.title = @"隐私设置";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BFColor(247, 247, 247, 1);
    save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(0, 0, 40, 18);
    [save setTitle:@"确认" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *saveBtem = [[UIBarButtonItem alloc]initWithCustomView:save];
    [save addTarget:self action:@selector(saveUserMsg:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = saveBtem;
    save.hidden = YES;
}

- (void)saveUserMsg:(UIButton *)btn{
    if (!jubaoContent) {
        save.hidden = YES;
    }else{
        save.hidden = NO;
    }
    NSString *str = [NSString stringWithFormat:@"%@/SetPrivateMap",ALI_BASEURL];
    NSString *way;
    if ([jubaoContent isEqualToString:@"默认"]) {
        way = @"0";
    }else{
        way = @"1";
    }
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"tkname":UserwordMsg,@"way":way,@"tok":JMTOKEN};
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BFNetRequest postWithURLString:str parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"%@",dic);
        if ([dic[@"s"] isEqualToString:@"T"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlertViewTitle:@"设置失败" message:nil];
            
        }
    } failure:^(NSError *error) {
        //
    }];
}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)mesg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:mesg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)initData{
    self.dataArray = @[@"默认",@"隐身"];
    self.subdataArray = @[@"(其他用户将会看到您在地图上的位置)",@"(其他用户将不会看到您在地图上的位置)"];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identi = [NSString stringWithFormat:@"EditCell%ld",indexPath.row];
    PrivacyBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[PrivacyBaseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.subLabel.text = self.subdataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivacyBaseViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (currentCell == cell) {
        cell.isSelected = YES;
    }else{
        currentCell.isSelected = NO;
        cell.isSelected = YES;
        currentCell = cell;
    }
    jubaoContent = cell.titleLabel.text;
    save.hidden = NO;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*ScreenRatio;
}

@end
