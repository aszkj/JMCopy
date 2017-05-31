//
//  BFBlackListController.m
//  BFTest
//
//  Created by 伯符 on 17/3/25.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFBlackListController.h"
#import "BFSliderCell.h"
#import "BFChatHelper.h"
@interface BFBlackListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation BFBlackListController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
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
    NSDictionary *blackuser = self.dataArray[indexPath.row];
    cell.blackDic = blackuser;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*ScreenRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    NSDictionary *user = self.dataArray[indexPath.row];
     if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[EMClient sharedClient].contactManager removeUserFromBlackList:user[@"jmid"] completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                NSMutableArray *cacheschat = [BFChatHelper getDataArrayFromDB:@"BlackUserCaches"];
                if (cacheschat.count > 0) {
                    for (int i = 0; i < cacheschat.count; i ++) {
                        NSDictionary *user = cacheschat[i];
                        if ([user[@"jmid"] isEqualToString:aUsername]) {
                            [cacheschat removeObject:user];
                        }
                    }

                    [BFChatHelper saveToLocalDB:cacheschat saveIdenti:@"BlackUserCaches"];
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];

                }
            }
        }];
     }
}

- (void)achieveData{
    NSMutableArray *cacheschat = [BFChatHelper getDataArrayFromDB:@"BlackUserCaches"];
    if (cacheschat.count > 0) {
        NSLog(@"%@",cacheschat);
        for (NSDictionary *user in cacheschat) {
            [self.dataArray addObject:user];
        }
        [self.tableView reloadData];
    }
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
