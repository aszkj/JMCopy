//
//  BFUserEditerTableViewAddTagVC.m
//  BFTest
//
//  Created by JM on 2017/4/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserEditerTableViewAddTagVC.h"
#import "BFUserInfoSelfDefinedVC.h"

@interface BFUserEditerTableViewAddTagVC ()

/*---- 添加新标签栏是否显示  -----*/
@property (nonatomic,assign)BOOL showAddTagView;
/*---- 配置当前控制器的model  -----*/
@property (nonatomic,strong)BFUserEditerTableViewAddTagVCSettingModel *settingModel;

@property (weak, nonatomic) IBOutlet UIView *addTagView;
@property (weak, nonatomic) IBOutlet UILabel *addTagText;
@property (nonatomic,assign) NSInteger dataSourceInfoCount;
@property (nonatomic,assign) BOOL isJumpBackFromSelfDefinVC;

/*---- 记录单选情况下 上次选中cell的下标  -----*/
@property (nonatomic,strong)NSIndexPath *currentIndexPath;


@end

@implementation BFUserEditerTableViewAddTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVC];
}
- (void)viewWillAppear:(BOOL)animated{
    if(self.isJumpBackFromSelfDefinVC == NO){
        [self setCellSelected];
    }
}
- (void)setCellSelected{
    //设置旗帜变量 判断从服务器返回的标签是不是默认标签之一
    BOOL isDefaultTag = NO;
    //根据控制器设置模型 查询到的当前页面对应的用户模型 的文本信息
    NSString *str = [self.model valueForKey: self.settingModel.keyForUserModel];
    NSMutableArray<NSString *>*dataSourceArrM = self.settingModel.infoArrM;
    //遍历数据源数组 将对应行选中
    for(int i = 0 ; i < dataSourceArrM.count; i++ ){
        if([str isEqualToString:dataSourceArrM[i]]){
            //将对应的cell设置选中
            self.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //如果本地标签数组中包含 则设置为YES
            isDefaultTag = YES;
        }
    }
    //遍历本地标签数组 都不包含
    if(isDefaultTag == NO && str != nil && ![str isEqualToString: @""]){
        //将标签插入数组第一个
        [dataSourceArrM insertObject:str atIndex:0];
        //设置第一个cell选中
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadData];
        [[self.tableView cellForRowAtIndexPath:self.currentIndexPath] setSelected:YES animated:NO];
    }
}
- (void)setupVC{
    //配置当前控制器
    self.settingModel = [[BFUserInfoEditDataSourceManager shardManager]getSettingModelWithIndexPath:self.callBack(@"")];
    self.dataSourceInfoCount = self.settingModel.infoArrM.count;
    
}
- (void)setSettingModel:(BFUserEditerTableViewAddTagVCSettingModel *)model{
    _settingModel = model;
    //设置导航栏标题
    self.title = model.title;
    //设置是否显示添加自定义标签栏
    if (!self.settingModel.showAddTagView) {
        [self.addTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.right.top.left.equalTo(self.tableView);
        }];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置tableView可以多选
    self.tableView.allowsMultipleSelection = self.settingModel.isMultipleSeleced;
    //设置标签栏提示
    self.addTagText.text = [NSString stringWithFormat:@"创建我自己的%@",self.settingModel.title];
    
}



//在跳出界面时调用block 把已选择的字符传到上个界面
- (void)viewWillDisappear:(BOOL)animated{
    NSMutableString *strM = [NSMutableString stringWithString:@""];
    
    if(self.settingModel.isMultipleSeleced ){
        for(NSIndexPath *index in self.tableView.indexPathsForSelectedRows){
            if ([strM isEqualToString:@""]){
                [strM appendString:self.settingModel.infoArrM[index.row]];
            }else{
                [strM appendString:[NSString stringWithFormat:@",%@",self.settingModel.infoArrM[index.row]]];
            }
        }
    }else{
        //如果没有对应选中的cell 则直接跳出
        if(self.tableView.indexPathsForSelectedRows.count == 0 || self.currentIndexPath == nil){
            self.callBack(nil);
            return;
        }
        strM = self.settingModel.infoArrM[self.tableView.indexPathForSelectedRow.row];
    }
    self.callBack(strM);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingModel.infoArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.settingModel.infoArrM[indexPath.row];
    if([str containsString:@"giveInfo_"]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"giveInfoCell" forIndexPath:indexPath];
        UILabel *label = [cell.contentView viewWithTag:100];
        if(label){
            label.text = [str substringFromIndex:9];
        }
        return cell;
        
    }else{
        
        BFUserEditSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BFUserEditSelectedCell" forIndexPath:indexPath];
        cell.infoLabel.text = self.settingModel.infoArrM[indexPath.row];
        return cell;
    }
}

#pragma mark - cell选中时调用的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!self.settingModel.isMultipleSeleced && self.currentIndexPath.section == indexPath.section && self.currentIndexPath.row == indexPath.row && self.currentIndexPath != nil){
        
        
        if(![self.settingModel.title isEqualToString:@"约会地点"]){//如果选项是约会地点 则不设置延时取消选中
            //找到重复点击的cell 延时取消选中
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                //如currentIndexPath为空则说明当前没有选中任何cell
                self.currentIndexPath = nil;
            });
        }
    }else{
        self.currentIndexPath = indexPath;
    }
    NSLog(@"indexPath ->%@",indexPath);
}

#pragma mark - 跳转到自定义编辑界面的准备
- (IBAction)jumpToDefineEditVC:(UIButton *)sender {
    [self performSegueWithIdentifier:@"BFUserInfoSelfDefinedVC_2" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    BFUserInfoSelfDefinedVC *vc = segue.destinationViewController;
    if([vc isKindOfClass:[BFUserInfoSelfDefinedVC class]]){
        vc.navTitle = [@"自定义"stringByAppendingString:self.title];
        vc.callAddTagBlock = ^(NSString *str) {
            
            if(self.settingModel.infoArrM.count > self.dataSourceInfoCount){
                //如果当前的标签数组标签数大于默认数量 则将新标签替换第一个标签
                [self.settingModel.infoArrM replaceObjectAtIndex:0 withObject:str];
            }else{
                //如果当前标签数组标签数等于默认数量 则将新标签插入到第一个标签
                [self.settingModel.infoArrM insertObject:str atIndex:0];
            }
            self.isJumpBackFromSelfDefinVC = YES;
            
            
            //将此时tableView已选中的cell 取消选中
            NSIndexPath *index = self.tableView.indexPathForSelectedRow;
            if(index){
                [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            //将新添加的标签对应的第一个cell设置选中
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        };
    }
}
@end
