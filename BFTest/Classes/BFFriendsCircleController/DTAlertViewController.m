//
//  DTAlertViewController.m
//  BFTest
//
//  Created by 伯符 on 2017/4/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "DTAlertViewController.h"
#import "BFSliderCell.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "BFInterestModel.h"
#import "NSString+MD5.h"
#import "CommentFrame.h"
#import "BFDeleteView.h"
#import "UserDTDetailController.h"
@interface DTAlertViewController ()<UITableViewDelegate,UITableViewDataSource,RelyUserDelegate,DeleteDTDelegate>{
    BFCommentModel *selectModel;
    NSString *selectStr;
}


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSDictionary *dicdata;

@property (nonatomic,strong) NSMutableArray *commentArray;

@property (nonatomic,strong) NSMutableArray *commentFrameArray;
@end

@implementation DTAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态提醒";
    [self configureRightBtn];
    [self configureUI];
    [self achieveData];

}

- (void)configureRightBtn{
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(0, 0, 40, 18);
    [save setTitle:@"清空" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *saveBtem = [[UIBarButtonItem alloc]initWithCustomView:save];
    [save addTarget:self action:@selector(clearAlert:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = saveBtem;
}

- (void)clearAlert:(UIButton *)btn{
    BFDeleteView *deleteview = [[BFDeleteView alloc]initViewWithTitle:@"清空提醒"];
    deleteview.delegate = self;
//    selectCell = cell;
    [deleteview show];
}

- (void)configureUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (NSMutableArray *)commentFrameArray{
    if (!_commentFrameArray) {
        _commentFrameArray = [NSMutableArray array];
    }
    return _commentFrameArray;
}

- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BFDtAlertModel *model = self.dataArray[indexPath.item];
    UserDTDetailController *vc = [[UserDTDetailController alloc]init];
    vc.nid = model.nid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellident = @"BFDTUserCommentCell";
    BFDtAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[BFDtAlertCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellident];
    }
    BFDtAlertModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BFDtAlertModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"Z"]) {
        return 55*ScreenRatio;
    }else{
        CGFloat height = [model.message getHeightWithWidth:Screen_width - 65*ScreenRatio font:14];
        return height + 50*ScreenRatio;
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFDtAlertModel *model = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *str = [NSString stringWithFormat:@"%@/messages/%@/",DongTai_URL,model.mid];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *para;
        if (UserwordMsg && JMTOKEN) {
            para = @{@"uid":UserwordMsg,@"token":JMTOKEN};
        }

        [BFNetRequest deleteWithURLString:str parameters:para success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
            if ([dic[@"success"] intValue]) {
                [self showAlertViewTitle:@"删除提醒成功" message:nil];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } failure:^(NSError *error) {
            //
        }];
    }
}

- (void)achieveData{
    NSString *str = [NSString stringWithFormat:@"%@/messages/",DongTai_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"page_item_pos":@0};
    }
    
    [BFNetRequest getWithURLString:str parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *content = [dic[@"content"] objectForKey:@"messages"];
        if (content.count != 0) {
            for (NSDictionary *dicd in content) {
                BFDtAlertModel *model = [[BFDtAlertModel alloc]initModelWithDic:dicd];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];
}

- (void)deleteUserDT{
    
    NSString *str = [NSString stringWithFormat:@"%@/messages/",DongTai_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN};
    }
    
    [BFNetRequest deleteWithURLString:str parameters:para success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] intValue]) {
            [self showAlertViewTitle:@"删除提醒成功" message:nil];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];
    
}


@end
