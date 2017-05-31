//
//  BFSearchLocationController.m
//  BFTest
//
//  Created by 伯符 on 17/2/13.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFSearchLocationController.h"
#import "BFSliderCell.h"
#import "BFSearchLocationDetailController.h"
@interface BFSearchLocationController ()

@end

@implementation BFSearchLocationController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data.count != 0) {
        return _data.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellident = @"BFSearchUserCell";
    
    BFSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[BFSliderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellident];
        cell.line.hidden = YES;
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.titleLabel.frame = CGRectMake(0, 0, 180*ScreenRatio, 18*ScreenRatio);
        cell.titleLabel.center = CGPointMake(CGRectGetMaxX(cell.imgView.frame) + 95*ScreenRatio, 59*ScreenRatio/2);
        cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (_data.count != 0) {
        NSDictionary *content = _data[indexPath.row];
        cell.titleLabel.text = content[@"name"];
        cell.imgView.image = [UIImage imageNamed:@"userlocationlogo"];
    }else{
        cell.titleLabel.text = @"";
        cell.imgView.image = [UIImage imageNamed:@"userlocationlogo"];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchViewController.searchBar resignFirstResponder];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_data.count != 0) {
        NSDictionary *content = _data[indexPath.row];
        if ([content[@"coordinates"] isKindOfClass:[NSArray class]]) {
            NSArray *ar = content[@"coordinates"];
            NSString *name = content[@"name"];
            CGFloat latitude = [ar[0] floatValue];
            CGFloat longitude = [ar[1] floatValue];
            BFSearchLocationDetailController *vc = [[BFSearchLocationDetailController alloc]initWithLocation:CLLocationCoordinate2DMake(longitude,latitude)locationName:name];
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
