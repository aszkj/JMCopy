//
//  EditDongtaiController.m
//  BFTest
//
//  Created by 伯符 on 16/12/22.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "EditDongtaiController.h"
#import "BFSliderCell.h"
#import "UITextView+Placeholder.h"
#import "BFNearbyPlaceController.h"
#import "QiniuSDK.h"

#import "EditDTFirstSearchController.h"
@interface EditDongtaiController (){
    NSArray *dataArray;
    UIImageView *sendimgView;
    UITextView *textView;
    CLLocationCoordinate2D selfCoordinate;
    NSString *location;
    NSString *qiniuToken;
    NSString *qiniuoid;
    UIButton *btn;
}

@end

@implementation EditDongtaiController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
//    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发动态";
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 45*ScreenRatio, 23*ScreenRatio);
    [btn setBackgroundColor:BFColor(243, 212, 13, 1)];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn addTarget:self action:@selector(sendDt:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.tableView.tableHeaderView =[self configureHeader];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    dataArray = @[@[@{@"icon":@"topic",@"title":@"话题"}],@[@{@"icon":@"bulb",@"title":@"谁可以看"}],@[@{@"icon":@"showlocate",@"title":@"显示位置"}]];
    dataArray = @[@[@{@"icon":@"topic",@"title":@"话题"}],@[@{@"icon":@"showlocate",@"title":@"显示位置"}]];
}

- (UIView *)configureHeader{
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 210*ScreenRatio)];
    back.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10*ScreenRatio, 10*ScreenRatio, Screen_width - 20*ScreenRatio, 90*ScreenRatio);
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.placeholder = @"分享新鲜事...";
    NSDictionary *attrs = @ {
    NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
    };
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attrs];
    textView.font = [UIFont systemFontOfSize:17];
    [back addSubview:textView];
    
    sendimgView = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenRatio, CGRectGetMaxY(textView.frame)+ 10*ScreenRatio, 90*ScreenRatio, 90*ScreenRatio)];
    sendimgView.contentMode = UIViewContentModeScaleAspectFill;
    sendimgView.clipsToBounds = YES;
    sendimgView.image = self.sendImage;
    [back addSubview:sendimgView];
    return back;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellident = @"BFSliderCell";
    
    BFEditDtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[BFEditDtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dic = dataArray[indexPath.section][indexPath.row];
    cell.imgView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.titleLabel.text = dic[@"title"];
//    if (indexPath.section == 0) {
//        cell.accessLabel.hidden = NO;
//        if (self.topic && self.topic.length > 0) {
//            cell.accessLabel.text = self.topic;
//            NSString *str = [NSString stringWithFormat:@"%@ ",self.topic];
//            textView.text = [textView.text stringByAppendingString:str];
//        }else{
//            cell.accessLabel.text = @"";
//        }
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        BFEditDtCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        BFNearbyPlaceController *vc = [[BFNearbyPlaceController alloc]init];
        vc.selectBlock = ^(NSString *str,CLLocationCoordinate2D currentLocationCoordinate){
            cell.accessLabel.textColor = [UIColor blueColor];
            cell.accessLabel.text = str;
            selfCoordinate = currentLocationCoordinate;
            location = str;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0){
        
        BFEditDtCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        EditDTFirstSearchController *searchvc = [[EditDTFirstSearchController alloc]init];
        searchvc.selectTopicBlock = ^(NSString *str){
            cell.accessLabel.text = str;
            NSString *content = [NSString stringWithFormat:@"%@ ",str];
            textView.text = [textView.text stringByAppendingString:content];
        };
        
        searchvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchvc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*ScreenRatio;
}

- (void)sendDt:(UIButton *)btn{
    
    if (!sendimgView.image) {
        [self showAlertViewTitle:@"请选择一张图片" message:nil];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/news/",DongTai_URL];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *coordinate = [NSString stringWithFormat:@"%f,%f",selfCoordinate.longitude,selfCoordinate.latitude];
    
    NSString *type = [NSString stringWithFormat:self.isImage ? @"I" : @"V"];
    NSData *imgData;
    NSDictionary *para;
    NSString *locationStr;
    if (location) {
        locationStr = location;
    }else{
        locationStr = @"";
    }
    if (UserwordMsg && JMTOKEN && coordinate.length > 0) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"message":textView.text,@"publish_datetime":dateString,@"coordinates":coordinate,@"type":type,@"location":locationStr};
    }
    NSLog(@"%@",para);
    if (self.isImage) {
        imgData = UIImageJPEGRepresentation(self.sendImage, 0.5);
    }else{
        imgData = [NSData dataWithContentsOfFile:self.videoPath];
    }

    [BFNetRequest postWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSLog(@"%@",dic[@"error_info"]);
        if ([dic[@"success"] intValue]) {
            NSDictionary *content = dic[@"content"];
            qiniuToken = content[@"token"];
            qiniuoid = content[@"x:oid"];
            
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNZone zone2];
            }];
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            QNUploadOption *uploadOption;
            if (qiniuoid && qiniuoid.length > 0) {
                uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                    NSLog(@"percent == %.2f", percent);
                } params:@{ @"x:oid":qiniuoid } checkCrc:NO cancellationSignal:nil];
            }
            
        //        [upManager putFile:filePath key:nil token:qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        //            NSLog(@"info ===== %@", info);
        //            NSLog(@"resp ===== %@", resp);
        //        }
        [upManager putData:imgData key:nil token:qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"resp ===x== %@", resp);
            if (resp[@"success"]) {
                // 发表成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SendDTSuccess" object:nil];
                });
                
            }
        } option:uploadOption];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",[error description]);
    }];

//    QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        [array addObject:[QNResolver systemResolver]];
//        QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
//        //是否选择  https  上传
//        builder.zone = [[QNAutoZone alloc] initWithHttps:YES dns:dns];
//        //设置断点续传
//        NSError *error;
//        builder.recorder =  [QNFileRecorder fileRecorderWithFolder:@"保存目录" error:&error];
//    }];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
