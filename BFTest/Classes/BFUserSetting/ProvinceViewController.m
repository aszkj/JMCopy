//
//  ProvinceViewController.m
//  BFTest
//
//  Created by 伯符 on 16/10/28.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "ProvinceViewController.h"
#import "EdittingBaseViewCell.h"
@interface ProvinceViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *provinceList;
    EdittingBaseViewCell *currentCell;

}
@property (nonatomic,strong) NSArray *provinceArray;

@property (nonatomic,strong) NSString *selectContent;


@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"来自";
    self.rightStr = @"完成";
    [self initData];
    [self buildUI];
}

- (void)buildUI{
    provinceList = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, Screen_width, Screen_height ) style:UITableViewStylePlain];
    provinceList.delegate = self;
    provinceList.dataSource = self;
    provinceList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:provinceList];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.provinceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 39*ScreenRatio;
}

- (void)initData{
    self.provinceArray = @[@"北京",@"上海",@"天津",@"重庆",@"安徽",@"福建",@"甘肃",@"广东",@"贵州",@"河北",@"黑龙江",@"河南",@"湖北",@"湖南",@"吉林",@"江西",@"江苏",@"辽宁",@"山东",@"陕西",@"山西",@"四川",@"云南",@"浙江",@"青海",@"海南",@"台湾",@"广西",@"内蒙古",@"宁夏",@"西藏",@"新疆",@"香港",@"澳门"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identi = [NSString stringWithFormat:@"EditCell%ld",indexPath.row];
    EdittingBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[EdittingBaseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        
    }
    cell.titleLabel.text = self.provinceArray[indexPath.row];
    if (self.rowStr == self.provinceArray[indexPath.row]) {
        cell.isSelected = YES;
        currentCell = cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EdittingBaseViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectContent = self.provinceArray[indexPath.row];
//    self.rowStr = self.provinceArray[indexPath.row];
    if (currentCell == cell) {
        cell.isSelected = YES;
    }else{
//        self.rowStr = self.dataArray[indexPath.row];
        currentCell.isSelected = NO;
        cell.isSelected = YES;
        currentCell = cell;
    }
}

#pragma mark - 保存用户信息
- (void)saveUserMsg:(UIButton *)save{
    
    NSLog(@"%@",self.selectContent);
    [self.userSettingVC.dataArray replaceObjectAtIndex:5 withObject:self.selectContent];
    
    [self.navigationController popToViewController:self.userSettingVC animated:YES];
}

@end
