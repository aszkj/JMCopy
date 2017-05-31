//
//  JuBaoTableViewController.m
//  BFTest
//
//  Created by 伯符 on 17/3/21.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "JuBaoTableViewController.h"
#import "EdittingBaseViewCell.h"
#import "JuBaoWebView.h"
#import "TTTAttributedLabel.h"
@interface JuBaoTableViewController ()<TTTAttributedLabelDelegate>{
    EdittingBaseViewCell *currentCell;
    NSString *jubaoContent;
    TTTAttributedLabel *jbemLabel;
}
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *jbackView;
@end

@implementation JuBaoTableViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_jbackView) {
        [_jbackView removeFromSuperview];
        _jbackView = nil;
    }
    
}

- (UIView *)jbackView{
    if (!_jbackView) {
        _jbackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        _jbackView.backgroundColor = BFColor(247, 247, 247, 1);
        UIImageView *flag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jbflag"]];
        flag.frame = CGRectMake(20*ScreenRatio, Screen_height/2 - 100*ScreenRatio, 40*ScreenRatio, 40*ScreenRatio);
        flag.contentMode = UIViewContentModeScaleAspectFit;
        [_jbackView addSubview:flag];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(flag.frame)+7*ScreenRatio, CGRectGetMinY(flag.frame), Screen_width - CGRectGetMaxX(flag.frame) - 7*ScreenRatio - 20*ScreenRatio, 50*ScreenRatio)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = @"举报已提交,我们将在2小时内进行处理(夜间时段会稍有延迟)";
        [_jbackView addSubview:label];
    
        
        NSString *matchstr = @"《近脉生活平台行为规范》";
        NSString *titleStr = @"我们会依据《近脉生活平台行为规范》";
        NSMutableAttributedString *disclaimer = [[NSMutableAttributedString alloc]initWithString:titleStr];

        jbemLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 20*ScreenRatio)];
        jbemLabel.center = CGPointMake(Screen_width/2 , CGRectGetMaxY(label.frame)+15*ScreenRatio);
        jbemLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        jbemLabel.numberOfLines = 0;
        jbemLabel.delegate = self;
        jbemLabel.textAlignment = NSTextAlignmentCenter;
        [disclaimer addAttribute:NSFontAttributeName value:BFFontOfSize(14) range:NSMakeRange(0, titleStr.length)];
        [disclaimer addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, titleStr.length)];

        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
        [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkAttributes setValue:BFThemeColor forKey:NSForegroundColorAttributeName];

        jbemLabel.linkAttributes = linkAttributes;
        
        jbemLabel.attributedText = disclaimer;
        [jbemLabel addLinkToURL:[NSURL URLWithString:@"https://userapi.jinmailife.com:8000/agreement2.html"] withRange:[titleStr rangeOfString:matchstr]];
        
        [_jbackView addSubview:jbemLabel];
        
        UILabel *botlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*ScreenRatio, 20*ScreenRatio)];
        botlab.center = CGPointMake(Screen_width/2, CGRectGetMaxY(jbemLabel.frame)+7*ScreenRatio);
        botlab.textAlignment = NSTextAlignmentCenter;
        botlab.font = BFFontOfSize(14);
        botlab.textColor = [UIColor grayColor];
        botlab.text = @"进行审核，谢谢合作";
        [_jbackView addSubview:botlab];
        
    }
    return _jbackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.title = @"举报";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BFColor(247, 247, 247, 1);
}

- (void)initData{
    self.dataArray = @[@"广告欺诈",@"淫秽色情",@"骚扰谩骂",@"反动政治",@"血腥暴力",@"其他违法行为"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identi = [NSString stringWithFormat:@"EditCell%ld",indexPath.row];
    EdittingBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[EdittingBaseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    cell.titleLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EdittingBaseViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    if (currentCell == cell) {
        cell.isSelected = YES;
    }else{
        currentCell.isSelected = NO;
        cell.isSelected = YES;
        currentCell = cell;
    }
    jubaoContent = cell.titleLabel.text;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 25*ScreenRatio)];
    back.backgroundColor = BFColor(247, 247, 247, 1);
    UILabel *titlela = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenRatio, 0, 250, 25*ScreenRatio)];
    titlela.textAlignment = NSTextAlignmentLeft;
    titlela.textColor = [UIColor lightGrayColor];
    titlela.font = BFFontOfSize(14);
    titlela.text = @"请选择举报内容:";
    [back addSubview:titlela];
    return back;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 80*ScreenRatio)];
    back.backgroundColor = BFColor(247, 247, 247, 1);
    UIButton *jubao = [UIButton buttonWithType:UIButtonTypeCustom];
    jubao.frame = CGRectMake(20*ScreenRatio, 25*ScreenRatio, Screen_width - 40*ScreenRatio, 35*ScreenRatio);
    jubao.layer.cornerRadius = 4*ScreenRatio;
    jubao.layer.masksToBounds = YES;
    [jubao setBackgroundColor:BFThemeColor];
    [jubao setTitle:@"举报" forState:UIControlStateNormal];
    [jubao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jubao.titleLabel.font = BFFontOfSize(15);
    [jubao addTarget:self action:@selector(jubaoClick:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:jubao];
    return back;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70*ScreenRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*ScreenRatio;
}

- (void)jubaoClick:(UIButton *)btn{
    if (!jubaoContent) {
        [self showAlertViewTitle:@"请选择举报内容" message:nil];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.title = @"举报成功";
        [self.view addSubview:self.jbackView];
        
    });
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    JuBaoWebView *vc = [[JuBaoWebView alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pathURL = url;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
