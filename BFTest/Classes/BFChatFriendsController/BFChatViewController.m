//
//  BFChatViewController.m
//  BFTest
//
//  Created by 伯符 on 16/8/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFChatViewController.h"
#import "EaseEmoji.h"
#import "EaseEmotionManager.h"
#import "BFPhotoPickerController.h"
#import "BFUserInfoController.h"
//#import "UserProfileManager.h"

@interface BFChatViewController ()<UIAlertViewDelegate,EMClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;

@end

@implementation BFChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    if (self.nikename.length > 0) {
        self.title = self.nikename;
    }
    self.view.backgroundColor = BFColor(234, 234, 234, 1);
    self.tableView.backgroundColor = [UIColor clearColor];

}

- (void)dealloc{
    
    if (self.conversation.type == EMConversationTypeChatRoom)
    {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        }
        else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId deleteMessages:YES];
        }
    }
    
    [[EMClient sharedClient] removeDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([[ext objectForKey:@"subject"] length])
        {
            self.title = [ext objectForKey:@"subject"];
        }
        
        if (ext && ext[kHaveUnreadAtMessage] != nil)
        {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{

    NSString *jmid = messageModel.message.from;
    
    BFUserInfoController *vc = [BFUserInfoController creatByJmid:jmid];
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSLog(@"%@",messageModel.message.ext);
    
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak BFChatViewController* weakSelf = self;
            [self showHudInView:self.view hint:@"Fetching group members..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:chatGroup.groupId includeMembersList:YES error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong BFChatViewController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            if (![members count]) {
                                if (strongSelf.selectedCallback) {
                                    strongSelf.selectedCallback(nil);
                                }
                                return;
                            }
//                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
//                            selectController.mulChoice = NO;
//                            selectController.delegate = self;
//                            [self.navigationController pushViewController:selectController animated:YES];
                        }
                    }
                });
            });
        }
        else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                if (_selectedCallback) {
                    _selectedCallback(nil);
                }
                return;
            }
//            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
//            selectController.mulChoice = NO;
//            selectController.delegate = self;
//            [self.navigationController pushViewController:selectController animated:YES];
        }
    }
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
//    NSMutableArray *emotionGifs = [NSMutableArray array];
    NSMutableArray *emotionGifs2 = [NSMutableArray array];

    _emotionDic = [NSMutableDictionary dictionary];

    NSArray *names2 = @[@"dragon_cover1",@"dragon_cover2",@"dragon_cover3",@"dragon_cover4",@"dragon_cover5",@"dragon_cover6",@"dragon_cover7",@"dragon_cover8",@"dragon_cover9",@"dragon_cover10",@"dragon_cover11",@"dragon_cover12",@"dragon_cover13",@"dragon_cover14",@"dragon_cover15",@"dragon_cover16"];
    
    NSArray *titlenames = @[@"你好",@"拥抱",@"吃饭",@"带你飞",@"发射爱心",@"还不回我信息",@"看电影",@"可爱",@"哭",@"呵呵",@"亲亲",@"偷笑",@"问问",@"消消气",@"害羞",@"哈哈哈"];

//    int index = 0;
//    for (NSString *name in names) {
//        index++;
//        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover.png",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
//        [emotionGifs addObject:emotion];
//        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
//    }
    int index2 = 0;
    for (NSString *name in names2) {
        index2++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"%@",titlenames[index2 - 1]] emotionId:[NSString stringWithFormat:@"dragonem%d",(1000 + index2)] emotionThumbnail:[NSString stringWithFormat:@"dragon%d.png",index2] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs2 addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"dragonem%d",(1000 + index2)]];
    }

    EaseEmotionManager *managerGif2= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs2 tagImage:[UIImage imageNamed:@"dragon1"]];
    return @[managerDefault,managerGif2];
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    NSLog(@"%@",messageModel.message.ext);

    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message{
    id<IMessageModel> model = nil;
//    NSDictionary *ext = self.conversation.latestMessage.ext;
//    NSDictionary *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mydata"];
    NSString *icon = [BFUserLoginManager shardManager].photo;
    NSString *nickname = [BFUserLoginManager shardManager].name;
    NSString *jmid = [BFUserLoginManager shardManager].jmId;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        
        if (!icon || icon.length == 0) {
            icon = @"";
        }
        if (!nickname || nickname.length == 0) {
            nickname = @"";
        }
        if (!jmid || jmid.length == 0) {
            jmid = @"";
        }
        NSMutableDictionary *dic = [model.message.ext mutableCopy];

        [dic setObject:JMUSERID forKey:@"jmid"];
        [dic setObject:icon forKey:@"userIcon"];
        [dic setObject:nickname forKey:@"nikename"];

        model.message.ext = dic;
        
//        model.message.ext = @{@"jmid":JMUSERID,@"userIcon":icon,@"nikename":nickname};

    }else{
        NSLog(@"对方发送");
        //头像
        NSLog(@"%@",model.message.ext);
        model.avatarURLPath = model.message.ext[@"userIcon"];
        //NSLog(@"+++++++______+++%@",model.avatarURLPath);
        //昵称
        model.nickname = model.message.ext[@"nikename"];
        //头像占位图
        model.failImageName = @"jinmaiperson.jpg";
        
    }
    return model;
}

@end
