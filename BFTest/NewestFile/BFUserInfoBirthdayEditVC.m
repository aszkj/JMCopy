//
//  BFUserInfoBirthdayEditVC.m
//  BFTest
//
//  Created by JM on 2017/4/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserInfoBirthdayEditVC.h"

@interface BFUserInfoBirthdayEditVC ()

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *constellationLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong)NSDate *birthday;
@property (nonatomic,copy)NSString *birthdayStr;

@end

@implementation BFUserInfoBirthdayEditVC
- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDatePicker];
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
- (void)viewWillDisappear:(BOOL)animated{
    if(self.birthdayStr.length < 1){
        self.birthdayStr = self.model.birthday;
    }else{
        self.callBack(self.birthdayStr);
        self.model.age = self.ageLabel.text;
    }
}

#pragma mark - UIDatePicker
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    self.birthday = datePicker.date;
    [self getAgeWith:datePicker.date];
    [self getConstellationFromBirthday:self.birthday];
}


//根据生日得到年龄
- (void)getAgeWith:(NSDate*)birthday{
    //日历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:birthday toDate:[NSDate  date] options:0];
    
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",[components year]];
}
//根据生日date得到星座和生日 str
- (void)getConstellationFromBirthday:(NSDate*)birthday{
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [myCal components:NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitYear fromDate:birthday];
    NSInteger year = [comp1 year];
    NSInteger month = [comp1 month];
    NSInteger day = [comp1 day];
   
    self.birthdayStr = [NSString stringWithFormat:@"%zd-%zd-%zd",year,month,day];
    self.constellationLabel.text = [self getAstroWithMonth:month day:day];
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
