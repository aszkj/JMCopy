//
//  EditUserMesgController.m
//  BFTest
//
//  Created by 伯符 on 17/3/4.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "EditUserMesgController.h"
#import "BFChatHelper.h"
@interface EditUserMesgController ()<UITextFieldDelegate,UIImagePickerControllerDelegate>

@end

@implementation EditUserMesgController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, Screen_width - 50*ScreenRatio, 185*ScreenRatio)];
        _datePicker.center = CGPointMake(Screen_width/2, Screen_height - 250*ScreenRatio/2 - 10*ScreenRatio);
        
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
        // 设置时区
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        
        // 设置当前显示时间
        [_datePicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_datePicker setMaximumDate:[NSDate date]];
        // 设置UIDatePicker的显示模式
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        // 当值发生改变的时候调用的方法
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self achieveUserData];
    self.title = @"完善资料";
    selectSex = @"男";
    [self configureUI];
    
}

#pragma mark - 请求用户信息

- (void)achieveUserData{
    
    __block NSDictionary *dicData;
    if ([self.userword containsString:@"wx"]) {
        NSString *uid = [[self.userword componentsSeparatedByString:@"wx"]firstObject];
        // 请求微信个人信息
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",GetUserMesg(WX_ACCESS_TOKEN),uid];
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
        NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",GetUserMesg(WB_TOKEN_KEY),uid];
        [BFNetRequest getWithURLString:url parameters:@{@"showNet":@"nonetAlert"} success:^(id responseObject) {
            NSDictionary *refreshDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (refreshDict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshUI:refreshDict];
                    
                });
            }
        } failure:^(NSError *error) {
            //
            NSLog(@"%@",[error description]);
        }];
    }else if ([self.userword containsString:@"qq"]){
        
        // QQ用户信息
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"QQUserInfo"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshUI:dic];
        });
    }else{
        NSDictionary *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mydata"];
        if (userData) {
            //        self.dicUser = userData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshUI:userData];
            });
        }
        
    }
    
}


- (void)refreshUI:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    if ([self.userword containsString:@"wx"]) {
        [icon sd_setImageWithURL:[NSURL URLWithString:dic[@"headimgurl"]]];
        imgPath = dic[@"headimgurl"];
        
        nicknameTF.text = dic[@"nickname"];
        NSInteger sexnum = [dic[@"sex"] intValue];
        
        if (sexnum == 0) {
            selectSex = @"男";
            UIButton *btn = (UIButton *)[back2 viewWithTag:99];
            btn.selected = YES;
            
        }else{
            UIButton *btn = (UIButton *)[back2 viewWithTag:99 + 1];
            btn.selected = YES;
            selectSex = @"女";
        }
    }else if ([self.userword containsString:@"qq"]){
        [icon sd_setImageWithURL:[NSURL URLWithString:dic[@"figureurl_qq_2"]]];
        imgPath = dic[@"figureurl_qq_2"];
        nicknameTF.text = dic[@"nickname"];
        //        NSInteger sexnum = [dic[@"sex"] intValue];
        
        if ([dic[@"gender"] isEqualToString:@"男"]) {
            selectSex = @"男";
            UIButton *btn = (UIButton *)[back2 viewWithTag:99];
            btn.selected = YES;
            
        }else{
            UIButton *btn = (UIButton *)[back2 viewWithTag:99 + 1];
            btn.selected = YES;
            selectSex = @"女";
        }
    }else if ([self.userword containsString:@"wb"]){
        [icon sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar_hd"]]];
        imgPath = dic[@"avatar_hd"];
        nicknameTF.text = dic[@"name"];
        //        NSInteger sexnum = [dic[@"sex"] intValue];
        
        if ([dic[@"gender"] isEqualToString:@"m"]) {
            selectSex = @"男";
            UIButton *btn = (UIButton *)[back2 viewWithTag:99];
            btn.selected = YES;
            
        }else{
            UIButton *btn = (UIButton *)[back2 viewWithTag:99 + 1];
            btn.selected = YES;
            selectSex = @"女";
        }
    }
    
}

- (void)configureUI{
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(0, 0, 40, 18);
    [save setTitle:@"完成" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = BFFontOfSize(12);
    UIBarButtonItem *saveBtem = [[UIBarButtonItem alloc]initWithCustomView:save];
    [save addTarget:self action:@selector(saveUserMsg:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = saveBtem;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xback"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, 100*ScreenRatio)];
    back.backgroundColor = BFColor(37, 38, 39, 1);
    [self.view addSubview:back];
    
    icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,75*ScreenRatio,75*ScreenRatio)];
    icon.userInteractionEnabled = YES;
    icon.center = CGPointMake(Screen_width/2, 10*ScreenRatio + CGRectGetWidth(icon.frame)/2);
    icon.image = [UIImage imageNamed:@"myiconback"];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.layer.cornerRadius = CGRectGetWidth(icon.frame)/2;
    icon.layer.masksToBounds = YES;
    [back addSubview:icon];
    [icon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic:)]];
    
    
    UIButton *addicon = [UIButton buttonWithType:UIButtonTypeCustom];
    addicon.frame = CGRectMake(CGRectGetMaxX(icon.frame) - 23*ScreenRatio, CGRectGetMaxY(icon.frame) - 23*ScreenRatio, 23 * ScreenRatio, 23 * ScreenRatio);
    [addicon setBackgroundImage:[UIImage imageNamed:@"jiaicon"] forState:UIControlStateNormal];
    [back addSubview:addicon];
    [addicon addTarget:self action:@selector(addPic:) forControlEvents:UIControlEventTouchUpInside];
    
    
    back2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(back.frame), Screen_width, 190*ScreenRatio)];
    back2.backgroundColor = BFColor(235, 236, 237, 1);
    [self.view addSubview:back2];
    
    for (int i = 0; i < 2; i ++) {
        UIView *vb = [[UIView alloc]initWithFrame:CGRectMake(0, 10*ScreenRatio + (40*ScreenRatio + 10*ScreenRatio)*i, Screen_width, 40*ScreenRatio)];
        vb.backgroundColor = [UIColor whiteColor];
        [back2 addSubview:vb];
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(15*ScreenRatio, 2*ScreenRatio, Screen_width - 30*ScreenRatio, CGRectGetHeight(vb.frame) - 4*ScreenRatio)];
        tf.backgroundColor = [UIColor clearColor];
        tf.placeholder = i ==0 ? @"用户名" : @"出生日期";
        tf.delegate = self;
        [tf setValue:BFColor(151, 151, 151, 1) forKeyPath:@"_placeholderLabel.textColor"];
        tf.textColor = BFColor(134, 134, 134, 1);
        tf.font = BFFontOfSize(15);
        [vb addSubview:tf];
        if (i == 0) {
            nicknameTF = tf;
        }else{
            birthTF = tf;
        }
    }
    
    UILabel *whoi = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(birthTF.superview.frame) + 7*ScreenRatio, 35*ScreenRatio, 19*ScreenRatio)];
    whoi.textAlignment = NSTextAlignmentLeft;
    whoi.font = BFFontOfSize(15);
    whoi.textColor = [UIColor blackColor];
    whoi.text = @"我是";
    [back2 addSubview:whoi];
    
    UILabel *who_attachLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+35*ScreenRatio, CGRectGetMaxY(birthTF.superview.frame) + 7*ScreenRatio, 130*ScreenRatio, 19*ScreenRatio)];
    who_attachLabel.textAlignment = NSTextAlignmentLeft;
    who_attachLabel.font = BFFontOfSize(13);
    who_attachLabel.textColor = [UIColor grayColor];
    who_attachLabel.text = @"(性别选定后不能更改)";
    [back2 addSubview:who_attachLabel];
    
    
    for (int i = 0; i < 2; i ++ ) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 99 + i;
        
        btn.frame = CGRectMake(13*ScreenRatio + (1+(Screen_width - 13*ScreenRatio*2)/2)*i, CGRectGetMaxY(whoi.frame)+7*ScreenRatio, (Screen_width - 13*ScreenRatio*2 - 1)/2, 45*ScreenRatio);
        [btn setBackgroundColor:[UIColor whiteColor]];
        if (i == 0) {
            btn.selected = NO;
            selectSex = @"男";
            [btn setTitle:@"男生" forState:UIControlStateNormal];
            selectBtn = nil;
        }else{
            [btn setTitle:@"女生" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
        [back2 addSubview:btn];
    }
}

- (void)backItemClick:(UIBarButtonItem *)back{
    
    [self showAlertViewTitle:@"是否确定关闭" message:@"关闭后所有已填资料将被清空，下次需重新填写" sureAction:^{
        [BFUserLoginManager shardManager].jmId = @"";
        [self.navigationController popToRootViewControllerAnimated:YES];
    } cancelAction:^{
    }];
}

- (void)selectSex:(UIButton *)btn{
    if (selectBtn != btn) {
        btn.selected = YES;
        [btn setBackgroundColor:BFThemeColor];
        [selectBtn setBackgroundColor:[UIColor whiteColor]];
        selectBtn.selected = NO;
        selectBtn = btn;
    }
    if (btn.tag == 99) {
        selectSex = @"男";
    }else{
        selectSex = @"女";
    }
}

- (void)saveUserMsg:(UIButton *)compete{
    if (nicknameTF.text.length == 0 ) {
        
        [self showAlertViewTitle:@"请输入用户名" message:nil];
        return ;
    }
    if (birthTF.text.length == 0 ) {
        [self showAlertViewTitle:@"请选择出生日期" message:nil];
        return ;
    }
    /*
     if (icon.image == [UIImage imageNamed:@"myiconback"]) {
     [self showAlertViewTitle:@"请设置头像" message:nil];
     return ;
     }
     */
    NSLog(@"%@-----%@",imgPath,icon.image);
    if (!imgPath) {
        [self showAlertViewTitle:@"请设置头像" message:nil];
        return ;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/SetUserinfo",ALI_BASEURL];
    NSDictionary *para;
    
    if (self.userword && JMTOKEN) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        para = @{@"tkname":self.userword,@"tok":JMTOKEN,@"nikename":nicknameTF.text,@"mybmp":imgPath,@"sex":selectSex,@"birthday":birthTF.text,@"constellation":constellationStr,@"years":agestr};
    }
    
    [BFNetRequest postWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([accessDict[@"s"] isEqualToString:@"t"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self changeToMainVC];
            [[NSUserDefaults standardUserDefaults]setObject:para forKey:@"Mydata"];
        }
    } failure:^(NSError *error) {
        //
    }];
    
}

- (void)changeToMainVC{
    // 登录到主界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults]setObject:self.userword forKey:kUserword];
        [[NSUserDefaults standardUserDefaults]setObject:self.pass forKey:kPassword];
        [[NSUserDefaults standardUserDefaults]setObject:self.mobile forKey:@"UserMobile"];
        BFTabbarController *vc = [[BFTabbarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    });
}

- (void)addPic:(UIButton *)btn{
    if(imageExist == NO){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请上传真实头像照片" message:@"使用假头像会被系统屏蔽" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self chosePic:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self chosePic:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (birthTF == textField) {
        
        [nicknameTF resignFirstResponder];
        [self buildDatePicker];
        return NO;
    }
    return YES;
    
}

- (void)buildDatePicker{
    
    [self.view addSubview:self.datePicker];
}

- (void)chosePic:(UITapGestureRecognizer *)gesture{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"从相册选择"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.allowsEditing = YES;
            //打开相册选择照片
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *img = info[UIImagePickerControllerEditedImage];
        icon.image = img;

        
        NSString *urlStr = [NSString stringWithFormat:@"%@/upload",ALI_BASEURL];
        NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
        NSDictionary *para = @{@"tkname":self.userword,@"tok":JMTOKEN};
        
        [BFNetRequest uploadWithURLString:urlStr parameters:para uploadParam:imgData success:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic[@"s"] isEqualToString:@"t"]) {
                NSArray *imgarray = dic[@"data"];
                NSDictionary *imgDic = [imgarray firstObject];
                NSString *imgStr = imgDic[@"path"];
                imgPath = imgStr;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
        } failure:^(NSError *error) {
            //
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIDatePicker
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    
    self.birthday = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self.birthday];
    birthTF.text = strDate;
    [self getAgeWith:self.birthday];
    [self getConstellationFromBirthday:self.birthday];
    
}

//根据生日得到年龄
- (void)getAgeWith:(NSDate*)birthday{
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:birthday toDate:[NSDate  date] options:0];
    
    agestr = [NSString stringWithFormat:@"%ld",[components year]];
}

//根据生日得到星座
- (void)getConstellationFromBirthday:(NSDate*)birthday{
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [myCal components:NSCalendarUnitMonth| NSCalendarUnitDay fromDate:birthday];
    NSInteger month = [comp1 month];
    NSInteger day = [comp1 day];
    constellationStr = [self getAstroWithMonth:month day:day];
}

//得到星座的算法
-(NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
    }
    
    if(m==2 && d>29)
        
    {
        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return [result stringByAppendingString:@"座"];
}

@end
