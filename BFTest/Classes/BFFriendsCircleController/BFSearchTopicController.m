//
//  BFSearchTopicController.m
//  BFTest
//
//  Created by 伯符 on 17/2/13.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFSearchTopicController.h"
#import "BFDataGenerator.h"
#import "BFSliderCell.h"
#import "BFFrindsCircleController.h"
#import "RelateTopicsController.h"
@interface BFSearchTopicController ()

@end

@implementation BFSearchTopicController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellident = @"BFSearchUserCell";
    
    BFSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[BFSearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellident];
        cell.iconImage.frame = CGRectMake(0, 0, 23*ScreenRatio, 23*ScreenRatio);
        cell.iconImage.center = CGPointMake(30*ScreenRatio, 59*ScreenRatio/2);
        cell.iconImage.layer.cornerRadius = 0;
        cell.timeLabel.hidden = YES;
        //        cell.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSDictionary *dic = _data[indexPath.row];
    cell.topicDic = dic;

    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchViewController.searchBar resignFirstResponder];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_data.count > 0) {
        if (self.canEnter) {
            NSDictionary *dic = _data[indexPath.row];
            RelateTopicsController *vc = [[RelateTopicsController alloc]init];
            vc.linkStr = dic[@"theme"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59*ScreenRatio;
}


- (void)setData:(NSMutableArray *)data{
    _data = data;
    [self.tableView reloadData];
}

@end
