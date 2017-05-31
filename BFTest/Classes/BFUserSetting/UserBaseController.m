//
//  UserBaseController.m
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserBaseController.h"

@interface UserBaseController ()
@property (nonatomic,strong) UIButton *rightBar;

@end

@implementation UserBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBarItem];

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
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *saveBtem = [[UIBarButtonItem alloc]initWithCustomView:save];
    [save addTarget:self action:@selector(saveUserMsg:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = saveBtem;
    self.rightBar = save;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 39*ScreenRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 6, Screen_width - 40, 39*ScreenRatio - 12)];
    [cell addSubview:titleLabel];
    return cell;
}

- (void)backpush:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveUserMsg:(UIButton *)save{
    [self showAlertViewTitle:@"保存成功" message:nil];
}


@end
