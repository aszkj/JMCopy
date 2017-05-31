//
//  JinMaimMainController.m
//  BFTest
//
//  Created by 伯符 on 16/6/2.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "AppDelegate+Register.h"

#import "JinMaimMainController.h"
#import "BFRegisterController.h"
#import "BFNavigationController.h"
#import "BFTabbarController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "EditUserMesgController.h"
#import "BFAppController.h"
#import <ImageIO/ImageIO.h>
@interface JinMaimMainController ()<TencentSessionDelegate,WXApiDelegate>{
    UIButton *wxbtn;
    UIButton *wbbtn;
    UIButton *mobilebtn;
    UIButton *qqbtn;
}
@property (copy, nonatomic) void (^requestForUserInfoBlock)();
@property (nonatomic,strong)TencentOAuth *tencentOAuth;
@property (nonatomic,strong)NSArray *permissions;

@property (nonatomic,strong)NSMutableArray *loginBtns;

@end

@implementation JinMaimMainController

- (NSMutableArray *)loginBtns{
    if (!_loginBtns) {
        _loginBtns = [NSMutableArray array];
    }
    return _loginBtns;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //3,初始化TencentOAuth 对象 appid来自应用宝创建的应用， deletegate设置为self  一定记得实现代理方法
    self.tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1105534094" andDelegate:self];
    //4，设置需要的权限列表，此处尽量使用什么取什么。
   
    self.permissions = [NSArray arrayWithObjects: kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    [self configureUI];
}
#pragma mark - 处理GIF图的方法 借用sd_webimage
+ (UIImage *)gif_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self gif_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}
+ (float)gif_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

- (void)configureUI{
    
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verback"]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gifTest" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [[self class] gif_animatedGIFWithData:data];
//    backView.image = [UIImage imageNamed:@"mainback.jpg"];
    backView.image = image;
    backView.userInteractionEnabled = YES;
    backView.frame = self.view.bounds;
    backView.contentMode = UIViewContentModeScaleAspectFit;
    backView.clipsToBounds = YES;
    [self.view addSubview:backView];
    
    for ( int i = 0; i < 4; i ++ ) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_%d",i]] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(otherLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginBtns addObject:btn];
        if (i == 0) {
            wxbtn = btn;
        }else if (i == 1){
            wbbtn = btn;
        }else if (i == 2){
            mobilebtn = btn;
        }else{
            qqbtn = btn;
        }
    }
    
    if (![WXApi isWXAppInstalled]) {
        wxbtn.hidden = YES;
        [self.loginBtns removeObject:wxbtn];
    }
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"applogo"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.clipsToBounds = YES;
//    [backView addSubview:logo];
    logo.frame = CGRectMake(0, 0, 70, 70);
    logo.center = CGPointMake(Screen_width/2, 160);
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0, 180*ScreenRatio, 25*ScreenRatio)];
    nameLabel.center = CGPointMake(Screen_width/2, CGRectGetMaxY(logo.frame)+ 20*ScreenRatio);
    nameLabel.text = @"近 脉 · Life";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:22];
    nameLabel.textColor = [UIColor whiteColor];
//    [backView addSubview:nameLabel];
    
    UILabel *otherRegist = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 16)];
    otherRegist.textColor = BFColor(151, 151, 151, 1);
    otherRegist.textAlignment = NSTextAlignmentCenter;
    otherRegist.text = @"选择登录方式";
    otherRegist.font = BFFontOfSize(12);
    otherRegist.center = CGPointMake(Screen_width/2, Screen_height - 150);
    [backView addSubview:otherRegist];
    UIImageView *lefLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, Screen_height - 150, (Screen_width - 120 - 10 - 20)/2, 0.5)];
    lefLine.backgroundColor = BFColor(151, 151, 151, 0.5);
    [backView addSubview:lefLine];
    UIImageView *rightLine = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(otherRegist.frame) + 5, Screen_height - 150, (Screen_width - 120 - 10 - 20)/2, 0.5)];
    rightLine.backgroundColor = BFColor(151, 151, 151, 0.5);
    [backView addSubview:rightLine];
    for ( int i = 0; i < self.loginBtns.count; i ++ ) {
        UIButton * btn = self.loginBtns[i];
        
        NSInteger spacing = ( Screen_width - 32 * ScreenRatio * self.loginBtns.count - 70 * ScreenRatio )/(self.loginBtns.count - 1);
        btn.frame = CGRectMake(35 * ScreenRatio + (spacing + 32*ScreenRatio) * i, CGRectGetMaxY(otherRegist.frame)+ 20, 32 * ScreenRatio, 32 * ScreenRatio);
        btn.tag = i + 99;
    }
    UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(otherRegist.frame) + 70 * ScreenRatio, Screen_width - 20, 0.5)];
    bottomLine.backgroundColor = BFColor(151, 151, 151, 0.5);
    [backView addSubview:bottomLine];
    
    // 免责
    UILabel *labone = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenRatio, 20*ScreenRatio)];
    labone.center = CGPointMake(Screen_width/2 - 50*ScreenRatio, Screen_height - 26*ScreenRatio);
    labone.textAlignment = NSTextAlignmentRight;
    labone.font = BFFontOfSize(12);
    labone.textColor = [UIColor whiteColor];
    labone.text = @"登录即代表你同意";
    [backView addSubview:labone];
    UIButton *btnone = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130*ScreenRatio, 20*ScreenRatio)];
    btnone.center = CGPointMake(Screen_width/2 + btnone.width/2, Screen_height - 26*ScreenRatio);
    NSMutableAttributedString *disclaimer = [[NSMutableAttributedString alloc]initWithString:@"近脉服务和隐私条款"];
    [disclaimer addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, disclaimer.length)];
    [disclaimer addAttribute:NSForegroundColorAttributeName value:BFThemeColor range:NSMakeRange(0, disclaimer.length)];
    [btnone setAttributedTitle:disclaimer forState:UIControlStateNormal];
    btnone.titleLabel.font = BFFontOfSize(12);
    btnone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnone addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnone];
}

- (void)btnClick:(UIButton *)btn{
    // 免责
    NSString *url = @"https://userapi.jinmailife.com:8000/agreement.html";
    BFAppController *vc = [[BFAppController alloc]init];
    vc.navibarHidden = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.pathStr = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)otherLoginClick:(UIButton *)btn{
    if (self.loginBtns.count == 4) {
        switch (btn.tag) {
            case 99:
            {
                //微信登录
                [self WXlogin];
            }
                break;
            case 100:
            {
                // 微博登录
                [self WeiboLogin];
                
            }
                break;
            case 101:
            {
                [self loginByPhone];

            }
                break;
            case 102:
            {
                // QQ登录
                [self QQlogin];
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (btn.tag) {
            case 99:
            {
                [self WeiboLogin];

            }
                break;
            case 100:
            {
                [self loginByPhone];
                
            }
                break;
            case 101:
            {
                // QQ登录
                [self QQlogin];
            }
                break;

            default:
                break;
        }
    }
    
}

#pragma mark - WeiboLogin
- (void)WeiboLogin{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WBRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"JinMaimMainController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

#pragma mark - QQlogin
- (void)QQlogin{
    [self.tencentOAuth authorize:self.permissions inSafari:NO];
}

- (void)tencentDidLogin{
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSString *accessToken = self.tencentOAuth.accessToken;
        
        AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate receiveToken:accessToken from:JM_TokenTypeQQ];
        
        [self.tencentOAuth getUserInfo];
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}


- (void)tencentDidNotLogin:(BOOL)cancelled{
    [UIViewController showUpLabelText:@"登录失败"];

}

- (void)tencentDidNotNetWork{
    [UIViewController showUpLabelText:@"登录失败"];
}

- (void)getUserInfoResponse:(APIResponse*) response{
    NSDictionary *dic = response.jsonResponse;
    
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"QQUserInfo"];
}


- (void)loginBaseWX{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = nil;
    req.openID = WXPatient_App_ID;
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
}

#pragma mark - WXLogin
- (void)WXlogin{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && UserwordMsg) {
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WXPatient_App_ID, refreshToken];
        [BFNetRequest getWithURLString:refreshUrlStr parameters:nil success:^(id responseObject) {
            NSMutableDictionary *refreshDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *reAccessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:WX_ACCESS_TOKEN];
                // 保存用户信息UserID到本地文件
                NSString *openID = [[refreshDict objectForKey:WX_OPEN_ID]stringByAppendingString:@"wx"];
                [SSKeychain setPassword:openID forService:@"JinMaiApp" account:kUserword];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
                !self.requestForUserInfoBlock ? : self.requestForUserInfoBlock();
 //               [self changeRootVCwithuserword:openID password:PasswordMsg];
            }
            else {
                [self wechatLogin];
            }
        } failure:^(NSError *error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
            
        }];
    }else{
        [self wechatLogin];
    }
}

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
        
        [self.navigationController pushViewController:vc animated:YES];
        //        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"JinMaiLifeApp";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loginByPhone{
    
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate receiveToken:nil from:JM_TokenTypePhone];
    return ;
    
}

@end
