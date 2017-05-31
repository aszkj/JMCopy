//
//  AppDelegate.m
//  BFTest
//
//  Created by 伯符 on 16/5/3.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "AppDelegate.h"
#import "BFWelcomController.h"
#import "BFNavigationController.h"
#import "JinMaimMainController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XGPush.h"
#import "XGSetting.h"
#import "EMSDK.h"
#import "BFRegisterController.h"
#import "AppDelegate+Register.h"
#import "BFHXManager.h"



#import "AvoidCrash.h"
#import "AppointmentView.h"
#import "AppointmentAlert.h"
#import <sys/utsname.h>
#import "EditUserMesgController.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <UserNotifications/UserNotifications.h>
@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif

@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate,EMChatManagerDelegate>

@end

#define EaseMobAppKey @"jinmaikeji#bfjinmai"


@implementation AppDelegate


/**
 当程序载入后执行
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //设置现有功能
    [self setupCurrentFunction];

    
    //防崩溃设置
    [self setupAvoidCrash];
    
    //注册环信
    [BFHXManager setupEMClientApplication:application
            didFinishLaunchingWithOptions:launchOptions
                                   appkey:@"jinmaikeji#jmchat"
                             apnsCertName:@"Develop_Cer"
                              otherConfig:nil];
    //注册远程推送
     [self registerAPNS];
    
    //注册信鸽推送
    [self registerXGPushWithOptions:launchOptions];
    
    //设置第三方登录
    [self setupThirdLogin];
    
    //设置缓存策略
    [self setupNSURLCache];
    
    //初始化百度地图显示样式
    
    //个性化地图模板文件路径
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config" ofType:@""];
    
    //设置个性化地图样式
    
    [BMKMapView customMapStyle:path];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    //设置百度地图 授权用户定位
    [self setupMapManager];
    
    //设置系统的根window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self setRootViewControllerForWindow];
    
    [self.window makeKeyAndVisible];
    
    
       return YES;
}

- (void)setupCurrentFunction{
    
    NSDictionary *hidebtn = @{
                              @"Gift":@"0",
                              @"MBCenter":@"0"
                              };
    [[NSUserDefaults standardUserDefaults] setObject:hidebtn forKey:@"HideBtn"];
}

/**
 第三方SDK回调接口
  */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self] ;
    
}

/**
 第三方应用启动本应用
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kAlipaySuccessCallback object:nil userInfo:resultDic];
        }];
        return YES;
        
    }else if ([url.host isEqualToString:@"pay"] && [url.scheme containsString:@"wx"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url]|| [WeiboSDK handleOpenURL:url delegate:self] ;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:kAlipaySuccessCallback object:nil userInfo:resultDic];
            
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            NSString *resultStr = [resultDic objectForKey:@"result"];
            if ([resultStr containsString:@"success=true"]) {
                NSString *secStr = [[resultStr componentsSeparatedByString:@"out_trade_no="]lastObject];
                NSString *outtrade = [[secStr componentsSeparatedByString:@"&"]firstObject];
                NSString *url = [NSString stringWithFormat:@"http://shop.jinmailife.com/restaurant/menu/7/pay/success/RST-%@/",outtrade];
                
            }
            
        }];
    }
    //    return YES;
    
    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self] ;
}


#pragma mark - 初始化AvoidCrash

- (void)setupAvoidCrash{
    [AvoidCrash becomeEffective];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}


#pragma mark - 注册信鸽推送
- (void)registerXGPushWithOptions:(NSDictionary *)launchOptions{
    // 注册信鸽推送
    [XGPush startApp:2200247880 appKey:@"I5VT7FTS915R"];
   
    [XGPush handleLaunching:launchOptions successCallback:^{
        NSLog(@"[XGDemo] Handle launching success");
    } errorCallback:^{
        NSLog(@"[XGDemo] Handle launching error");
    }];
    
}

#pragma mark - 判断当前的登录入口
- (void)setRootViewControllerForWindow{
    // 当前app版本
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    // 前一次版本
    NSString *lastVerison = [[NSUserDefaults standardUserDefaults]objectForKey:@"versionNum"];
 
    
    // 判断是否第一次开启app
    if (lastVerison == nil || lastVerison != currentVersion) {
        // 第一次开启app,设置引导页
        BFWelcomController *welcomeController = [[BFWelcomController alloc]init];
        self.window.rootViewController = welcomeController;

        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"versionNum"];
        
    }else if(USER_INFO_DICT != nil){
        // 已经登陆后进入APP  默认设置自动登录
        [self loginByLocalUserInfo];
    }else{
        // 未登录或注册或没有编辑个人资料进入APP的情况
        JinMaimMainController *main = [[JinMaimMainController alloc]init];
        BFNavigationController *nv = [[BFNavigationController alloc]initWithRootViewController:main];
        self.window.rootViewController = nv;
    }
}

#pragma mark - 设置第三方登录
- (void)setupThirdLogin{
    // 微信第三方登录  -- 注册appID
    [WXApi registerApp:@"wx54b9c67e56eb8e07"];
    
    // 微博第三方登录  -- 注册appKey
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WBAppKey];
}

#pragma mark - 设置缓存策略（get）

- (void)setupNSURLCache{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

#pragma mark - 初始化百度地图 授权定位
- (void)setupMapManager{
    BOOL ret = [_mapManager start:BAIDUMAP_ACCESSKEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
}


- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    } else {
        // before iOS 8
        [self registerPushBefore8];
    }
#else
    if (sysVer < 8) {
        // before iOS 8
        [self registerPushBefore8];
    } else {
        // iOS 8-9
        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerPushBefore8{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


- (void)loginByLocalUserInfo{
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    [manager saveUserInfo];
    BFTabbarController *tabbarController = [[BFTabbarController alloc]init];
    self.window.rootViewController = tabbarController;
}

#pragma mark - 微信登录回调
- (void)onResp:(BaseResp *)resp{
    
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXPatient_App_ID, WXPatient_App_Secret, temp.code];
        [BFNetRequest getaWithURLString:accessUrlStr parameters:nil success:^(id responseObject) {
            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",accessDict);
            NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
            NSString *uid = [accessDict objectForKey:WX_OPEN_ID];
            NSString *openID = [uid stringByAppendingString:@"wx"];
            // 本地持久化，以便access_token的使用、刷新或者持续
            if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                [BFUserLoginManager shardManager].wx_accessToken = accessToken;
#warning 这里截取到微信的授权号 切换原来接口
                [self receiveToken:openID from:JM_TokenTypeWX];
            }
        } failure:^(NSError *error) {
            NSLog(@"获取access_token时出错 = %@", error);
            
        }];
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *str = [NSString stringWithFormat:@"%d",resp.errCode];
        [[NSNotificationCenter defaultCenter]postNotificationName:kWeixinpaySuccessCallback object:nil userInfo:@{@"result":str}];
        
    }
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NSLog(@"didReceiveWeiboRequest");
}

#pragma mark - 微博登录回调

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class]){
        NSLog(@"%@",response.userInfo);
        NSString *uid = [response.userInfo objectForKey:@"uid"];
        NSString *userID = [uid stringByAppendingString:@"wb"];
        NSLog(@"%@",userID);
        NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        manager.wb_accessToken = accessToken;
        [self receiveToken:uid from:JM_TokenTypeWB];
        
        return;
    }
}
#warning 一下是原微博登录代码
        

- (void)changeRootVCwithuserword:(NSString *)userword password:(NSString *)pass userstr:(NSString *)hasuserMsg mobile:(NSString *)mobilestr{
    if ([hasuserMsg isEqualToString:@"false"]) {
        BFTabbarController *tabbarController = [[BFTabbarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
        [[NSUserDefaults standardUserDefaults]setObject:userword forKey:kUserword];
        [[NSUserDefaults standardUserDefaults]setObject:pass forKey:kPassword];
        [[NSUserDefaults standardUserDefaults]setObject:mobilestr forKey:@"UserMobile"];
        
    }else{
        
        EditUserMesgController *vc = [[EditUserMesgController alloc]init];
        vc.userword = userword;
        vc.pass = pass;
        vc.mobile = mobilestr;
        BFNavigationController *rootVC = (BFNavigationController *)self.window.rootViewController;
        [rootVC pushViewController:vc animated:YES];
        //        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //注册设备
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken
                                              account:@"123456"
                                      successCallback:^{
                                          NSLog(@"[XGPush Demo] register push success");
                                      } errorCallback:^{
                                          NSLog(@"[XGPush Demo] register push error");
                                      }];
    
    [BFUserLoginManager shardManager].APNSToken = deviceToken;
    
   
    
    if (deviceTokenStr.length > 0) {
        [[NSUserDefaults standardUserDefaults]setObject:deviceTokenStr forKey:@"XGTOKEN"];
        
    }
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",
          deviceTokenStr);
}
//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush Demo]%@",str);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    NSLog(@"%@",userInfo);
    if ([userInfo[@"a1"] isEqualToString:@"isTryst"]) {
        AppointmentView *view = [[AppointmentView alloc]initWithFrame:CGRectMake(0, Screen_height, Screen_width, Screen_height)];
        [view showWithDic:userInfo];
        
    }else if ([userInfo[@"a1"] isEqualToString:@"yes"]){
        AppointmentAlert *appointalert = (AppointmentAlert *)[[[UIApplication sharedApplication].keyWindow subviews]lastObject];
        [appointalert showAlert:AppointmentAlertTypeAgree];
    }else if ([userInfo[@"a1"] isEqualToString:@"no"]){
        AppointmentAlert *appointalert = (AppointmentAlert *)[[[UIApplication sharedApplication].keyWindow subviews]lastObject];
        [appointalert showAlert:AppointmentAlertTypeRefuse];
    }
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bofu.BFTest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BFTest" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BFTest.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
