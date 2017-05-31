//
//  BFSettingController.m
//  BFTest
//
//  Created by 伯符 on 16/12/20.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFSettingController.h"
#import "BFSliderCell.h"
#import "JinMaimMainController.h"
#import "BFNavigationController.h"
#import "BFChatHelper.h"
#import "PrivacyController.h"
#import "BFBlackListController.h"
#import "BFHXDetailViewController.h"
#import "SDWebImageManager.h"


@interface BFSettingController ()

@end

@implementation BFSettingController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (NSArray *)dataArray{
    if(_dataArray == nil){
        //    self.dataArray = @[@[@"账号与安全"],@[@"消息通知"],@[@"黑名单",@"清理缓存"],@[@"帮助",@"隐私"],@[@"退出当前账号"]];
        //        _dataArray = @[@[@"账号与安全"],@[@"消息通知"],@[@"黑名单",@"清理缓存"],@[@"退出当前账号"]];
        _dataArray = @[@[@"黑名单",@"清理缓存"],@[@"退出当前账号"]];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BFColor(247, 247, 247, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)backItemClick:(UIBarButtonItem *)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.dataArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *setcell = @"BFSettingCell";
    BFSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:setcell];
    if (!cell) {
        cell = [[BFSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setcell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1){
        NSString *str = [NSString stringWithFormat:@"%fM", [self checkTmpSize]/1024];
        cell.detailTextLabel.text =  str;
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 5*ScreenRatio)];
    back.backgroundColor = BFColor(247, 247, 247, 1);
    return back;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        BFHXDetailViewController *vc = [[UIStoryboard storyboardWithName:@"BFIMViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"BFHXDetailViewController"];
        vc.detailVCType = BFHXDetailVCTypeBlackList;
        vc.navTitle = @"黑名单";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        
        [self showAlertViewTitle:@"退出登录" message:@"是否确定退出当前账号，退出后将无法收到消息" sureAction:^{
            
            [[BFUserLoginManager shardManager]cleanLocalUserInfo];
            JinMaimMainController *main = [[JinMaimMainController alloc]init];
            BFNavigationController *nv = [[BFNavigationController alloc]initWithRootViewController:main];
            NSLog(@"当前线程 ->%@", [NSThread currentThread]);
            [UIApplication sharedApplication].keyWindow.rootViewController = nv;
            
        } cancelAction:^{
            [self.tableView reloadData];
        }];
        
        
    }else if(indexPath.section == 0 && indexPath.row == 1){
        
        [self showAlertViewTitle:@"清理缓存" message:@"根据缓存文件大小，清理时间从几秒钟到几分钟不等，请耐心等待" sureAction:^{
            [self clearCache];
        } cancelAction:^{
            [self.tableView reloadData];
        }];
    }
}

- (float)checkTmpSize
{
    float totalSize = 0;
    NSString *path = [self getCachePath];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath: path];
    
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath  = [path stringByAppendingPathComponent: fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: filePath error: nil];
        unsigned long long length = [attrs fileSize];
        
        if([[[fileName componentsSeparatedByString: @"/"] objectAtIndex: 0] isEqualToString: @"URLCACHE"])
            continue;
        
        totalSize += length / 1024.0;
    }
    return  totalSize;
}

- (void)clearCache
{
     float tmpSizeBegan = [self checkTmpSize];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache clearDisk];
    [manager.imageCache clearMemory];
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *base_path = [self getCachePath];
    NSString *path = [NSString stringWithFormat: @"%@/%@", base_path, identifier];
    [fileManager removeItemAtPath: path error: nil];
    
    float tmpSizeDone = [self checkTmpSize];
    
    NSString *str = [NSString stringWithFormat:@"已清理%.2fM缓存", (tmpSizeBegan - tmpSizeDone)/1024];
//    NSString *str = [NSString stringWithFormat:@"清理缓存完成"];
    [self showAlertViewTitle:nil message:str duration:1];

    [self.tableView reloadData];
}
- (NSString *)getCachePath{
    //获取Cache路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}


@end
