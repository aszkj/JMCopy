//
//  BFSearchUserController.m
//  BFTest
//
//  Created by 伯符 on 17/2/13.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFSearchUserController.h"
#import "BFDataGenerator.h"
#import "BFSliderCell.h"
#import "BFFrindsCircleController.h"
#import "UserDTViewController.h"
@interface BFSearchUserController ()

@end

@implementation BFSearchUserController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellident = @"BFSearchUserCell";
    
    BFSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[BFSearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellident];
        cell.timeLabel.hidden = YES;
    }
    NSDictionary *dic = _data[indexPath.row];
    cell.userDic = dic;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchViewController.searchBar resignFirstResponder];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDTViewController *uservc = [[UserDTViewController alloc]init];
    uservc.interestModel = nil;
    NSDictionary *dic = _data[indexPath.row];
    uservc.useruid = dic[@"uid"];

    [self.navigationController pushViewController:uservc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59*ScreenRatio;
}

- (void)setData:(NSMutableArray *)data{
    _data = data;
    [self.tableView reloadData];
}

@end
