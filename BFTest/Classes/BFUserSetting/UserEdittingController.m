//
//  UserEdittingController.m
//  BFTest
//
//  Created by 伯符 on 16/10/27.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserEdittingController.h"
#import "EdittingBaseViewCell.h"
#import "CreateMyselfCell.h"
#import "UserNameController.h"
#import "ProvinceViewController.h"
#import "SchoolMsgViewCell.h"
@interface UserEdittingController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *userList;
    EdittingBaseViewCell *currentCell;
    
}
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) NSInteger rowsNum;

@property (nonatomic,copy) NSString *selectContent;

@property (nonatomic,copy) NSString *constellation;

@property (strong, nonatomic) NSDate* birthday;

@end

@implementation UserEdittingController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.rightStr = @"完成";
    self.view.backgroundColor = BFColor(244, 245, 246, 1);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initData];
    [self buildUI];

}

- (void)initData{
    switch (self.editviewType) {
        case UserEdittingTypeGender:
            self.dataArray = @[@"男",@"女"];
            break;
        case UserEdittingTypeMapGender:
            self.dataArray = @[@"男",@"女",@"全部"];
            break;
        case UserEdittingTypeAge:
            self.dataArray = @[@"年龄",@"星座"];
            break;
        case UserEdittingTypeAffectState:
            self.dataArray = @[@"保密",@"单身",@"恋爱中",@"单身已婚",@"同性"];
            break;
        case UserEdittingTypeFrom:
            self.dataArray = @[@"中国",@"丹麦",@"俄罗斯",@"加拿大",@"印度",@"奥地利",@"德国",@"意大利",@"新加坡",@"新西兰",@"日本",@"比利时",@"法国",@"泰国",@"澳大利亚",@"瑞典",@"瑞士",@"纽西兰",@"美国",@"芬兰",@"英国",@"荷兰",@"菲律宾",@"葡萄牙",@"西班牙",@"越南",@"韩国",@"马来西亚"];
            break;
        case UserEdittingTypeIndustry:
            self.dataArray = @[@"影视/娱乐",@"学生",@"文化/艺术",@"金融",@"医药/健康",@"工业/制造业",@"IT/互联网/通信",@"媒体/公关",@"零售",@"教育/科研",@"其他"];
            break;
        case UserEdittingTypeOccupation:
            self.dataArray = @[@"高管",@"创始人",@"投资人",@"职业经理人",@"咨询顾问",@"市场",@"产品",@"客服",@"销售",@"商务",@"公关",@"人事",@"行政",@"财务",@"法务",@"工程师",@"设计",@"运营",@"编辑",@"分析师",@"翻译",@"摄影师",@"配音员",@"导演",@"主持人/司仪",@"化妆师",@"造型师",@"经纪人/星探",@"作家/编剧/撰稿人",@"厨师"];
            break;
        case UserEdittingTypeSchool:
            //
            self.dataArray = @[@"添加学校信息",@"选择入学时间"];
            break;
        case UserEdittingTypeLikeAppointAddress:
            self.dataArray = @[@"餐厅",@"咖啡厅",@"运动馆",@"电影院",@"KTV",@"酒吧"];
            break;
        default:
            break;
    }
    self.rowsNum = self.dataArray.count;
}

- (void)buildUI{
    NSInteger listHeight;
    if (self.rowsNum * 39*ScreenRatio > Screen_height) {
        listHeight = Screen_height - NavBar_Height;
    }else{
        listHeight = self.rowsNum * 39*ScreenRatio;
    }
    userList = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, Screen_width, listHeight ) style:UITableViewStylePlain];
    
    userList.delegate = self;
    userList.dataSource = self;
    userList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:userList];
    
    if (self.editviewType == UserEdittingTypeAge) {
        [self buildDatePicker];
    }
}

- (void)buildDatePicker{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, Screen_width - 50*ScreenRatio, 200*ScreenRatio)];
    datePicker.center = CGPointMake(Screen_width/2, Screen_height - 250*ScreenRatio/2 - 10*ScreenRatio);
    
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
    [self.view addSubview:datePicker];
}

#pragma mark - UIDatePicker
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    if (self.editviewType == UserEdittingTypeSchool) {
        self.birthday = datePicker.date;
        return ;
    }
    self.birthday = datePicker.date;
    
    [self getAgeWith:self.birthday];
    [self getConstellationFromBirthday:self.birthday];
}


//根据生日得到年龄
- (void)getAgeWith:(NSDate*)birthday{
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:birthday toDate:[NSDate  date] options:0];
    
    EdittingBaseViewCell *cell = [userList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailLabel.text = [NSString stringWithFormat:@"%ld",[components year]];
    self.selectContent = cell.detailLabel.text;
}
//根据生日得到星座
- (void)getConstellationFromBirthday:(NSDate*)birthday{
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [myCal components:NSCalendarUnitMonth| NSCalendarUnitDay fromDate:birthday];
    NSInteger month = [comp1 month];
    NSInteger day = [comp1 day];
    EdittingBaseViewCell *cell = [userList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailLabel.text = [self getAstroWithMonth:month day:day];
    self.constellation = cell.detailLabel.text;

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.editviewType == UserEdittingTypeFrom ? 2 :1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.editviewType == UserEdittingTypeFrom) {
        return section == 0 ? 1 : self.rowsNum;
    }
    return self.rowsNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 39*ScreenRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editviewType == UserEdittingTypeFrom) {
        if (indexPath.section == 0) {
            CreateMyselfCell *selfcell = [tableView dequeueReusableCellWithIdentifier:@"MyselfCell"];
            if (!selfcell) {
                selfcell = [[CreateMyselfCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyselfCell"];
            }
            return selfcell;
        }
    }
    if (self.editviewType == UserEdittingTypeSchool) {
        if (indexPath.row == 0) {
            SchoolMsgViewCell *schoolcell = [tableView dequeueReusableCellWithIdentifier:@"School"];
            if (!schoolcell) {
                schoolcell = [[SchoolMsgViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"School"];
            }
            return schoolcell;
        }else{
            NSString *identi = [NSString stringWithFormat:@"EditCell%ld",indexPath.row];
            EdittingBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
            if (!cell) {
                cell = [[EdittingBaseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.titleLabel.text = self.dataArray[indexPath.row];

            return cell;
        }
    }
    
    NSString *identi = [NSString stringWithFormat:@"EditCell%ld",indexPath.row];
    EdittingBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[EdittingBaseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        if (self.editviewType == UserEdittingTypeFrom ) {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    cell.titleLabel.text = self.dataArray[indexPath.row];
    if (self.rowStr == self.dataArray[indexPath.row]) {
        cell.isSelected = YES;
        currentCell = cell;
    }
    if (self.editviewType == UserEdittingTypeAge) {
        cell.markImg.hidden = YES;
        cell.detailLabel.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editviewType == UserEdittingTypeAge) {
        return ;
    }

    if (self.editviewType == UserEdittingTypeSchool) {
        if (indexPath.row == 1) {
            [self.view endEditing:YES];
            [self buildDatePicker];
            return ;
        }else{
            
            return ;
        }
    }
    if (self.editviewType == UserEdittingTypeFrom) {
        if (indexPath.section == 0) {
            // 创建自己标签
            UserNameController *userEdit = [[UserNameController alloc]init];
            userEdit.comeFrom = @"来自";
            userEdit.rowIndex = 5;
            userEdit.userSettingVC = self.userSettingVC;
            [self.navigationController pushViewController:userEdit animated:YES];
            return ;
        }else{
            if (indexPath.row == 0) {
                // 跳到中国
                ProvinceViewController *province = [[ProvinceViewController alloc]init];
                province.userSettingVC = self.userSettingVC;
                province.rowStr = self.rowStr;
                [self.navigationController pushViewController:province animated:YES];
                return ;
            }
        }
    }
    EdittingBaseViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectContent = self.dataArray[indexPath.row];
    self.rowIndex = indexPath.row;
    if (currentCell == cell) {
        cell.isSelected = YES;
    }else{
        self.rowStr = self.dataArray[indexPath.row];
        currentCell.isSelected = NO;
        cell.isSelected = YES;
        currentCell = cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.editviewType == UserEdittingTypeFrom) {
        return section == 0 ? 10*ScreenRatio : 0;
    }
    return 0;
}

#pragma mark - 保存用户信息
- (void)saveUserMsg:(UIButton *)save{
    if (self.userSettingVC) {
        if (self.editviewType == UserEdittingTypeSchool) {
            self.dataIndex = 8;
            SchoolMsgViewCell *cell = [userList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if (cell.addschool.text && cell.addschool.text.length > 0) {
                self.selectContent = cell.addschool.text;
            }else{
                [self showAlertViewTitle:@"请添加学校信息" message:nil];
                return ;
            }
        }
        if (self.selectContent) {
            [self.userSettingVC.dataArray replaceObjectAtIndex:self.dataIndex withObject:self.selectContent];
            self.userSettingVC.constellation = self.constellation;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            self.userSettingVC.birthday = [dateFormatter stringFromDate:self.birthday];
        }
        
        [self.userSettingVC.userList reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.matchSettingVC.gender = self.selectContent;
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}


@end
