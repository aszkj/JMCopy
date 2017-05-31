//
//  EditUserMesgController+new.m
//  BFTest
//
//  Created by JM on 2017/3/31.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "EditUserMesgController+new.h"
#import "BFOriginNetWorkingTool+login.h"
#import "BFUserLoginManager.h"
#import "QiniuSDK.h"
#import "UIImage+Addition.h"

@implementation EditUserMesgController (new)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userword = [BFUserLoginManager shardManager].loginName;
    [self achieveUserData];
    self.title = @"完善资料";
    selectSex = @"男";
    [self configureUI];
    
}

#pragma mark - 请求用户信息

- (void)achieveUserData{
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    __block NSDictionary *dicData;
    if ([self.userword containsString:@"wx"]) {
        NSString *uid = [[self.userword componentsSeparatedByString:@"wx"]firstObject];
        // 请求微信个人信息
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[BFUserLoginManager shardManager].wx_accessToken,uid];
        [BFNetRequest getaWithURLString:url parameters:@{@"showNet":@"nonetAlert"} success:^(id responseObject) {
            NSDictionary *refreshDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",refreshDict);
            if (refreshDict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshUI:refreshDict];
                    
                });
            }
            
            dicData = refreshDict;
        } failure:^(NSError *error) {
            //
            NSLog(@"%@",[error description]);
        }];
    }else if ([self.userword containsString:@"wb"]){
        NSString *uid = [[self.userword componentsSeparatedByString:@"wb"]firstObject];
        
        // 请求微博个人信息
        NSString *wbUserInfoGetUrl = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",manager.wb_accessToken,uid];
        [BFOriginNetWorkingTool getWithURLString:wbUserInfoGetUrl parameters:nil success:^(NSDictionary *responseObject) {
            
            NSDictionary *resp = responseObject;
            NSString *name = resp[@"name"];
            NSString *gender = resp[@"gender"];
            NSString *avatar_hd = resp[@"avatar_hd"];
            
            manager.photo = avatar_hd;
            manager.sex = [gender isEqualToString:@"m"] ? @"男":@"女";
            manager.name = name;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshUI:resp];
            });
        } failure:^(NSError *error) {
            
            NSLog(@"从微博拉取用户信息失败！");
        }];
    }else if ([self.userword containsString:@"qq"]){
        
        // QQ用户信息
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"QQUserInfo"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshUI:dic];
            
        });
    }
}

- (void)saveUserMsg:(UIButton *)compete{
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
    if (nicknameTF.text.length == 0 ) {
        
        [self showAlertViewTitle:@"完善资料" message:@"请填写用户名"];
        return ;
    }
    if (birthTF.text.length == 0 ) {
        [self showAlertViewTitle:@"完善资料" message:@"请选择出生日期"];
        return ;
    }
    if (agestr.intValue < 16){
        [self showAlertViewTitle:@"完善资料" message:@"你的年龄应该大于16岁"];
        return ;
    }
    
    NSLog(@"%@-----%@",imgPath,icon.image);
    if (!manager.photo) {
        [self showAlertViewTitle:@"完善资料" message:@"请上传头像照片"];
        return ;
    }
    
    manager.name = nicknameTF.text;
    manager.sex = [selectSex isEqualToString: @"男"] ? @"男":@"女";
    manager.birthDay = birthTF.text;
    
    
    [BFOriginNetWorkingTool finisnInfoCompletionHandler:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if(error){
            NSLog(@"上传用户基本信息错误 ->%@",error);
            
            
        }else{
            //上传成功 将用户单例中储存的数据本地化 并且跳转到中控制器
            BFUserLoginManager *manager = [BFUserLoginManager shardManager];
            [manager saveUserInfo];
            [manager loginToEMClientWithJmid:manager.jmId];
            [self changeToMainVC];
            
        }
    }];
    
}

- (void)changeToMainVC{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 登录到主界面
        BFTabbarController *vc = [[BFTabbarController alloc]init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    });
}

/**
 这个方法通过向第三方服务器发送请求 获得用户个人信息
 */

- (void)refreshUI:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    if ([self.userword containsString:@"wx"]) {
        
        NSString *photo = dic[@"headimgurl"];
        NSString *name = dic[@"nickname"];
        NSString *sex = nil;
        if([dic[@"sex"] intValue] == 1){
            sex = @"男";
        }
        if([dic[@"sex"] intValue] == 2){
            sex = @"女";
        }
        if([dic[@"sex"] intValue] == 0){
            sex = @"未知";
        }
        
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        manager.photo = photo;
        manager.name = name;
        manager.sex = sex;
        
        [icon sd_setImageWithURL:[NSURL URLWithString:photo]];
        imgPath = photo;
        
        nicknameTF.text = name;
        NSInteger sexnum = [dic[@"sex"] intValue];
        
        if (sexnum == 1) {
            selectSex = @"男";
            UIButton *btn = (UIButton *)[back2 viewWithTag:99];
            btn.selected = YES;
            
        }else if(sexnum == 2){
            UIButton *btn = (UIButton *)[back2 viewWithTag:99 + 1];
            btn.selected = YES;
            selectSex = @"女";
        }
    }else if ([self.userword containsString:@"qq"]){
        NSString *photo = dic[@"figureurl_qq_2"];
        NSString *name = dic[@"nickname"];
        NSString *sex = dic[@"gender"];
        
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        manager.photo = photo;
        manager.name = name;
        manager.sex = sex;
        
        
        
        [icon sd_setImageWithURL:[NSURL URLWithString:photo]];
        imgPath = photo;
        nicknameTF.text = name;
        
        if ([sex isEqualToString:@"男"]) {
            selectSex = @"男";
            UIButton *btn = (UIButton *)[back2 viewWithTag:99];
            btn.selected = YES;
            
        }else if([sex isEqualToString:@"男"]){
            UIButton *btn = (UIButton *)[back2 viewWithTag:99 + 1];
            btn.selected = YES;
            selectSex = @"女";
        }
    }else if ([self.userword containsString:@"wb"]){
        
        NSString *photo = dic[@"avatar_hd"];
        NSString *name = dic[@"name"];
        NSString *sex = [dic[@"gender"]isEqualToString:@"m"]?@"男":@"女";
        
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        manager.photo = photo;
        manager.name = name;
        manager.sex = sex;
        
        
        [icon sd_setImageWithURL:[NSURL URLWithString:photo]];
        imgPath = photo;
        nicknameTF.text = name;
        
        if ([sex isEqualToString:@"m"]) {
            selectSex = @"男";
            UIButton *btn = (UIButton *)[back2 viewWithTag:99];
            btn.selected = YES;
            
        }else if ([sex isEqualToString:@"f"]){
            UIButton *btn = (UIButton *)[back2 viewWithTag:99 + 1];
            btn.selected = YES;
            selectSex = @"女";
        }
    }else if([self.userword containsString:@"sj"]){
        BFUserLoginManager *manager = [BFUserLoginManager shardManager];
        
        [icon sd_setImageWithURL:[NSURL URLWithString:manager.photo]];
        imgPath = manager.photo;
        
        nicknameTF.text = manager.name;
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        
        UIImage *img = info[UIImagePickerControllerEditedImage];
        [BFUserLoginManager shardManager].iconImage = img;
        
        //压缩图片到100KB
        NSData *compressImageData = [img compressImageDataWithMaxLimit:100];
        
        //需要把图片上传到七牛
        [BFOriginNetWorkingTool getUploadTokenWith:@"image" completionHandler:^(NSString *qiniuToken, NSError *error) {
            NSLog(@"%@",qiniuToken);
            //配置上传管理者
            QNConfiguration *qnConfig = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNZone zone2];
            }];
            //配置上传选项
            QNUploadOption *option = [[QNUploadOption alloc]initWithMime:nil progressHandler:^(NSString *key, float percent) {
                NSLog(@"七牛上传进度 ->%f",percent);
            } params:nil checkCrc:NO cancellationSignal:nil];
            QNUploadManager *upManager = [QNUploadManager sharedInstanceWithConfiguration:qnConfig];
            [upManager putData:compressImageData key:nil token:qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
#warning 这里打印resp可以获取头像的url
                BFUserLoginManager *manager = [BFUserLoginManager shardManager];
                NSString *imgLastComponent = resp[@"key"];
                NSString *urlStr = [manager.qiniu_url stringByAppendingString:[NSString stringWithFormat:@"%@",imgLastComponent]];
                [BFUserLoginManager shardManager].photo = urlStr;
                
                
            } option:option];
        }];
        
#warning 这里假装获得了图片的URL
        icon.image = img;
        imageExist = YES;
        //之后拿到存储的URL保存到用户单例中
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
@end
