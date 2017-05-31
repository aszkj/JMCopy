//
//  BFTabbarController.m
//  BFTest
//
//  Created by 伯符 on 16/5/3.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFTabbarController.h"
#import "BFNavigationController.h"
#import "BFUsersListController.h"
#import "ApplyViewController.h"
#import "BFHXManager.h"
//#import "UserProfileManager.h"
#import "BFHXIMViewController.h"

//#import "BFChatHelper.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface BFTabbarController ()<BFTabbarDelegate,EMChatManagerDelegate>{
    UIButton *selectedBtn;
    NSInteger selectNum;
    BFHXIMViewController *mesgVC;
    NSMutableArray *mesgAchieve;

}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation BFTabbarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 必须在viewWillAppear 添加这一步，否则view 无点击响应
    [self.tabBar addSubview:self.tabbar];
    testData(@"tabbar控制器将要出现！")
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    testData(@"tabbar控制器已经出现！")
}

- (void)dealloc{
    
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    testData(@"viewDidLoad——start")
    testDate = [NSDate date];
    [super viewDidLoad];
    NSArray *childItemsArray = @[@{kClassKey  : @"BFHXIMViewController",
                                   kTitleKey  : @"近脉",
                                   kImageKey  : @"tab_0",
                                   kSelImgKey  : @"mesgselected"},
                                 @{kClassKey  : @"BFMapMainController",
                                   kTitleKey  : @"搜索",
                                   kImageKey  : @"centerselected",
                                   kSelImgKey  : @"tab_1"},
                                 @{kClassKey  : @"BFInterestController",
                                   kTitleKey  : @"用户",
                                   kImageKey  : @"tab_2",
                                   kSelImgKey  : @"circleselected"}];
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = nil;
        
        if([dic[kClassKey] isEqualToString:@"BFHXIMViewController"]){
            vc = [[UIStoryboard storyboardWithName:@"BFIMViewController" bundle:nil]instantiateInitialViewController];;
        }else{
            
            vc = [NSClassFromString(dic[kClassKey]) new];
        }
        
        if (idx == 0) {
            mesgVC = (BFHXIMViewController *)vc;
        }
        
        BFNavigationController *nav = [[BFNavigationController alloc]initWithRootViewController:vc];
        [self addChildViewController:nav];
    }];
    self.tabbar = [[BFTabbar alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Tabbar_Height) itemsArray:childItemsArray];
    self.tabbar.delegate = self;
    self.selectedIndex = 1;
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    mesgAchieve = [NSMutableArray array];
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadDTCount) name:@"setupUnreadDTCount" object:nil];

    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    [self unregisterNotifications];
    
    [BFHXDelegateManager shareDelegateManager].conversationListVC = mesgVC.conversationListVC;
    [BFHXDelegateManager shareDelegateManager].mainVC = mesgVC;
//    
//    [BFChatHelper shareHelper].conversationListVC = mesgVC;
//    [BFChatHelper shareHelper].mainVC = self;
    testData(@"viewDidLoad——end")

}

// 未读动态
- (void)setupUnreadDTCount{
    if (mesgVC) {
        
        [self.tabbar showDTIconNum];
    }
}

-(void)unregisterNotifications{
    
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}


// 统计未读消息数
-(void)setupUnreadMessageCount
{
    testData(@"setupUnreadMessageCount——start")
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (mesgVC) {
        
        [self.tabbar showMesgIconNum:unreadCount];
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
    testData(@"setupUnreadMessageCount——end")
}

- (void)setupUntreatedApplyCount
{
    testData(@"setupUntreatedApplyCount——start")
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (mesgVC) {
        [self.tabbar showMesgIconNum:unreadCount];
    }
    testData(@"setupUntreatedApplyCount——end")
}

//- (void)playSoundAndVibration{
//    NSTimeInterval timeInterval = [[NSDate date]
//                                   timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        //如果距离上次响铃和震动时间太短, 则跳过响铃
//        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//        return;
//    }
//    
//    //保存最后一次响铃时间
//    self.lastPlaySoundDate = [NSDate date];
//    
//    // 收到消息时，播放音频
//    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
//    // 收到消息时，震动
//    [[EMCDDeviceManager sharedInstance] playVibration];
//}


//- (void)showNotificationWithMessage:(EMMessage *)message
//{
//    EMPushOptions *options = [[EMClient sharedClient] pu  shOptions];
//    //发送本地推送
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [NSDate date]; //触发通知的时间
//    
//    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
//        EMMessageBody *messageBody = message.body;
//        NSString *messageStr = nil;
//        switch (messageBody.type) {
//            case EMMessageBodyTypeText:
//            {
//                messageStr = ((EMTextMessageBody *)messageBody).text;
//            }
//                break;
//            case EMMessageBodyTypeImage:
//            {
//                messageStr = NSLocalizedString(@"message.image", @"Image");
//            }
//                break;
//            case EMMessageBodyTypeLocation:
//            {
//                messageStr = NSLocalizedString(@"message.location", @"Location");
//            }
//                break;
//            case EMMessageBodyTypeVoice:
//            {
//                messageStr = NSLocalizedString(@"message.voice", @"Voice");
//            }
//                break;
//            case EMMessageBodyTypeVideo:{
//                messageStr = NSLocalizedString(@"message.video", @"Video");
//            }
//                break;
//            default:
//                break;
//        }
//        
//        do {
//            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
//            if (message.chatType == EMChatTypeGroupChat) {
//                NSDictionary *ext = message.ext;
//                if (ext && ext[kGroupMessageAtList]) {
//                    id target = ext[kGroupMessageAtList];
//                    if ([target isKindOfClass:[NSString class]]) {
//                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                    else if ([target isKindOfClass:[NSArray class]]) {
//                        NSArray *atTargets = (NSArray*)target;
//                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
//                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                }
//                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:message.conversationId]) {
//                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
//                        break;
//                    }
//                }
//            }
//            else if (message.chatType == EMChatTypeChatRoom)
//            {
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
//                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
//                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
//                if (chatroomName)
//                {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
//                }
//            }
//            
//            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
//        } while (0);
//    }
//    else{
//        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
//    }
//    
////#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
//    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
//    
//    notification.alertAction = NSLocalizedString(@"open", @"Open");
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//    } else {
//        notification.soundName = UILocalNotificationDefaultSoundName;
//        self.lastPlaySoundDate = [NSDate date];
//    }
//    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
//    [userInfo setObject:message.conversationId forKey:kConversationChatter];
//    notification.userInfo = userInfo;
//    
//    //发送通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    //    UIApplication *application = [UIApplication sharedApplication];
//    //    application.applicationIconBadgeNumber += 1;
//}

#pragma mark - BFTabbarDelegate

- (void)selectIndex:(NSInteger)integer{
    self.selectedIndex = integer;
}




@end
