//
//  BFTopicsSearchController.m
//  BFTest
//
//  Created by 伯符 on 17/3/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFTopicsSearchController.h"
#import "BFSliderCell.h"
#import "BFDataGenerator.h"
#import "RelateTopicsController.h"
@interface BFTopicsSearchController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *topicList;
}


@property (nonatomic,strong)NSArray *titles;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic) BFSearchBar *searchBar;

@property (nonatomic, copy) NSString *searchText;
@end

@implementation BFTopicsSearchController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self achieveData];

}

- (void)achieveData{
//    NSString *urlStr = @"http://news.jinmailife.com/search/";
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/",DongTai_URL];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"type":@"T",@"parm":@""};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            NSArray *content = dic[@"content"];
            if (content.count > 0) {
                for (NSDictionary *picDic in content) {
                    [self.dataArray addObject:picDic];
                }
                if (!topicList) {
                    [self addTableView];
                }else{
                    [topicList reloadData];
                }
            }
            
        }
    } failure:^(NSError *error) {
        //
    }];
}

- (void)addTableView{
    topicList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - NavBar_Height) style:UITableViewStylePlain];
    topicList.tableFooterView = [[UIView alloc]init];
    topicList.delegate = self;
    topicList.dataSource = self;
    [self.view addSubview:topicList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.topicDic = dic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > 0) {
        if (self.canEnter) {
            NSDictionary *dic = self.dataArray[indexPath.row];
            RelateTopicsController *vc = [[RelateTopicsController alloc]init];
            vc.linkStr = dic[@"theme"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSDictionary *dic = self.dataArray[indexPath.row];
            self.editvc.topic = dic[@"theme"];
            NSLog(@"%@",self.editvc);
            [self.searchViewController hide];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SelectTopic" object:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*ScreenRatio;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _searchBar = self.searchViewController.searchBar;
}

//- (void)tapHandler:(UITapGestureRecognizer *)tap {
//    //    if (self.searchResultView.hidden)
//    [self.searchViewController dismissKeyboard];
//}


- (void)searchTextDidChange:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (void)searchButtonDidTapped:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (BOOL)shouldShowSearchResultControllerBeforePresentation {
    return YES;
}

- (BOOL)shouldHideSearchResultControllerWhenNoSearch {
    return NO;
}

- (void)searchWithText:(NSString *)searchText {
    if (![self.searchBar.placeholder isEqualToString:@"搜索"]) {
        return;
    }
    
//    NSString *urlStr = @"http://news.jinmailife.com/search/";
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/",DongTai_URL];
    NSDictionary *para;
    if (!searchText) {
        searchText = @"";
    }
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"type":@"T",@"parm":searchText};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            NSArray *content = dic[@"content"];
            if (content.count > 0) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *picDic in content) {
                    [self.dataArray addObject:picDic];
                }
                if (!topicList) {
                    [self addTableView];
                }else{
                    [topicList reloadData];
                }
            }
            
        }
    } failure:^(NSError *error) {
        //
    }];
    
}






@end
