//
//  EditDTFirstSearchController.m
//  BFTest
//
//  Created by 伯符 on 17/3/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "EditDTFirstSearchController.h"
#import "BFSearchBar.h"
#import "BFInterestSearchResultController.h"
#import "BFSliderCell.h"
#import "UIImage+Addition.h"
#import "BFNavigationController.h"
#import "BFFrindsCircleController.h"
#import "BFDataGenerator.h"
#import "BFTopicsSearchController.h"
@interface EditDTFirstSearchController ()<UITableViewDelegate,UITableViewDataSource,LLSearchControllerDelegate>{
    BFSearchBar *searchbar;
    UITableView *topicList;
}

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation EditDTFirstSearchController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索";
    [self addTableView];
    [self achieveData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectTopic) name:@"SelectTopic" object:nil];
}

- (void)selectTopic{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)achieveData{
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/",DongTai_URL];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"type":@"T",@"parm":@""};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
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
    topicList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height) style:UITableViewStylePlain];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    searchbar = [BFSearchBar defaultSearchBarWithFrame:CGRectMake(0, 0, Screen_width, SEARCH_TEXT_FIELD_HEIGHT + 16)];
    searchbar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    
    searchbar.delegate = self;
    searchbar.placeholder = @"搜索";
    
    return searchbar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SEARCH_TEXT_FIELD_HEIGHT + 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > 0) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        if (self.selectTopicBlock) {
            self.selectTopicBlock(dic[@"theme"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*ScreenRatio;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    BFInterestSearchResultController *vc = [BFInterestSearchResultController sharedInstance];
    BFNavigationController *navigationVC = [[BFNavigationController alloc] initWithRootViewController:vc];
    navigationVC.view.backgroundColor = [UIColor clearColor];
    vc.delegate = self;
    //    LLChatSearchController *resultController = [[LLUtils mainStoryboard] instantiateViewControllerWithIdentifier:SB_CONVERSATION_SEARCH_VC_ID];
    
    BFTopicsSearchController *resultController = [[BFTopicsSearchController alloc]init];
    resultController.canEnter = NO;
    resultController.editvc = self.editvc;
    vc.searchResultController = resultController;
    resultController.searchViewController = vc;
    [vc showInViewController:self fromSearchBar:searchbar];
    
    return NO;
}

- (void)willPresentSearchController:(LLSearchViewController *)searchController {
    
}

- (void)didPresentSearchController:(LLSearchViewController *)searchController {
    //    interestList.tableHeaderView = nil;
    /*
    searchbar = nil;
    CGRect frame = searchbar.frame;
    frame.origin.y = -frame.size.height;
    searchbar.frame = frame;
     */
}

- (void)willDismissSearchController:(LLSearchViewController *)searchController {
    
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        searchbar.hidden = YES;
        //        interestList.tableHeaderView = tableHeaderView;
        
    } completion:^(BOOL finished) {
        searchbar.hidden = NO;
    }];
    
}

- (void)didDismissSearchController:(LLSearchViewController *)searchController {
    
}

@end
