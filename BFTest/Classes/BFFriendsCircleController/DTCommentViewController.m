//
//  DTCommentViewController.m
//  BFTest
//
//  Created by 伯符 on 17/2/28.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "DTCommentViewController.h"
#import "BFSliderCell.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "BFInterestModel.h"
#import "NSString+MD5.h"
#import "CommentFrame.h"
@interface DTCommentViewController ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource,UITableViewDelegate,UITableViewDataSource,RelyUserDelegate>{
    BFCommentModel *selectModel;
    NSString *selectStr;
}

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSDictionary *dicdata;

@property (nonatomic,strong) NSMutableArray *commentArray;

@property (nonatomic,strong) NSMutableArray *commentFrameArray;

@end

@implementation DTCommentViewController

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

-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        
    }
    return _chatKeyBoard;
}

- (void)chatKeyBoardSendText:(NSString *)text{
    if (text && text.length > 0) {
        /*
        NSDictionary *dic = @{@"nikename":};
        BFCommentModel *model = [BFCommentModel configureModelWithDic:commentDic];
        [self.dataArray addObject:model];
        [self.tableView reloadData];
        */
        
        NSString *str = [NSString stringWithFormat:@"%@/news/%@/comment/",DongTai_URL,self.nid];
        NSDictionary *para;
        NSString *replyuser;
        NSString *replyname;

        if ([selectStr isEqualToString:@"评论"]) {
            replyuser = @"";
            replyname = @"";
        }else if ([selectStr isEqualToString:@"回复"]){
            replyuser = selectModel.comment_user;
            replyname = selectModel.nikename;
        }
        NSLog(@"%@ ===== %@",selectModel.reply_user,selectModel.reply_user_nikename);
        NSLog(@"%@ ---- %@ ---- %@ ----- %@",UserwordMsg,JMTOKEN,selectStr,replyuser);

        if (UserwordMsg && JMTOKEN) {
            para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"reply_user":replyuser,@"message":text};
        }
        [BFNetRequest postWithURLString:str parameters:para success:^(id responseObject) {
            NSDictionary *dicdata = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSString *nickename ;
            NSString *headimg   ;
            if (self.userDic[@"nikename"]) {
                nickename = self.userDic[@"nikename"];
            }else{
                nickename = @"";

            }
            if (self.userDic[@"head_image"]) {
                headimg = self.userDic[@"head_image"];
            }else{
                headimg = @"";
                
            }
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
            NSString *intervalStr = [NSString stringWithFormat:@"%f",interval];
            NSDictionary *dic;
            dic = @{@"nikename":nickename,@"head_image":headimg,@"message":text,@"publish_datetime":intervalStr,@"comment_user":UserwordMsg,@"reply_user":replyuser,@"reply_user_nikename":replyname};
            BFInterestModel *inmodel = self.modelFrame.interestModel;

            BFCommentModel *model = [BFCommentModel configureModelWithDic:dic];
            [self.dataArray addObject:model];
            [self.tableView reloadData];
            [inmodel.comments addObject:dic];
            
            inmodel.comments_num ++;
            
            self.modelFrame.interestModel = inmodel;

            if (_ReplyBlock) {
                _ReplyBlock(self.modelFrame);
            }
            
            if (dicdata[@"success"]) {
                
                
            }
        } failure:^(NSError *error) {
            //
        }];

    }else{
        [self showAlertViewTitle:@"评论不能为空" message:nil];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    selectStr = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"register_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 49*ScreenRatio) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.chatKeyBoard];
    [self.view bringSubviewToFront:self.chatKeyBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    //注册键盘隐藏NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
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
        cell.delegate = self;

        cell.timeLabel.hidden = NO;
    }
    BFCommentModel *comment = self.dataArray[indexPath.row];

    cell.commentModel = comment;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BFCommentModel *model = self.dataArray[indexPath.row];
    CGFloat height = [model.message getHeightWithWidth:Screen_width - 65*ScreenRatio font:14];
    return height + 40*ScreenRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    BFCommentModel *comment = self.dataArray[indexPath.row];
//    selectModel = comment;
//    BFSearchCell *cell = (BFSearchCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.chatKeyBoard.placeHolder = @"评论";
    selectStr = @"评论";
    [self.chatKeyBoard keyboardUpforComment];
    
}

- (void)replytoUser:(BFSearchCell *)cell{
    
    selectModel = cell.commentModel;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",cell.titleLabel.text];
    selectStr = @"回复";
    [self.chatKeyBoard keyboardUpforComment];

}

- (void)achieveData{
    NSString *str = [NSString stringWithFormat:@"%@/news/%@/comment/",DongTai_URL,self.nid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN};
    }
    
    [BFNetRequest getWithURLString:str parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dic);
        NSArray *content = dic[@"content"];
        if (content.count != 0) {
            for (NSDictionary *dicd in content) {
                BFCommentModel *model = [BFCommentModel configureModelWithDic:dicd];
                CGFloat height = [CommentFrame returnHeightWith:dicd];
                [self.commentFrameArray addObject:[NSNumber numberWithFloat:height]];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];
}

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"xiaolian" high:@"face_H" select:@"keyboard"];
    
    //    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    //
    //    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    //
    //    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    return @[item1];
    
    //    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

#pragma mark
#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"%@",userInfo);
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger anitime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] intValue];
    
    //    [UIView animateWithDuration:anitime animations:^{
    //
    //        self.chatToolBar.transform = CGAffineTransformMakeTranslation(0, - keyboardFrame.size.height);
    //
    //    }];
    //    [self.chatKeyBoard keyboardUpforComment];
    
}

#pragma mark
#pragma mark keyboardWillHide
- (void)keyboardWillHide:(NSNotification *)notification {
    //    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSTimeInterval animationDuration;
    //    [animationDurationValue getValue:&animationDuration];
    //    [UIView animateWithDuration:animationDuration animations:^{
    //    }];
    //    self.needUpdateOffset = NO;
    [self.chatKeyBoard keyboardDownForComment];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.chatKeyBoard keyboardDownForComment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"CommentViewController didReceiveMemoryWarning");
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.chatKeyBoard keyboardDownForComment];
}



@end
