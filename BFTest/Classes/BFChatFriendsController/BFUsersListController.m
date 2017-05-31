//
//  BFUsersListController.m
//  BFTest
//
//  Created by 伯符 on 16/8/16.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFUsersListController.h"
#import "EMSearchBar.h"
#import "BFSegmentedControl.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "EaseChineseToPinyin.h"
#import "AddFriendViewController.h"

#import "EMSearchDisplayController.h"
#import "EaseConversationCell.h"
#import "BFChatViewController.h"
//#import "EaseConversationModel.h"
#import "BFConversationModel.h"
#import "BFChatAddressBar.h"
#import "ApplyViewController.h"
#import "BFSearchResultController.h"
#import "BFUserProfileManager.h"
#import "EMAddressCell.h"
#import "BFUserFriend.h"
#import "BFChatHelper.h"
#import "BFChatNetRequest.h"
#import "FansOrFocusController.h"

#import "NSDictionary+MyDictionary.h"
#import "UserMainController.h"
@interface BFUsersListController ()<UISearchBarDelegate, UISearchDisplayDelegate,UIActionSheetDelegate,EaseUserCellDelegate,BFFriendBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>{
    NSIndexPath *_currentLongPressIndex;
    NSString *follow;
    NSString *fans;
}
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (nonatomic) NSInteger unapplyCount;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (nonatomic, strong) UISearchController *searchVC;

@property (nonatomic,strong) NSArray *daArray;

@property (nonatomic,strong) BFChatAddressBar *chatAddressbar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation BFUsersListController

- (NSMutableArray *)contactsSource{
    if (!_contactsSource) {
        _contactsSource = [NSMutableArray array];
    }
    return _contactsSource;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        [_searchBar sizeToFit];
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
    }
    
    return _searchBar;
}

- (BFChatAddressBar *)chatAddressbar{
    if (!_chatAddressbar) {
        _chatAddressbar = [[BFChatAddressBar alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, 40)];
        _chatAddressbar.delegate = self;
    }
    return _chatAddressbar;
}


- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];

        __weak BFUsersListController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
            EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.model = model;
            
//            cell.detailLabel.attributedText = [weakSelf conversationListViewController:weakSelf latestMessageTitleForConversationModel:model];
//            cell.timeLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [EaseConversationCell cellHeightWithModel:nil];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            EMConversation *conversation = model.conversation;

            BFChatViewController *chatController = [[BFChatViewController alloc]initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//            chatController.title = [conversation showName];
            [weakSelf.navigationController pushViewController:chatController animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
            [weakSelf.tableView reloadData];
              }];
            }
            
            return _searchController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self tableViewDidTriggerHeaderRefresh];
    if (self.selectedIndex == 1) {
        [self reloadApplyView];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    
    [self configureSearchVC];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, NavBar_Height, Screen_width, Screen_height - self.searchBar.frame.size.height);
    
    // 设置消息提示头
    [self configureTitleView];
    // 添加朋友
    [self configureFriendBarItem];
//    NSString *hxuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"HXUID"];
    [[UserProfileManager sharedInstance] loadUserProfileInBackgroundWithBuddy:self.contactsSource saveToLoacal:YES completion:^(BOOL success, NSError *error) {
        //
    }];
    
//    [[BFUserProfileManager shareInstance]loadUserProfileInBackgroundWithUserID:hxuid];
    
}

- (void)configureSearchVC{
    self.automaticallyAdjustsScrollViewInsets = NO;
    BFSearchResultController *vc = [[BFSearchResultController alloc]init];
    UINavigationController *searchResultsController = [[UINavigationController alloc]initWithRootViewController:vc];
    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchVC.searchBar.barTintColor = BFColor(238, 238, 238, 1);
    self.searchVC.searchBar.backgroundColor = BFColor(238, 238, 238, 1);
    self.searchVC.delegate = self;
    self.searchVC.searchResultsUpdater = self;
    self.searchVC.dimsBackgroundDuringPresentation = YES;
    self.searchVC.searchBar.backgroundColor = [UIColor lightGrayColor];
    self.tableView.tableHeaderView = self.searchVC.searchBar;
}


- (void)willPresentSearchController:(UISearchController *)searchController{
    searchController.view.backgroundColor = [UIColor whiteColor];
    searchController.view.userInteractionEnabled = YES;
    searchController.definesPresentationContext = YES;
}

- (void)didPresentSearchController:(UISearchController *)searchController{
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    
    [self.searchVC.searchBar resignFirstResponder];
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchString = [self.searchVC.searchBar text];

    [self filterBySubstring:searchString];
}

- (void)willDismissSearchController:(UISearchController *)searchController{
//    self.searchVC.searchBar.barTintColor = BFColor(238, 238, 238, 1);

}


- (void) filterBySubstring:(NSString*) subStr
{
    if (self.selectedIndex == 0) {

        // 定义搜索谓词
        NSPredicate* pred = [NSPredicate predicateWithFormat:
                             @"title CONTAINS[cd] %@",subStr];
        // 使用谓词过滤NSArray
        NSMutableArray *searchresults = [[self.dataArray filteredArrayUsingPredicate:pred] mutableCopy];
        
        UINavigationController *navController = (UINavigationController *)self.searchVC.searchResultsController;
        
        // Present SearchResultsTableViewController as the topViewController
        BFSearchResultController *vc = (BFSearchResultController *)navController.topViewController;
        // Update searchResults
        vc.searchResults = searchresults;
        // And reload the tableView with the new data
        [vc.tableView reloadData];
        
        /*
        [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:(NSString *)subStr collationStringSelector:@selector(title) resultBlock:^(NSArray *results) {
            if (results) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    UINavigationController *navController = (UINavigationController *)self.searchVC.searchResultsController;

                    // Present SearchResultsTableViewController as the topViewController
                    BFSearchResultController *vc = (BFSearchResultController *)navController.topViewController;
                    // Update searchResults
                    vc.searchResults = [results mutableCopy];
                    // And reload the tableView with the new data
                    [vc.tableView reloadData];
                });
            }
        }];
        */
    }
    
}



- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
}

#pragma mark - 设置添加朋友按钮  添加朋友
- (void)configureFriendBarItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 65*ScreenRatio, 16*ScreenRatio);
    [btn setContentEdgeInsets:UIEdgeInsetsMake(15*ScreenRatio, 10*ScreenRatio, 6, -20)];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = BFFontOfSize(14);
    [btn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)addFriend:(UIBarButtonItem *)btm{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - configureTitleView 消息提示头()
- (void)configureTitleView{
    
    BFSegmentedControl *segmentedControl = [[BFSegmentedControl alloc] initWithSectionTitles:@[@"聊天", @"通讯录"]];
    segmentedControl.backgroundColor = BFColor(33, 33, 33, 1);
    [segmentedControl setFrame:CGRectMake(0, 0, 150, 32)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTag:1];
    [self segmentedControlChangedValue:segmentedControl];
    self.navigationItem.titleView = segmentedControl;
}

#pragma mark -  选择聊天还是通讯录

- (void)segmentedControlChangedValue:(BFSegmentedControl *)segmentedControl {
    self.selectedIndex = segmentedControl.selectedIndex;
    if (self.tableView.backgroundView) {
        
        self.tableView.backgroundView = nil;
        
    }
    switch (segmentedControl.selectedIndex) {
        case 0:
            // 会话列表
            [self getConversationList];
            break;
        case 1:{
            // 通讯录

            NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromDB];
            NSDictionary *dic = [BFChatHelper getDataFromDB:@"address"];
            if (dic) {
                // 从本地缓存获取
                [self configureDataDic:dic buddy:buddyList];
                return ;
            }
            [self reloadDataSource];
        }
            
            break;
        default:
            break;
    }
}

- (void)getConversationList{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    [self.dataArray removeAllObjects];
    NSDictionary *dic = [BFChatHelper getDataFromDB:@"address"];
    NSMutableArray *dataArray = dic[@"data"];
    if (sorted.count > 0) {
        for (EMConversation *converstion in sorted) {
            //        EaseConversationModel *model = nil;
            BFConversationModel *model = nil;
            //        model = [self conversationmodelForConversation:converstion];
            model = [[BFConversationModel alloc]initWithConversation:converstion];
            
            if (dic) {
                for (NSDictionary *dic in dataArray) {
                    if ([dic[@"jmid"] isEqualToString:model.conversation.conversationId]) {
                        model.avatarURLPath = dic[@"mybmp"];
                    }else{
                        model.avatarImage = [UIImage imageNamed:@"appuserlogo.jpg"];
                        
                    }
                }
            }
            if (model) {
                [self.dataArray addObject:model];
            }else{
                EaseConversationModel *conmodel;
                conmodel = [self conversationmodelForConversation:converstion];
                [self.dataArray addObject:conmodel];
                
            }
        }
        if (self.tableView.backgroundView) {
            self.tableView.backgroundView = nil;
        }
        if (self.dataArray != 0) {
            [self.tableView reloadData];
        }
        
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }else{
        [self.tableView setBackgroundView:[self buidImage:@"hanomesg" title:@"您还没有聊天消息哦" up:YES]];
        [self.tableView reloadData];

    }
    

}

- (id<IConversationModel>)conversationmodelForConversation:(EMConversation *)conversation
{
    NSLog(@"%@",conversation.latestMessage.ext);
    NSDictionary *dic = conversation.latestMessage.ext;
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        
        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
        NSLog(@"%@",conversation.conversationId);
        if (profileEntity) {
            model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            model.avatarURLPath = dic[@"AVARTERIMG"];
        }
        if (dic) {
            model.avatarURLPath = dic[@"AVARTERIMG"];
            
        }
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSAttributedString *)conversationlatestMessageModel:(BFConversationModel *)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@", latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationModel:(BFConversationModel *)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    
    return latestMessageTime;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.selectedIndex == 0) {
        return 1;
    }
//    return [self.dataArray count] + 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.selectedIndex == 0) {
        return self.dataArray.count;
    }else{
        if (section == 0) {
            return 2;
        }
//        return [[self.dataArray objectAtIndex:(section - 1)] count];
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 0) {
        NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
        EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if ([self.dataArray count] <= indexPath.row) {
            return cell;
        }
//        id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
        id model = [self.dataArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[BFConversationModel class]]) {
            BFConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.model = model;
            
            NSMutableAttributedString *attributedText = [[self conversationlatestMessageModel:model] mutableCopy];
            [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
            cell.detailLabel.attributedText =  attributedText;
            cell.timeLabel.text = [self conversationModel:model];
        }else{
            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.conmodel = model;
        }
        
        return cell;
    }else{
        if (indexPath.section == 0) {
            
            NSString *CellIdentifier = @"EMAddressCell";
            EMAddressCell *cell = (EMAddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EMAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NSDictionary *dic = self.daArray[indexPath.row];
            cell.headImg.image = [UIImage imageNamed:dic[@"img"]];
            cell.guanzhu.text = dic[@"title"];
            return cell;
        }else{
            NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // Configure the cell...
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
//            NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
//            EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
//            EaseUserModel *model = [self.dataArray objectAtIndex:indexPath.row];
//            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy];
//            if (profileEntity) {
//                model.avatarURLPath = profileEntity.imageUrl;
//                model.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
//            }
//            cell.indexPath = indexPath;
//            cell.delegate = self;
//            cell.model = model;
            
            
            BFSearchFrid *frid = [self.dataArray objectAtIndex:indexPath.row];
//            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:frid.jmid];
//            if (profileEntity) {
//                frid.avatarURLPath = profileEntity.imageUrl;
//                frid.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
//            }
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.model = frid;
            return cell;
        }
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedIndex == 0) {
        EaseConversationCell *cell = (EaseConversationCell *)[tableView cellForRowAtIndexPath:indexPath];
        
//            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        BFConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [self didSelectConversationModel:model cellmodel:cell];

    }else{
        NSInteger section = indexPath.section;
        if (section == 0) {
            
            FansOrFocusController *fansvc = [[FansOrFocusController alloc]init];
            fansvc.titleStr = indexPath.row == 0 ? @"我的关注" : @"我的粉丝";
            [self.navigationController pushViewController:fansvc animated:YES];
            
        }else{
//            EaseUserModel *model = [self.dataArray objectAtIndex:indexPath.row];
            BFSearchFrid *frid = [self.dataArray objectAtIndex:indexPath.row];
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:frid.jmid]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            UserMainController *vc = [[UserMainController alloc]init];
            vc.titlestr = frid.nikename;
            vc.jmid = frid.jmid;
            vc.isSelf = NO;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}


- (void)didSelectConversationModel:(BFConversationModel *)conversationModel cellmodel:(id)cell
{
    
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            
//#ifdef REDPACKET_AVALABLE
//                RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
//#else
            BFChatViewController *chatController = [[BFChatViewController alloc]
//#endif
                                initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                                chatController.title = conversationModel.title;
            NSString *icon; NSString *nickename;
            if (conversationModel.avatarURLPath) {
                icon = conversationModel.avatarURLPath;

            }else{
                EaseConversationCell *ecell = (EaseConversationCell *)cell;
                
                icon = ecell.iconurl;
            }
            
            if (conversationModel.title) {
                nickename = conversationModel.title;
            }else{
                EaseConversationCell *ecell = (EaseConversationCell *)cell;
                
                nickename = ecell.titleLabel.text;
                
            }
            chatController.avatarURLPath = icon;

            chatController.nikename = nickename;
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
}


#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    return self.selectedIndex == 0 ? nil : self.sectionTitles;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 18;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 18)];
    view.backgroundColor = BFColor(242, 243, 244, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40*ScreenRatio, 18)];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.text = @"好友";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*ScreenRatio;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.selectedIndex == 0) {
        return YES;
    }else{
        return indexPath.section == 0 ? NO : YES ;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            BFConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId deleteMessages:YES];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            BFSearchFrid *frid = [self.dataArray objectAtIndex:indexPath.row];
//            NSString *str = @"http://101.201.101.125:8000/deletefriend";
            NSString *str = [NSString stringWithFormat:@"%@/deletefriend",ALI_BASEURL];

            NSDictionary *para = @{@"tkname":UserwordMsg,@"useridtwo":frid.name,@"tok":JMTOKEN,@"version":@"1"};
            [BFNetRequest postWithURLString:str parameters:para success:^(id responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic:%@",dic);
                if ([[dic objectForKey:@"s"]isEqualToString:@"t"]) {
                    EMError *error = [[EMClient sharedClient].contactManager deleteContact:frid.jmid];
                    if (!error) {
                        [[EMClient sharedClient].chatManager deleteConversation:frid.jmid deleteMessages:YES];
                        
                        [tableView beginUpdates];
                        [self.dataArray removeObjectAtIndex:indexPath.row];
                        [self.contactsSource removeObject:frid.jmid];
                        [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [tableView endUpdates];
                    }else{
                        [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.errorDescription]];
                        [tableView reloadData];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}



#pragma mark - private data

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackListFromDB];
//    for (NSString *buddy in buddyList) {
//        if (![blockList containsObject:buddy]) {
//            [contactsSource addObject:buddy];
//        }
//    }
    
    for (BFSearchFrid *frid in buddyList) {
        if (![blockList containsObject:frid.jmid]) {
            [contactsSource addObject:frid];
        }
    }
    //建立索引的核心, 返回27，是a－z和＃
//    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
//    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
//    
//    NSInteger highSection = [self.sectionTitles count];
//    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
//    for (int i = 0; i < highSection; i++) {
//        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
//        [sortedArray addObject:sectionArray];
//    }
    
    //按首字母分组
    for (BFSearchFrid *frid in contactsSource) {
//        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:frid.jmid];
//        UserProfileEntity *enqtity = [[UserProfileManager sharedInstance] getCurUserProfile];

//        if (model) {
//            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//            model.nickname = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy];
//            
//            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy]];
//            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
//            
//            NSMutableArray *array = [sortedArray objectAtIndex:section];
//            [array addObject:model];
//        }
//        [self.dataArray addObject:model];
        
        // 解决快速选择崩溃bug !!!
        if (self.selectedIndex == 1) {
            [self.dataArray addObject:frid];
        }
    }
    /*
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    if (self.selectedIndex == 1) {
        [self.dataArray addObjectsFromArray:sortedArray];
    }
     */
    [self.tableView reloadData];
}

#pragma mark - data


- (void)tableViewDidTriggerHeaderRefresh
{
    if (self.selectedIndex == 1) {
        
        //    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            NSMutableArray *buddyList = [[[EMClient sharedClient].contactManager getContactsFromServerWithError:&error]mutableCopy];
            if (!error) {
                [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself.contactsSource removeAllObjects];
                        
                        [self loadDataWithbuddy:buddyList];
                    });
                }
            }
            if (error) {
                NSLog(@"%@",[error errorDescription]);
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakself showHint:NSLocalizedString(@"loadDataFailed", @"Load data failed.")];
                    [weakself reloadDataSource];
                });
            }
            [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
        });
    }else{
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSArray* sorted = [conversations sortedArrayUsingComparator:
                           ^(EMConversation *obj1, EMConversation* obj2){
                               EMMessage *message1 = [obj1 latestMessage];
                               NSLog(@"%@",message1.ext);
                               EMMessage *message2 = [obj2 latestMessage];
                               if(message1.timestamp > message2.timestamp) {
                                   return(NSComparisonResult)NSOrderedAscending;
                               }else {
                                   return(NSComparisonResult)NSOrderedDescending;
                               }
                           }];
        if (sorted.count == 0) {
            [self.tableView setBackgroundView:[self buidImage:@"hanomesg" title:@"您还没有聊天消息哦" up:YES]];
        }else{
            self.tableView.backgroundView = nil;
        }
        [self.dataArray removeAllObjects];
        
        for (EMConversation *converstion in sorted) {
            BFConversationModel *model = nil;
//            model = [self conversationmodelForConversation:converstion];
            model = [[BFConversationModel alloc]initWithConversation:converstion];
            
            if (model) {
                [self.dataArray addObject:model];
            }else{
                EaseConversationModel *conmodel;
                conmodel = [self conversationmodelForConversation:converstion];
                [self.dataArray addObject:conmodel];

            }
        }
        [self.tableView reloadData];
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }
}


#pragma mark - public

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromDB];
    
    if (buddyList.count != 0) {
        
        [self loadDataWithbuddy:buddyList];
    }else{
//        [self.contactsSource removeAllObjects];
        [self tableViewDidTriggerHeaderRefresh];
        [self.tableView reloadData];
    }

}

- (void)loadDataWithbuddy:(NSArray *)buddyList{

    NSString *url = [NSString stringWithFormat:@"%@/getfriends?tkname=%@&tok=%@",ALI_BASEURL,UserwordMsg,JMTOKEN];
    
    [BFNetRequest postWithURLString:url parameters:nil success:^(id responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",accessDict);
        accessDict = [accessDict deleteAllNullValue];
        if (accessDict) {
            [BFChatHelper saveToLocalDB:accessDict saveIdenti:@"address"];
        }
        [self configureDataDic:accessDict buddy:buddyList];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)configureDataDic:(NSDictionary *)dic buddy:(NSArray *)buddyList{
    if (dic != nil) {
        NSMutableArray *dataArray = dic[@"data"];
        follow = dic[@"follow"];
        fans = dic[@"fans"];
        NSString *folstr = [NSString stringWithFormat:@"关注 %@",follow];
        NSString *fanstr = [NSString stringWithFormat:@"粉丝 %@",fans];
        self.daArray = @[@{@"img":@"guanzhu",@"title":folstr},@{@"img":@"fans",@"title":fanstr}];
        [self.contactsSource removeAllObjects];
        [self _sortDataArray:self.contactsSource];
        if (dataArray.count == 0 && buddyList.count != 0) {
            
            
            for (NSString *jmid in buddyList) {
                [[EMClient sharedClient].contactManager deleteContact:jmid];
            }
        }
        if (dataArray.count == 0 || buddyList.count == 0) {
            
            
            [self.tableView setBackgroundView:[self buidImage:@"hanofrid" title:@"您还没有好友哦" up:NO]];
            
        }
        
        for (int i = 0; i < dataArray.count; i ++) {
            NSDictionary *dic = dataArray[i];
            BFSearchFrid *frid = [BFSearchFrid configureModelWithDic:dic];
            [self.contactsSource addObject:frid];
            [self _sortDataArray:self.contactsSource];
            self.tableView.scrollEnabled = YES;
            [self.tableView setBackgroundView:nil];

        }
    }else{
        NSDictionary *dic = [BFChatHelper getDataFromDB:@"address"];
        if (dic) {
            // 从本地缓存获取
            [self configureDataDic:dic buddy:buddyList];
            return ;
        }
    }
}

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshAndSortView
{
    NSLog(@"%@",self.dataArray);
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[BFConversationModel class]]) {
            NSArray* sorted = [self.dataArray sortedArrayUsingComparator:
                               ^(BFConversationModel *obj1, BFConversationModel* obj2){
                                   EMMessage *message1 = [obj1.conversation latestMessage];
                                   EMMessage *message2 = [obj2.conversation latestMessage];
                                   NSLog(@"%@-----%@-",message1.from,message2.from);
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:sorted];
        }
    }
    [self.tableView reloadData];
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

- (void)dealloc{

}

@end
