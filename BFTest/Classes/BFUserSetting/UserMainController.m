//
//  UserMainController.m
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserMainController.h"
#import "UserSettingController.h"
#import "UserHeaderViewCell.h"
#import "DongtaiViewCell.h"
#import "DengjiViewCell.h"
#import "FansCareViewCell.h"
#import "AccountViewCell.h"
#import "UserMsgViewCell.h"
#import "UserViewCell.h"
#import "UserLastViewCell.h"
#import "BFMapUserInfo.h"
#import "MJRefresh.h"

#import "UserDTViewController.h"
#import "BFChatViewController.h"
#import "BFChatHelper.h"
#import "UserMoreController.h"
#import "BFJubaoView.h"
@interface UserMainController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectShopOrChatDelegate,UIGestureRecognizerDelegate>{
    UITableView *userList;
}
@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSMutableArray *imgsArray;
@property (nonatomic,strong) NSDictionary *userDatadic;

@property (nonatomic,assign) NSInteger dongtaiHeight;
@property (nonatomic,assign) NSInteger signatureHeight;
@property (nonatomic,assign) NSInteger cellBottomHeight;
@property (nonatomic,strong) BFUserInfo *userinfo;

@property (nonatomic,strong) NSDictionary *dicData;

@property (nonatomic,strong) UIView *chatView;

@property (nonatomic,strong) UIView *strangerView;

@end

@implementation UserMainController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (UIView *)strangerView{
    if (!_strangerView) {
        _strangerView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_height - 45*ScreenRatio, Screen_width, 45 *ScreenRatio)];
        _strangerView.backgroundColor = BFColor(37, 38, 39, 1);
        

        for (int i = 0; i < 3 ; i ++ ) {
            NSString *imgname;
            if (i == 0) {
                imgname = @"conversasion_logo";
            }else if (i == 1){
                imgname = @"focus_logo";
            }else{
                imgname = @"blackuser";
            }
            
            UIImageView *chatimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgname]];
            chatimg.frame = CGRectMake(0, 0, 15*ScreenRatio, 15*ScreenRatio);
            chatimg.center = CGPointMake( 30*ScreenRatio+Screen_width/3*i, _strangerView.height/2);
            chatimg.contentMode = UIViewContentModeScaleAspectFit;
            [_strangerView addSubview:chatimg];
            
            UILabel *chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90*ScreenRatio, 20*ScreenRatio)];
            chatLabel.center = CGPointMake(CGRectGetMaxX(chatimg.frame)+chatLabel.width/2 + 10, _strangerView.height/2);
            NSString *name;
            if (i == 0) {
                name = @"聊聊";
            }else if (i == 1){
                name = @"关注";
            }else{
                name = @"拉黑举报";
            }
            chatLabel.text = name;
            chatLabel.textAlignment = NSTextAlignmentLeft;
            chatLabel.textColor = [UIColor whiteColor];
            chatLabel.font = [UIFont boldSystemFontOfSize:16];
            [_strangerView addSubview:chatLabel];
            
            UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            chatBtn.tag = 111 + i;
            chatBtn.backgroundColor = [UIColor clearColor];
            chatBtn.frame = CGRectMake(0 + Screen_width/3 * i, 0 , Screen_width/3, 45*ScreenRatio);
            [_strangerView addSubview:chatBtn];
            [chatBtn addTarget:self action:@selector(selectStarShop:) forControlEvents:UIControlEventTouchUpInside];
        }
        

    }
    return _strangerView;
}

- (UIView *)chatView{
    if (!_chatView) {
        _chatView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_height - 45*ScreenRatio, Screen_width, 45 *ScreenRatio)];
        _chatView.backgroundColor = [UIColor blackColor];
        UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chatBtn.tag = 111;
        chatBtn.backgroundColor = [UIColor clearColor];
        chatBtn.frame = _chatView.bounds;
        [_chatView addSubview:chatBtn];
        [chatBtn addTarget:self action:@selector(selectStarShop:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *chatimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chatyellow"]];
        chatimg.frame = CGRectMake(0, 0, 20*ScreenRatio, 17*ScreenRatio);
        chatimg.center = CGPointMake(Screen_width/2 - 18*ScreenRatio, _chatView.height/2);
        [_chatView addSubview:chatimg];
        
        UILabel *chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(chatimg.frame)+10, CGRectGetMinY(chatimg.frame), 40, 20)];
        chatLabel.text = @"对话";
        chatLabel.textAlignment = NSTextAlignmentCenter;
        chatLabel.textColor = [UIColor whiteColor];
        chatLabel.font = [UIFont boldSystemFontOfSize:15];
        [_chatView addSubview:chatLabel];
    }
    return _chatView;
}

- (void)achieveData{
    NSDictionary *parameters;
    NSString *jmid = self.isSelf ? JMUSERID : self.jmid;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (UserwordMsg && JMTOKEN && jmid) {
        parameters = @{@"tkname":UserwordMsg,@"tok":JMTOKEN,@"jmid":jmid};
    }
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/getlikefriends",ALI_BASEURL];
    [BFNetRequest postWithURLString:urlstr parameters:parameters success:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"s"] isEqualToString:@"t"]) {
            self.dicData = dic[@"data"];
            if (self.dicData) {
                NSArray *userArray = [self.dicData objectForKey:@"userinfo"];
                if (userArray.count > 0) {
                    NSDictionary *userDic = [userArray firstObject];
                    self.userDatadic = userDic;
                    self.userinfo = [BFUserInfo configureInfoWithdic:userDic];
                    if (!userList) {
                        [self buildUI];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [userList reloadData];

                        });
                    }
                }
            }
            
            
        }else{
            [self showAlertViewTitle:@"暂无数据,请稍后再试" message:nil];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",[error description]);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.titlestr) {
        self.title = self.titlestr;
    }
    self.titleArray = @[@"个性签名",@"个人信息",@"生活圈",@"兴趣爱好",@"喜欢的约会地点"];
    [self achieveData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveUsermsgSuccess) name:@"saveUsermsgSuccess" object:nil];

    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
}


- (void)saveUsermsgSuccess{
    
    [self dropViewDidBeginRefreshing];

}


- (void)buildUI{
    if (!self.titlestr) {
        self.title = self.userDatadic[@"nikename"];

    }
  
    userList = [[UITableView alloc] initWithFrame:CGRectMake(0 , NavBar_Height, Screen_width, Screen_height - NavBar_Height) style:UITableViewStylePlain];
    userList.delegate = self;
    userList.dataSource = self;
    userList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:userList];
    
    __weak UserMainController *weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf dropViewDidBeginRefreshing];
        [userList.mj_header beginRefreshing];
    }];
    // 设置普通状态的动画图片 (idleImages 是图片)
    UIImage *img1 = [UIImage imageNamed:@"runone"];
    UIImage *img2 = [UIImage imageNamed:@"runtwo"];
    UIImage *img3 = [UIImage imageNamed:@"runthree"];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    [header setImages:@[img1] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:@[img2] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:@[img1,img2,img3] forState:MJRefreshStateRefreshing];
    // 设置header
    userList.mj_header = header;
    
    NSString *isfocus = self.dicData[@"follow"];
    NSString *jmid = self.userDatadic[@"jmid"];
    if ([isfocus isEqualToString:@"1"]) {
        [self.view addSubview:self.chatView];
        self.rightStr = @"更多";

        userList.frame = CGRectMake(0 , 0, Screen_width, Screen_height - 45*ScreenRatio);
    }else if ([isfocus isEqualToString:@"0"] && [jmid isEqualToString:JMUSERID]){
        self.rightStr = @"编辑";

    }else if ([isfocus isEqualToString:@"0"]&& ![jmid isEqualToString:JMUSERID] ) {
        [self.view addSubview:self.strangerView];
        userList.frame = CGRectMake(0 , 0, Screen_width, Screen_height - 45*ScreenRatio);
        self.rightBar.hidden = YES;
    }
}

- (void)dropViewDidBeginRefreshing{
    
    [self achieveData];
    
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [userList reloadData];
        }
        
        if (isHeader) {
            [userList.mj_header endRefreshing];
        }
        else{
            [userList.mj_footer endRefreshing];
        }
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    if ([hidebtn[@"Gift"]isEqualToString:@"0"] || [UserwordMsg isEqualToString:@"123456jm"]){
        return 5;
    }else{
        return 7;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    if ([hidebtn[@"Gift"]isEqualToString:@"0"] || [UserwordMsg isEqualToString:@"123456jm"]){
        return section == 3 ? 5 : 1;
    }else{
        return section == 5 ? 5 : 1;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    if ([hidebtn[@"Gift"]isEqualToString:@"0"] || [UserwordMsg isEqualToString:@"123456jm"]){
        
        if (indexPath.section == 0) {
            UserHeaderViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"UserHeader"];
            if (!headerCell) {
                headerCell = [[UserHeaderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserHeader"];
            }
            NSString *likenum;
            if ([self.userDatadic[@"robot"] isEqualToString:@"1"]) {
                likenum = self.userDatadic[@"nums_likeme"];
            }else{
                likenum = self.dicData[@"like"];
            }
            headerCell.dic = @{@"otherbmp":self.userDatadic[@"otherbmp"],@"age":self.userDatadic[@"years"],@"time":self.userDatadic[@"lasttime"],@"zanNum":@"20",@"constellation":self.userDatadic[@"constellation"],@"emotionalstate":self.userDatadic[@"emotionalstate"],@"like":likenum,@"mybmp":self.userDatadic[@"mybmp"],@"sex":self.userDatadic[@"sex"]};
            
            return headerCell;
        }else if (indexPath.section == 1){
            DongtaiViewCell *dongtai = [tableView dequeueReusableCellWithIdentifier:@"DongTai"];
            if (!dongtai) {
                dongtai = [[DongtaiViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DongTai"];
            }
            dongtai.jmid = self.userDatadic[@"jmid"];
            dongtai.imgDic = self.dicData[@"blok"];
            self.dongtaiHeight = [dongtai getDongtaiHeight];
            return dongtai;
        }else if (indexPath.section == 2){
            FansCareViewCell *fanCell = [tableView dequeueReusableCellWithIdentifier:@"Fans"];
            if (!fanCell) {
                fanCell = [[FansCareViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Fans"];
            }
            
            NSString *fansnum;
            NSString *focusnum;
            if ([self.userDatadic[@"robot"] isEqualToString:@"1"]) {
                fansnum = [NSString stringWithFormat:@"%@",self.userDatadic[@"nums_fans"]];
                focusnum = [NSString stringWithFormat:@"%@",self.userDatadic[@"nums_focus"]];
            }else{
                fansnum = self.dicData[@"fans"];
                focusnum = self.dicData[@"follownum"];
            }
            if (self.dicData[@"follownum"] && self.dicData[@"fans"]) {
                fanCell.dic = @{@"focus":focusnum,@"fans":fansnum};
            }
            return fanCell;
        }else if (indexPath.section == 3){
            if (indexPath.row == 1) {
                // 个人信息
                UserViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"UserView"];
                if (!userCell) {
                    userCell = [[UserViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserView"];
                }
                userCell.titleLabel.text = self.titleArray[indexPath.row];
                // liveaddress
                userCell.dic = @{@"jmlocation":self.userDatadic[@"address"],@"industry":self.userDatadic[@"industry"],@"occupation":self.userDatadic[@"occupation"],@"school":self.userDatadic[@"school"]};
                
                return userCell;
            }else{
                UserMsgViewCell *UserMsgCell = [tableView dequeueReusableCellWithIdentifier:@"UserMsg"];
                if (!UserMsgCell) {
                    UserMsgCell = [[UserMsgViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserMsg"];
                }
                UserMsgCell.titleLabel.text = self.titleArray[indexPath.row];
                NSString *detaiStr;
                if (indexPath.row == 0) {
                    detaiStr = self.userDatadic[@"signature"];
                }else if (indexPath.row == 2){
                    detaiStr = self.userDatadic[@"liveaddress"];
                }else if (indexPath.row == 3){
                    detaiStr = self.userDatadic[@"interest"];
                }else{
                    detaiStr = self.userDatadic[@"ilikeaddress"];
                    
                }
                UserMsgCell.detailStr = detaiStr;
                self.signatureHeight = [UserMsgCell getMsgCellHeight];
                return UserMsgCell;
            }
        }else{
            UserLastViewCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:@"BottomCell"];
            if (!bottomCell) {
                bottomCell = [[UserLastViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BottomCell"];
                bottomCell.delegate = self;
            }
            NSString *jmid;
            if (self.userDatadic[@"jmid"]) {
                jmid = self.userDatadic[@"jmid"];
            }else{
                jmid = @"";
                
            }
            
            bottomCell.jmid = jmid;
            self.cellBottomHeight = [bottomCell getLastViewHeight];
            return bottomCell;
        }
        
    }else{
        
        if (indexPath.section == 0) {
            UserHeaderViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"UserHeader"];
            if (!headerCell) {
                headerCell = [[UserHeaderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserHeader"];
            }
            NSString *likenum;
            if ([self.userDatadic[@"robot"] isEqualToString:@"1"]) {
                likenum = self.userDatadic[@"nums_likeme"];
            }else{
                likenum = self.dicData[@"like"];
            }
            headerCell.dic = @{@"otherbmp":self.userDatadic[@"otherbmp"],@"age":self.userDatadic[@"years"],@"time":self.userDatadic[@"lasttime"],@"zanNum":@"20",@"constellation":self.userDatadic[@"constellation"],@"emotionalstate":self.userDatadic[@"emotionalstate"],@"like":likenum,@"mybmp":self.userDatadic[@"mybmp"],@"sex":self.userDatadic[@"sex"]};
            
            return headerCell;
        }else if (indexPath.section == 1){
            DongtaiViewCell *dongtai = [tableView dequeueReusableCellWithIdentifier:@"DongTai"];
            if (!dongtai) {
                dongtai = [[DongtaiViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DongTai"];
            }
            dongtai.imgDic = self.dicData[@"blok"];
            self.dongtaiHeight = [dongtai getDongtaiHeight];
            return dongtai;
        }else if (indexPath.section == 2){
            DengjiViewCell *grade = [tableView dequeueReusableCellWithIdentifier:@"Grade"];
            if (!grade) {
                grade = [[DengjiViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Grade"];
            }
            NSString *gradeData;
            NSString *vip;
            NSString *gradevalue;
            NSString *vipvalue;
            
            /*
             NSString *imgStr;
             if ([self.sellDic[@"grade"] isEqualToString:@""]) {
             imgStr = [NSString stringWithFormat:@"rank001-0"];
             }else{
             imgStr = [NSString stringWithFormat:@"rank001-%@",self.sellDic[@"grade"]];
             }
             */
            if (self.userDatadic[@"grade"]) {
                gradeData = [NSString stringWithFormat:@"%@",self.userDatadic[@"grade"]];
                ;
            }else{
                gradeData = [NSString stringWithFormat:@"0"];
            }
            if (self.userDatadic[@"vip"]) {
                vip = [NSString stringWithFormat:@"%@",self.userDatadic[@"vip"]];
                ;
            }else{
                vip = [NSString stringWithFormat:@"0"];
            }
            if (self.userDatadic[@"grade_value"]) {
                gradevalue = [NSString stringWithFormat:@"%@",self.userDatadic[@"grade_value"]];
                ;
            }else{
                gradevalue = [NSString stringWithFormat:@"0"];
            }
            if (self.userDatadic[@"grade_vip"]) {
                vipvalue = [NSString stringWithFormat:@"%@",self.userDatadic[@"grade_vip"]];
                ;
            }else{
                vipvalue = [NSString stringWithFormat:@"0"];
            }
            grade.dic = @{@"grade":gradeData,@"vip":vip,@"grade_value":gradevalue,@"grade_vip":vipvalue};
            return grade;
        }else if (indexPath.section == 3){
            FansCareViewCell *fanCell = [tableView dequeueReusableCellWithIdentifier:@"Fans"];
            if (!fanCell) {
                fanCell = [[FansCareViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Fans"];
            }
            
            NSString *fansnum;
            NSString *focusnum;
            if ([self.userDatadic[@"robot"] isEqualToString:@"1"]) {
                fansnum = [NSString stringWithFormat:@"%@",self.userDatadic[@"nums_fans"]];
                focusnum = [NSString stringWithFormat:@"%@",self.userDatadic[@"nums_focus"]];
            }else{
                fansnum = self.dicData[@"fans"];
                focusnum = self.dicData[@"follownum"];
            }
            if (self.dicData[@"follownum"] && self.dicData[@"fans"]) {
                fanCell.dic = @{@"focus":focusnum,@"fans":fansnum};
            }
            return fanCell;
        }else if (indexPath.section == 4){
            AccountViewCell *accountCell = [tableView dequeueReusableCellWithIdentifier:@"Account"];
            if (!accountCell) {
                accountCell = [[AccountViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Account"];
            }
            if (self.dicData[@"getmoney"] && self.dicData[@"sendmoney"]) {
                accountCell.dic = @{@"getmoney":self.dicData[@"getmoney"],@"sendmoney":self.dicData[@"sendmoney"]};
            }
            
            return accountCell;
        }else if (indexPath.section == 5){
            if (indexPath.row == 1) {
                // 个人信息
                UserViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"UserView"];
                if (!userCell) {
                    userCell = [[UserViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserView"];
                }
                userCell.titleLabel.text = self.titleArray[indexPath.row];
                // liveaddress
                userCell.dic = @{@"jmlocation":self.userDatadic[@"address"],@"industry":self.userDatadic[@"industry"],@"occupation":self.userDatadic[@"occupation"],@"school":self.userDatadic[@"school"]};
                
                return userCell;
            }else{
                UserMsgViewCell *UserMsgCell = [tableView dequeueReusableCellWithIdentifier:@"UserMsg"];
                if (!UserMsgCell) {
                    UserMsgCell = [[UserMsgViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserMsg"];
                }
                UserMsgCell.titleLabel.text = self.titleArray[indexPath.row];
                NSString *detaiStr;
                if (indexPath.row == 0) {
                    detaiStr = self.userDatadic[@"signature"];
                }else if (indexPath.row == 2){
                    detaiStr = self.userDatadic[@"liveaddress"];
                }else if (indexPath.row == 3){
                    detaiStr = self.userDatadic[@"interest"];
                }else{
                    detaiStr = self.userDatadic[@"ilikeaddress"];
                    
                }
                UserMsgCell.detailStr = detaiStr;
                self.signatureHeight = [UserMsgCell getMsgCellHeight];
                return UserMsgCell;
            }
        }else{
            UserLastViewCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:@"BottomCell"];
            if (!bottomCell) {
                bottomCell = [[UserLastViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BottomCell"];
                bottomCell.delegate = self;
            }
            NSString *jmid;
            if (self.userDatadic[@"jmid"]) {
                jmid = self.userDatadic[@"jmid"];
            }else{
                jmid = @"";
                
            }
            
            bottomCell.jmid = jmid;
            self.cellBottomHeight = [bottomCell getLastViewHeight];
            return bottomCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    if ([hidebtn[@"Gift"]isEqualToString:@"0"] || [UserwordMsg isEqualToString:@"123456jm"]){
        if (indexPath.section == 0) {
            return [UserHeaderViewCell getUserHeaderHeight];
        }else if (indexPath.section == 1){
            return self.dongtaiHeight;
        }else if (indexPath.section == 2){
            return 45 *ScreenRatio;;
        }else if (indexPath.section == 3){
            if (indexPath.row == 1) {
                return 150*ScreenRatio;
            }else{
                return self.signatureHeight;
            }
        }else{
            return self.cellBottomHeight;
        }
    }else{
        if (indexPath.section == 0) {
            return [UserHeaderViewCell getUserHeaderHeight];
        }else if (indexPath.section == 1){
            return self.dongtaiHeight;
        }else if (indexPath.section == 2){
            return [DengjiViewCell getGradeCellHeight];
        }else if (indexPath.section == 3){
            return 45 *ScreenRatio;
        }else if (indexPath.section == 4){
            return 60*ScreenRatio;
        }else if (indexPath.section == 5){
            if (indexPath.row == 1) {
                return 150*ScreenRatio;
            }else{
                return self.signatureHeight;
            }
        }else{
            return self.cellBottomHeight;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section == 6 ? 0 :10;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        // 跳转个人动态主界面
        UserDTViewController *vc = [[UserDTViewController alloc]init];
        vc.useruid = self.userDatadic[@"name"];
        NSLog(@"%@",self.userDatadic);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Delegate Method
- (void)saveUserMsg:(UIButton *)save{
    
    NSString *btnStr = save.titleLabel.text;
    if ([btnStr isEqualToString:@"更多"]) {
        UserMoreController *vc = [[UserMoreController alloc]init];
        vc.jmuid = self.jmid;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        UserSettingController *usersSet = [[UserSettingController alloc]init];
        if (self.userinfo) {
            usersSet.userItem = self.userinfo;
            [self.navigationController pushViewController:usersSet animated:YES];
        }else{
            
        }
    }
    
}


- (void)selectShopOrChat:(UIButton *)btn{
    switch (btn.tag) {
        case ButtonTypeShop:
            // 跳转星店
            [self showAlertViewTitle:@"跳转星店" message:nil];
            break;
        case ButtonTypeChat:
            // 跳转聊天
            [self showAlertViewTitle:@"跳转聊天" message:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - 会话和关注

- (void)selectStarShop:(UIButton *)btn{
    NSString *jmid = self.userDatadic[@"jmid"];
    if (btn.tag == 111) {
        
        NSString *nickname = self.userDatadic[@"nikename"];
        NSString *imgurl = self.userDatadic[@"mybmp"];
        BFChatViewController *chatController = [[BFChatViewController alloc]initWithConversationChatter:jmid conversationType:EMConversationTypeChat];
        chatController.title = nickname.length > 0 ? nickname : jmid;
        chatController.avatarURLPath = imgurl;
        chatController.nikename = nickname;
        chatController.jmid = jmid;
        chatController.hidesBottomBarWhenPushed = YES;
        NSDictionary *usermsg = @{@"jmid":jmid,@"nikename":nickname,@"userIcon":imgurl};
        //  会话缓存
        NSMutableArray *cacheschat = [BFChatHelper getDataArrayFromDB:@"ChatUserCaches"];
        NSLog(@"%@ ---- %@",usermsg,cacheschat);
        if (cacheschat) {
            [cacheschat addObject:usermsg];
            [BFChatHelper saveToLocalDB:cacheschat saveIdenti:@"ChatUserCaches"];

        }else{
            NSMutableArray *ar = [NSMutableArray array];
            [ar addObject:usermsg];
            [BFChatHelper saveToLocalDB:ar saveIdenti:@"ChatUserCaches"];
        }
        [self.navigationController pushViewController:chatController animated:YES];
    }else if(btn.tag == 111 + 1){
        // 关注
        NSString *urlstr = [NSString stringWithFormat:@"%@/updatefriend",ALI_BASEURL];
        NSDictionary *para;
        if (jmid.length > 0 && JMTOKEN && JMUSERID) {
            para = @{@"jmid":jmid,@"tok":JMTOKEN,@"tkname":UserwordMsg,@"follow":@1};
        }
        
        [BFNetRequest postWithURLString:urlstr parameters:para success:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic[@"s"] isEqualToString:@"t"]) {
                [_strangerView removeFromSuperview];
                _strangerView = nil;
                [self.view addSubview:self.chatView];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        //拉黑举报
        BFJubaoView *jbview = [[BFJubaoView alloc]init];
        [jbview show];
        jbview.block = ^(NSString *jbmesg){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"举报内容成功" message:jbmesg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //
                    //            [self resignView];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            });
        };
    }
    
}

@end
