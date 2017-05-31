//
//  FansOrFocusController.m
//  BFTest
//
//  Created by 伯符 on 17/3/3.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "FansOrFocusController.h"
#import "BFSliderCell.h"
#import "UserMainController.h"

@interface FansOrFocusController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation FansOrFocusController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    /*
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
    */
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self achieveData];
}

- (void)backItemClick:(UIBarButtonItem *)back{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellident = @"BFDTUserCommentCell";
    BFSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[BFSearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellident];
        cell.timeLabel.hidden = NO;
    }
    BFFansModel *fans = self.dataArray[indexPath.row];
    cell.fansModel = fans;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*ScreenRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArray.count > 0) {
        BFFansModel *fans = self.dataArray[indexPath.row];
        
        UserMainController *vc = [[UserMainController alloc]init];
        vc.titlestr = fans.nikename;
        vc.jmid = fans.jmid;
        vc.isSelf = NO;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)achieveData{
    NSString *str;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.titleStr isEqualToString:@"我的关注"]) {
        str = [NSString stringWithFormat:@"%@/getfriendsfan",ALI_BASEURL];
    }else{
        str = [NSString stringWithFormat:@"%@/getfriendsflower",ALI_BASEURL];

    }
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"tkname":UserwordMsg,@"tok":JMTOKEN};
    }
    
    [BFNetRequest getWithURLString:str parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"s"]isEqualToString:@"t"]) {
            NSArray *content = dic[@"data"];
            NSLog(@"%@",dic);
            if (content.count != 0) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dic in content) {
                    BFFansModel *model = [BFFansModel configureModelWithDic:dic];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }else{
                NSString *str;
                if ([self.title isEqualToString:@"我的关注"]) {
                    str = @"暂时还无人关注你哦";
                }else if ([self.title isEqualToString:@"我的粉丝"]){
                    str = @"您还没有粉丝哦";
                }
                [self.tableView setBackgroundView:[self buidImage:@"hanofans" title:str up:YES]];
                [self.tableView reloadData];
                
            }
        }
        
    } failure:^(NSError *error) {
        //
    }];
}

- (UIView *)buidImage:(NSString *)imgstr title:(NSString *)tink up:(BOOL)isup{
    UIImage *img = [UIImage imageNamed:imgstr];
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    back.backgroundColor = BFColor(222, 222, 222, 1);
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60*ScreenRatio, 60*ScreenRatio)];
    if (isup) {
        imgview.center = CGPointMake(Screen_width/2, Screen_height/2 - 20*ScreenRatio);
    }else{
        imgview.center = CGPointMake(Screen_width/2, Screen_height/2 + 15*ScreenRatio);
    }
    imgview.image = img;
    imgview.contentMode = UIViewContentModeScaleAspectFill;
    [back addSubview:imgview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 20*ScreenRatio)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = BFFontOfSize(15);
    label.center = CGPointMake(Screen_width/2, CGRectGetMaxY(imgview.frame)+ 25*ScreenRatio);
    label.text = tink;
    [back addSubview:label];
    
    return back;
}


@end
