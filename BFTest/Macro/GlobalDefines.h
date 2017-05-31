//
//  GlobalDefines.h
//  BFTest
//
//  Created by 伯符 on 16/5/4.
//  Copyright © 2016年 bofuco. All rights reserved.
//
// 开发: develop 1
// 生产: product 2
// 测试: test 3

/*---- 这里更改环境  -----*/
#define  Environment 1


#ifdef DEBUG
#define  MINZoomLevel  9
#define MAXZoomLevel  20.7
#define IsTestModel YES
#else
#define  MINZoomLevel  18
#define MAXZoomLevel  20.7
#define IsTestModel NO
#endif


#if (Environment == 1)

#define BDMERCHANT_ID   156946//开发
//#define DongTai_URL     @"http://activity-app-test.jinmailife.com"//动态 开发服务器
#define BUSINESS_URL    @"https://businessdev.jinmailife.com"//商家开发服务器
#define JMBASE_URL      @"http://user-app-dev.jinmailife.com" //APP开发服务器

#endif


#if (Environment == 2)

#define BDMERCHANT_ID   146667//生产
//#define DongTai_URL   @"http://activity.jinmailife.com"//动态 生产服务器
#define BUSINESS_URL  @"https://business.jinmailife.com"//商家生产服务器
#define JMBASE_URL    @"https://userapp.jinmailife.com" //APP生产服务期

#endif






#define DongTai_URL     @"http://news-dev.jinmailife.com"



#if (Environment == 3)
#define BDMERCHANT_ID   158619 //测试
//#define DongTai_URL     @"http://activity-app-test.jinmailife.com"//动态 测试服务器
#define BUSINESS_URL    @"https://business-test.jinmailife.com"//商家测试服务器
#define JMBASE_URL      @"http://user-app-test.jinmailife.com" //APP测试服务器
#endif


// 生产动态主界面接口
//#define DongTai_URL                 @"https://news.jinmailife.com"

#ifndef GlobalDefines_h
#define GlobalDefines_h

#define kAlipaySuccessCallback         @"kAlipaySuccessCallback"
#define kWeixinpaySuccessCallback      @"kWeixinpaySuccessCallback"
#define kGetTokenNotification          @"kGetTokenNotification"

#define kMapShowHeight   285*ScreenRatio

#define kbackBtntag     1000
#define kfinishBtntag   1001
#define kTabbarTag      9999
#define JMTOKEN  @""
#define JMUSERID  [BFUserLoginManager shardManager].jmId
#define UserMobile  [[NSUserDefaults standardUserDefaults]objectForKey:@"UserMobile"]
#define XGTOKEN     [[NSUserDefaults standardUserDefaults]objectForKey:@"XGTOKEN"]


#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

#define kUserword   @"kUserword"
#define kPassword   @"kPassword"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImageKey   @"imageName"
#define kSelImgKey  @"selectedImgName"

#define kAnnoView_Width    26.6*ScreenRatio
#define kAnnoView_Height   44.7*ScreenRatio
#define kResolution         ([UIScreen mainScreen].bounds.size.width == 414 ? 3:2)

#define kMapPopViewHeight  Screen_width - 80*ScreenRatio

#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"

#define BAIDUMAP_ACCESSKEY  @"bxGjcm1WoQOf3FEM2VwvIfNuTAcuT4Bm"

#define REDPACKET_AVALABLE

#define PRESENCEORHIDE      @"PRESENCEORHIDE"

#ifdef DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil

#endif

#define SAFE_SEND_MESSAGE(obj, msg) if ((obj) && [(obj) respondsToSelector:@selector(msg)])


//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


// 微信第三方登录信息
#define WX_ACCESS_TOKEN        @"access_token"
#define WX_OPEN_ID             @"openid"
#define WX_REFRESH_TOKEN       @"refresh_token"
#define WX_BASE_URL            @"https://api.weixin.qq.com/sns"
#define WXPatient_App_ID       @"wx54b9c67e56eb8e07"
#define WXPatient_App_Secret   @"d3e1a5d692bee726564178b4db7f0698"
// 微博第三方登录信息
#define WBAppKey               @"2868296421"
#define WBRedirectURI          @"https://api.weibo.com/oauth2/default.html"
#define WB_TOKEN_KEY           @"wb_access_token"
#define WB_OPENID_KEY          @"wb_openid"

#define GetUserMesg(a)            [[NSUserDefaults standardUserDefaults]objectForKey:a]

#define ChatInputBarHeight      70 * ScreenRatio
#define Screen_width            [UIScreen mainScreen].bounds.size.width
#define Screen_height           [UIScreen mainScreen].bounds.size.height
#define ScreenRatio             Screen_width/320
#define NavigationBar_Height    self.navigationController.navigationBar.height
#define NavBar_Height           64
#define Tabbar_Height           49
#define KeyboardDuration        0.25
#define UserCellMargin          12


///屏幕尺寸
#define kScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight         ([UIScreen mainScreen].bounds.size.height)

#define RandomNum8  [NSString stringWithFormat:@"%.8d", arc4random() % 100000000]

#define BFThemeColor BFColor(251, 213, 0, 1)
#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]
#define BFColor(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define BFRandomColor [UIColor colorWithRed:(arc4random_uniform(255) / 255.0) green:(arc4random_uniform(255)/255.0) blue:(arc4random_uniform(255)/255.0) alpha:1]

#define BFIcomImg  [UIImage imageNamed:@"jinmaiperson.jpg"]

#define Img(a) [UIImage imageNamed:@"a"]


#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]

#define AddressPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"Address"]
#define PasswordPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"PassWord"]

//#define UserwordMsg  [SSKeychain passwordForService:@"JinMaiApp" account:kUserword]
//#define PasswordMsg  [SSKeychain passwordForService:@"JinMaiApp" account:kPassword]
//#define AvarterImg   [[NSUserDefaults standardUserDefaults]objectForKey:@"UserIcon"]

//#define UserwordMsg   (NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:kUserword]
#define UserwordMsg     [BFUserLoginManager shardManager].jmId

#define PasswordMsg    (NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:kPassword]


#define BFFontOfSize(x) [UIFont systemFontOfSize:x]
#define kCommonHighLightRedColor [UIColor colorWithRed:1.00f green:0.49f blue:0.65f alpha:1.00f]
#define kCommonBlackColor [UIColor colorWithRed:0.17f green:0.23f blue:0.28f alpha:1.00f]

#define Global_mainBackgroundColor BFColor(248, 248, 248, 1)

#define WEAK_SELF __weak typeof(self) weakSelf = self

#define STRONG_SELF if (!weakSelf) return; \
__strong typeof(weakSelf) strongSelf = weakSelf


//录音需要的最短时间
#define MIN_RECORD_TIME_REQUIRED 1
//录音允许的最长时间
#define MAX_RECORD_TIME_ALLOWED 60

#import "Masonry.h"

//#import "AFHTTPRequestOperation.h"
#import "UIViewController+BFViewController.h"
#import "AFHTTPSessionManager.h"
#import "BFNetRequest.h"
#import "MBProgressHUD.h"

#import "BFChatUtilities.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+MD5.h"
#import "EMClient.h"
#import "EaseUI.h"
#import "BFHXManager.h"

#endif /* GlobalDefines_h */

// 本地测试
//#define ALI_BASEURL             @"http://192.168.1.198:8000"
//  阿里云
//#define ALI_BASEURL              @"https://101.201.101.125:8000"

// 开发服务器
// #define ALI_BASEURL              @"http://101.201.39.205:8000"

// 测试服务器
//#define ALI_BASEURL              @"http://101.201.101.65:8000"

// BD服务器
//#define ALI_BASEURL              @"http://123.57.219.141:8000"

// 上线服务器

#define ALI_BASEURL              @"https://userapi.jinmailife.com"




// 心跳包接口
#define HEART_BASEURL               ALI_BASEURL@"/getmsgComet"
// 第三方登录接口
#define BFLOGIN_BASEURL             ALI_BASEURL@"/register3"
// 检查用户状态
#define USERID_STATUS               ALI_BASEURL@"/checkuserphoneinfo"
// 登录本地服务器
#define BFLOGIN_LOGINURL            ALI_BASEURL@"/login"
// 获取验证码
#define GETVERTITIEDCODE            ALI_BASEURL@"/sendmysmskey"
// 通讯录接口
#define BFADDRESS_URL               ALI_BASEURL@"/getfriendByuseridoneHandler"


/*** 更改后Java接口  ***/

//服务器地址
//#define JMBASE_URL      @"https://10.2.193.85:8443"
//  #define JMBASE_URL      @"http://10.2.193.85:9000"









/***   用户登录相关接口   ***/

//登录接口
#define JMLOGIN_URL             JMBASE_URL@"/login/login"
//发送验证码
#define JMSENDCODE_URL          JMBASE_URL@"/validCode/send"
//新用户接口
#define JMNEWUSER_URL           JMBASE_URL@"/login/newUser"
//绑定手机
#define JMBINDPHONE_URL        JMBASE_URL@"/login/bind"
//完善资料接口
#define JMFINISNINFO_URL        JMBASE_URL@"/login/finisnInfo"
//添加授信设备接口
#define JMVALIDDEVICE_URL        JMBASE_URL@"/login/validDevice"
//获得七牛token的接口
#define JMGETUPLOAD_URL         JMBASE_URL@"/certificate/getUpload"


/*** 偏好设置中对应的用户信息 ***/

//偏好设置中用户信息存储对应的KEY
#define USER_INFO_KEY @"userInfo"
//偏好设置中用户信息对应的字典
#define USER_INFO_DICT  [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_KEY]


//偏好设置中用户信息数据源存储对应的KEY
#define USER_INFODATA_KEY @"userInfoEditData"
//偏好设置中用户信息数据源对应的字典
#define USER_INFODATA_DICT [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFODATA_KEY]




/***   用户信息相关接口   ***/

//获得用户信息的接口
#define JM_USER_GETUSERINFO           JMBASE_URL@"/user/getUserInfo"
//更新用户信息接口
#define JM_USER_UPDATEUSERINFO          JMBASE_URL@"/user/updateUserInfo"
//模糊查询接口
#define JM_USER_SEARCHUSERBYJMID        JMBASE_URL@"/user/searchUserByJmid"




/***   用户之间设置关系相关的接口   ***/

//获得用户之间关系的接口
#define JM_USER_GETUSERRELATIONS        JMBASE_URL@"/userRelations/getUserRelations"
//更新备注名
#define JM_USER_SETREMARKNAME          JMBASE_URL@"/userRelations/setRemarkName"

//获取用户原name 和备注名
#define JM_USER_GETNICKNAME          JMBASE_URL@"/userRelations/getNickName"


//获得粉丝列表
#define JM_USER_GETFANS          JMBASE_URL@"/userRelations/getFans"
//删除粉丝
#define JM_USER_DELFANS          JMBASE_URL@"/userRelations/delFans"

//获得关注列表
#define JM_USER_GETFOLLOWS         JMBASE_URL@"/userRelations/getFollows"
//添加关注
#define JM_USER_ADDFOLLOW         JMBASE_URL@"/userRelations/addFollow"
//取消关注
#define JM_USER_DELFOLLOW         JMBASE_URL@"/userRelations/delFollow"

//获取黑名单
#define JM_USER_GETBLACKLIST         JMBASE_URL@"/userRelations/getBlackList"
//移出黑名单
#define JM_USER_ADDBLACKLIAT         JMBASE_URL@"/userRelations/addBlackList"
//添加到黑名单
#define JM_USER_DELBLACKLIST         JMBASE_URL@"/userRelations/delBlackList"
//清空黑名单
#define JM_USER_CLEARBLACKLIST         JMBASE_URL@"/userRelations/clearBlackList"

//获取好友列表
#define JM_USER_GETFRIEND         JMBASE_URL@"/friend/getFriend"


//向陌生人打招呼
#define JM_USER_SAYHI         JMBASE_URL@"/userRelations/sayHi"

//添加喜欢
#define JM_USER_ADDLIKED         JMBASE_URL@"/userRelations/addLiked"
//取消喜欢
#define JM_USER_DELLIKED         JMBASE_URL@"/userRelations/delLiked"


//举报用户
#define JM_USER_COMPLAIN            JMBASE_URL@"/complain/complain"

// 请求地图附近商家或者用户
#define JM_MAP_NEARBY               JMBASE_URL@"/map/get"
// 记录GPS
#define JM_MAP_ADDGPS               JMBASE_URL@"/gps/add"
// 波一波
#define JM_MAP_SEARCHUSER               JMBASE_URL@"/map/bo"
// 波波喜欢某人
#define JM_MAP_BOLIKE                JMBASE_URL@"/userRelations/addLiked"
// 波波不喜欢某人
#define JM_MAP_BODISLIKE               JMBASE_URL@"/userRelations/delLiked"

 #define JM_SETSHAREWX        JMBASE_URL@"/download/index.html"

//定义一个检查运行时间的宏
#define TimeStar   NSDate *date = [NSDate date];

#define TimeEnd(t)  NSLog(@"耗时%zd————————————————————————————————————————————————————————time -> %f",t,[[NSDate date] timeIntervalSinceDate:date]);












/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the magical animal protecting
 *　　　　　　　　　┃　　　┃ +
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 ------------>    保佑没bug!!   <--------
 */
