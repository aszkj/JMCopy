//
//  BFUserInfoSelfDefinedVC.m
//  BFTest
//
//  Created by JM on 2017/4/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//
static  BOOL popBack = NO;
#import "BFUserInfoSelfDefinedVC.h"
#import "BFUserInfoEditDataSourceManager.h"

@interface BFUserInfoSelfDefinedVC ()<UITextViewDelegate>


@property (nonatomic,strong)BFUserEditerTableViewAddTagVCSettingModel *settingModel;

@property (weak, nonatomic) IBOutlet UITextView *defineTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *giveInfoLabel;


@end

@implementation BFUserInfoSelfDefinedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVC];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.defineTextView.textAlignment = 
    
}


- (void)setupVC{
    self.defineTextView.delegate = self;
    //配置当前控制器  判断当前block是不是二级界面传来自定义
    if(self.callBack){
        //一级界面直接传过来的数据
        self.settingModel = [[BFUserInfoEditDataSourceManager shardManager]getSettingModelWithIndexPath:self.callBack(@"")];
        
    }else{
        //设置导航栏标题
        self.title = self.navTitle;
        NSString *str = nil;
        NSString *giveInfoStr = nil;
        if([self.title containsString:@"行业"]){
            str = @"自定义的行业名称";
            giveInfoStr = @"";
        }
        if([self.title containsString:@"职业"]){
            str = @"自定义的职业名称";
            giveInfoStr = @"";
        }
        if([self.title containsString:@"标签"]){
            str = @"自定义的标签";
            giveInfoStr = @"";
        }

        self.placeHolderLabel.text = [NSString stringWithFormat:@"请填写%@",str];
        self.giveInfoLabel.text = giveInfoStr;
    }
    [self setRightNavItem];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.defineTextView resignFirstResponder];
}
- (void)setSettingModel:(BFUserEditerTableViewAddTagVCSettingModel *)model{
    _settingModel = model;
    //设置导航栏标题
    self.navTitle = model.title;
    self.title = self.navTitle;
    self.defineTextView.text =  [self.model valueForKey:self.settingModel.keyForUserModel];
    
    NSString *str = nil;
    NSString *giveInfoStr = nil;
    if([self.navTitle containsString:@"用户名"]){
        str = @"用户名";
        giveInfoStr = @"填写真实的名字会让其他人更快速的看到你";
    }
    if([self.navTitle containsString:@"个性签名"]){
        str = @"个性签名";
        giveInfoStr = @"";
    }

    
    self.placeHolderLabel.text = [NSString stringWithFormat:@"请填写%@",str];
    self.giveInfoLabel.text = giveInfoStr;
    
    //是否隐藏placeHolderLabel
    ((NSString *)[self.model valueForKey:self.settingModel.keyForUserModel]).length > 0 ? (self.placeHolderLabel.hidden = YES) : (self.placeHolderLabel.hidden = NO);
}

- (void)setRightNavItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(popToLastVC)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    if(popBack == NO && [self.model valueForKey:self.settingModel.keyForUserModel] != nil){
        //如果不是点击完成按钮返回 并且原模型中对应的数据不为空 则回调原模型中的数据
        self.callBack([self.model valueForKey:self.settingModel.keyForUserModel]);
    }
    popBack = NO;
}

- (void)popToLastVC{
    popBack = YES;
    //一级界面回调
    if(self.callBack){
        if([self.settingModel.keyForUserModel isEqualToString:@"signature"]){
            //自我介绍回调检测 50字以内
            if(self.defineTextView.text.length > 50){
                [self showAlertViewTitle:@"输入的字数不能大于50，请写少一些吧~" message:nil];
                return;
            }
            self.callBack(self.defineTextView.text);
            
        }else{
            //限制回调字数在10个以内
            if(self.defineTextView.text.length > 10){
                [self showAlertViewTitle:@"输入的字数不能大于10，请写少一些吧~" message:nil];
                return;
            }
            //如果是用户名 则不能为空
            if([self.settingModel.keyForUserModel isEqualToString:@"name"] && self.defineTextView.text.length < 1){
                [self showAlertViewTitle:@"输入的用户名不能为空~" message:nil];
                return;
            }
            self.callBack(self.defineTextView.text);
        }
    }else{
        //二级界面回调
        if(self.defineTextView.text){
            if(self.defineTextView.text.length > 10){
                [self showAlertViewTitle:@"输入的字数不能大于10，请写少一些吧~" message:nil];
                return;
            }
            self.callAddTagBlock(self.defineTextView.text);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    textView.text.length > 0 ? (self.placeHolderLabel.hidden = YES):(self.placeHolderLabel.hidden = NO);
}


@end
