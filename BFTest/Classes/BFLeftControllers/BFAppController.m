//
//  BFAppController.m
//  BFTest
//
//  Created by 伯符 on 16/6/17.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFAppController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import <Photos/Photos.h>

#import "WXApi.h"
#import "AppointmentAlert.h"
@interface BFAppController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>{
    WKWebView *web;
    UIProgressView *progress;
}

@property (nonatomic,assign)NSUInteger loadCount;
@end

@implementation BFAppController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.navibarHidden) {
        self.navigationController.navigationBar.hidden = YES;
        
    }else{
        self.navigationController.navigationBar.hidden = NO;
        
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIView *statusbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 20)];
    statusbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusbar];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor whiteColor];
    //
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xback"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    //    self.navigationItem.leftBarButtonItem = backItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc]init];
    
    configuretion.preferences.minimumFontSize = 10;
    configuretion.preferences.javaScriptEnabled = true;
    
    WKPreferences * prefer = [[WKPreferences alloc]init];
    prefer.javaScriptEnabled = YES;
    prefer.minimumFontSize = 20;
    prefer.javaScriptCanOpenWindowsAutomatically = YES;
    configuretion.preferences = prefer;
    
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    WKUserContentController *userContent = [[WKUserContentController alloc]init];
    [userContent addScriptMessageHandler:self name:@"get_token"];
    [userContent addScriptMessageHandler:self name:@"started_alipay"];
    [userContent addScriptMessageHandler:self name:@"started_weixinpay"];
    [userContent addScriptMessageHandler:self name:@"go_back"];
    [userContent addScriptMessageHandler:self name:@"send_tryst"];
    [userContent addScriptMessageHandler:self name:@"make_call"];
    [userContent addScriptMessageHandler:self name:@"save_photo"];
    [userContent addScriptMessageHandler:self name:@"setWebView_ScrollEnable"];
    [userContent addScriptMessageHandler:self name:@"current_WebVersion"];
    // 通过js与webview内容交互配置
    configuretion.userContentController = userContent;
    
    web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, Screen_width, Screen_height - 20 ) configuration:configuretion];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pathStr]]];
    web.allowsBackForwardNavigationGestures = NO;
    web.scrollView.bounces = NO;
    web.UIDelegate = self;
    web.navigationDelegate = self;
     __weak BFAppController *weakSelf =  self;
    [web addObserver:weakSelf forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, 0)];
    progress.tintColor = [UIColor orangeColor];
    progress.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progress];
    [self.view insertSubview:web belowSubview:progress];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successPayCall:) name:kAlipaySuccessCallback object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successWXPayCall:) name:kWeixinpaySuccessCallback object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successGetTokenCall:) name:kGetTokenNotification object:nil];
    
}

- (void)successPayCall:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSString *jsStr = [NSString stringWithFormat:@"r__started_alipay('%@','%@','%@')",userInfo[@"resultStatus"],userInfo[@"result"],userInfo[@"memo"]];
    [web evaluateJavaScript:jsStr completionHandler:^(id item, NSError * _Nullable error) {
        NSLog(@"----- %@",[error description]);
    }];
}


- (void)successGetTokenCall:(NSNotification *)notification{
    
    NSString *mobilephone = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserMobile"];
    NSString *str = [NSString stringWithFormat:@"113.957508,22.56144"];
    NSString *jsStr = [NSString stringWithFormat:@"r__get_token('%@','%@','%@','%@')",UserwordMsg,mobilephone,JMTOKEN,str];
    NSLog(@"%@",jsStr);
    [web evaluateJavaScript:jsStr completionHandler:^(id item, NSError * _Nullable error) {
        NSLog(@"----- %@",[error description]);
    }];
}

- (void)successWXPayCall:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    NSString *jsStr = [NSString stringWithFormat:@"r__started_weixinpay('%@')",userInfo[@"result"]];
    [web evaluateJavaScript:jsStr completionHandler:^(id item, NSError * _Nullable error) {
        NSLog(@"----- %@",[error description]);
    }];
    
    
}

- (void)backItemClick:(UIBarButtonItem *)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == web && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            progress.hidden = YES;
            [progress setProgress:0 animated:NO];
        }else {
            progress.hidden = NO;
            [progress setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"get_token"]) {
        
        [self successGetTokenCall:nil];
        
    }else if ([message.name isEqualToString:@"started_alipay"]){
        NSDictionary *dic = message.body;
        //    应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"JinMaiPay";
        NSString *orderStr = [dic objectForKey:@"alipay_call_param"];
        
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kAlipaySuccessCallback object:nil userInfo:resultDic];
        }];
    }else if ([message.name isEqualToString:@"go_back"]){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([message.name isEqualToString:@"started_weixinpay"]){
        NSDictionary *dic = message.body;
        
        if (dic != nil) {
            NSString *para = dic[@"weixinpay_call_param"];
            NSData *data = [para dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *paraDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSMutableString *stamp  = [paraDic objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [paraDic objectForKey:@"partnerid"];
            req.prepayId            = [paraDic objectForKey:@"prepayid"];
            req.nonceStr            = [paraDic objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [paraDic objectForKey:@"package"];
            req.sign                = [paraDic objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[paraDic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
        }
        
    }else if([message.name isEqualToString:@"send_tryst"]){
        NSDictionary *dic = message.body;
        NSString *para = dic[@"dating_info"];
        NSData *data = [para dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *paraDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",paraDic);
        [self sendAppointment:paraDic];
    }else if([message.name isEqualToString:@"make_call"]){
        NSDictionary *dic = message.body;
        NSString *tel = dic[@"tel"];
        NSLog(@"%@",tel);
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }else if([message.name isEqualToString:@"setWebView_ScrollEnable"]){
        NSDictionary *dic = message.body;
        NSNumber *b = dic[@"bool"];
        NSLog(@"%@",b);
        web.scrollView.scrollEnabled = !b.integerValue;
    }else if([message.name isEqualToString:@"save_photo"]){
        NSDictionary *dic = message.body;
        NSLog(@"%@",dic);
        NSString *photo_url = dic[@"photo_url"];
        //创建异步下载
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo_url]];
            UIImage *image = [UIImage imageWithData:imgData];
            [self asyncSaveImage:image];
        });
        
    }else if([message.name isEqualToString:@"current_WebVersion"]){
        NSDictionary *dic = message.body;
        NSString *version = dic[@"version"];
        NSLog(@"webVersion ------->%@",version);
        NSString *currentVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"webVersion"];
        
        if(![currentVersion isEqualToString:version]||currentVersion == nil){
            //版本号不同则存储最新的版本号
            [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"webVersion"];
            //清除上个版本的缓存
             [self deleteWebCache];
        }
        

    }
}
//异步保存图片
-(void)asyncSaveImage:(UIImage *)image
{
    //1 必须在 block 中调用
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //2 异步执行保存图片操作
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //3 保存结束后，回调
            if (error) {
                [self showAlertViewTitle:@"保存失败" message:nil duration:1];
            }else
                [self showAlertViewTitle:@"保存成功" message:nil duration:1];
        });
    }];
}

- (void)postCoupon:(NSString *)toke{
    
    NSString *jsStr = [NSString stringWithFormat:@"r__get_token_by_restaurant_buy_ticket({platform_gid:'1',platform_uid:'%@',platform_params:{dowhatudoid:'99www',mytoken:'%@',targetid:'123@qq.com'}})",UserwordMsg,toke];
    NSLog(@"%@",jsStr);
    [web evaluateJavaScript:jsStr completionHandler:^(id item, NSError * _Nullable error) {
        NSLog(@"----- %@",[error description]);
        
    }];
    
}

// 记得取消监听
- (void)dealloc {
    [web removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)sendAppointment:(NSDictionary *)dic{
    //    http://59.110.48.243:8000/sendxg?tkname=1008@wk.com.wk&message_type=2&message=刚回家VBGVl刚回家结婚狂
    NSString *fridID = dic[@"slave"];
    NSString *master = dic[@"master"];
    NSString *imgurl = dic[@"pair_url"];
    NSDictionary *para = @{@"a1":@"isTryst",@"a2":imgurl,@"a3":master,@"tkname":fridID,@"message_type":@3,@"message":@"haha"};
    
    NSString *url = [NSString stringWithFormat:@"http://59.110.48.243:8000/sendxg"];
    [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([accessDict[@"err_msg"] isEqualToString:@"ok"]) {
            AppointmentAlert *alert = [[AppointmentAlert alloc]initWithFrame:CGRectMake(0, 0, Screen_width - 60*ScreenRatio, 150*ScreenRatio)];
            [alert showAlert:AppointmentAlertTypeWaitting];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)deleteWebCache {
 
    if ([[[UIDevice currentDevice] systemVersion] intValue ] > 8) {
        NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];  // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}


@end
