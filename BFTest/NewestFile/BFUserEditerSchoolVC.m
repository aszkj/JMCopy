//
//  BFUserEditerSchoolVC.m
//  BFTest
//
//  Created by JM on 2017/4/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//
#define CELLID @"cell"

#import "BFUserEditerSchoolVC.h"
#import "BFUserInfoEditDataSourceManager.h"

@interface BFUserEditerSchoolVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *schoolTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIView *startSchoolYearbackView;
@property (weak, nonatomic) IBOutlet UILabel *startSchoolYearLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerLeftMaskView;
@property (weak, nonatomic) IBOutlet UIView *datePickerRightMaskView;

@property (nonatomic,strong)BFUserEditerTableViewAddTagVCSettingModel *settingModel;
@property (nonatomic,strong)NSMutableArray *dataSourceArrM;

@end

@implementation BFUserEditerSchoolVC

- (void)setStartSchoolYearLabelText:(NSString *)str{
    self.startSchoolYearLabel.text = str;
    self.placeHolderLabel.hidden = self.startSchoolYearLabel.text.length == 0 ? NO : YES ;
    self.startSchoolYearLabel.hidden = self.startSchoolYearLabel.text.length == 0 ? YES : NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupUI];
    [self setHidenOfViews];
    [self setViewsByOrignData];
}

- (void)setupDataSource{
    self.settingModel = [[BFUserInfoEditDataSourceManager shardManager]getSettingModelWithIndexPath:self.callBack(@"")];
}

- (void)setupUI{
    //设置tableView
    [self setupTableView];
    
    //设置datePicker
    [self setupDatePicker];
    
    //设置textField 代理
    self.schoolTextField.delegate = self;
    
    //设置导航栏右侧完成按钮
     [self setRightNavItem];
    
    //设置startSchoolYearView 点击事件
    [self setupStartSchoolYearViewTapAction];
}

- (void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
    self.tableView.showsVerticalScrollIndicator = NO;
}
- (void)setHidenOfViews{
    self.tableView.hidden = YES;
    [self hideDatePickerView:YES];
    self.startSchoolYearLabel.hidden = YES;
}

- (void)hideDatePickerView:(BOOL)trueOrFalse{
    self.datePicker.hidden = trueOrFalse;
    self.datePickerLeftMaskView.hidden = trueOrFalse;
    self.datePickerRightMaskView.hidden = trueOrFalse;
}
- (void)setupDatePicker{
    UIDatePicker *datePicker = self.datePicker;
    
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    // 设置时区
    [datePicker setTimeZone:[NSTimeZone localTimeZone]];
    
    // 设置当前显示时间
    [datePicker setDate:[NSDate date] animated:YES];
    
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    // 当值发生改变的时候调用的方法
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //初始化当前显示的年龄以及星座
    [self datePickerValueChanged:datePicker];
}

- (void)setupStartSchoolYearViewTapAction{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.startSchoolYearbackView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self hideDatePickerView:!self.datePicker.hidden];
}
- (void)setRightNavItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(popToLastVC)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)popToLastVC{
    
    if(self.schoolTextField.text.length == 0){
        [self showAlertViewTitle:@"请选择学校" message:nil];
        return;
    }
    
    if(self.startSchoolYearLabel.text.length == 0){
        [self showAlertViewTitle:@"请选择入学年份" message:nil];
        return;
    }
    
    NSString *str = nil;
    if(self.schoolTextField.text && self.startSchoolYearLabel.text){
        
        //截取年份后两位字符
        NSString *yearStr = [self.startSchoolYearLabel.text substringFromIndex:2];
    str = [NSString stringWithFormat:@"%@%@级",self.schoolTextField.text,yearStr];
        
    }else{
        str = nil;
    }
    
    self.callBack(str);
    BOOL isContainSchool = NO;
    for(NSString *string in self.settingModel.infoArrM){
        if([string isEqualToString:self.schoolTextField.text]){
            isContainSchool = YES;
        }
    }
    
    //跳出本页面前判断总数据源数组中是否包含当前用户的学校，如果没有则存入一份
    if(!isContainSchool){
        [self.settingModel.infoArrM addObject:self.schoolTextField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setViewsByOrignData{
    self.schoolTextField.text = nil;
    [self setStartSchoolYearLabelText:nil];
}

#pragma mark - 当textField文字改变时 改变数据源并且刷新UI
- (void)refreshTableViewByNewStr:(NSString *)str{
    NSLog(@"当前查找的str ->%@",str);
    //这一步耗时操作放到子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.dataSourceArrM = [NSMutableArray array];
        for(NSString *sourceStr in self.settingModel.infoArrM){
            if([sourceStr containsString:str]){
                [self.dataSourceArrM addObject:sourceStr];
            }
        }
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        
    });
}
#pragma mark - tableView 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.schoolTextField.text = self.dataSourceArrM[indexPath.row];
    [self refreshTableViewByNewStr:self.schoolTextField.text];
    [self endEditing];
}

#pragma mark - tableView 的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArrM[indexPath.row];
    return cell;
}

#pragma mark - textField 的代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.tableView.hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    dispatch_async(dispatch_get_main_queue(), ^{
        //在主队列的异步函数中可以拿到textField的编辑完成后的值
        [self refreshTableViewByNewStr:textField.text];
    });
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    dispatch_async(dispatch_get_main_queue(), ^{
        //在主队列的异步函数中可以拿到textField的编辑完成后的值
        [self refreshTableViewByNewStr:textField.text];
    });
    return  YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"当前TF.text ->%@     删除的str ->%@ 长度 ->%zd ",textField.text,string,string.length);
    //判断当前是删除还是添加
    if(string.length == 0){
        NSString *currentStr = [textField.text substringToIndex:textField.text.length-1];
        [self  refreshTableViewByNewStr: currentStr];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //在主队列的异步函数中可以拿到textField的编辑完成后的值
            [self refreshTableViewByNewStr:textField.text];
        });
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing];
    return YES;
}

#pragma  mark - datePicker 联动的方法
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [myCal components:NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitYear fromDate:datePicker.date];
    
    NSInteger year = [components year];
    [self setStartSchoolYearLabelText: [NSString stringWithFormat:@"%zd",year]];
}

#pragma mark - 让textField失去第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing];
}

- (void)endEditing{
    [self.schoolTextField resignFirstResponder];
    self.tableView.hidden = YES;
}


@end
