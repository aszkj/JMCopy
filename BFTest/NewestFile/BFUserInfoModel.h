//
//  BFUserInfoModel.h
//  BFTest
//
//  Created by JM on 2017/4/5.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 address = "<null>";
 age = "<null>";
 beLiked = "<null>";
 bigPhoto = "<null>";   ————————————————————————————————————————————————
 birthday = "<null>";
 createTime = "<null>";
 datePlace = "<null>";
 email = "<null>";
 fans = "<null>";
 follow = "<null>";
 fromArea = "<null>";
 grade = 1;
 haunt = "<null>";
 industry = "<null>";
 interest = "<null>";
 jmid = 346951572992;
 listUserPhotos =     (
 );
 loginName = CF26694452A1EFDA666C6DF68E736D70qq;
 name = "~";
 occupation = "<null>";
 phone = 18948727721;
 photo = "http://q.qlogo.cn/qqapp/1105534094/568180891D2161424C497D057F9BFE80/100";
 school = "<null>";
 sex = 1;
 signature = "<null>";
 single = "<null>";
 userType = 1;
 zodiac = "<null>";
 */

@interface BFUserInfoModel : NSObject

@property (nonatomic,copy)NSString *address;        //来自
@property (nonatomic,copy)NSString *age;            //年龄
@property (nonatomic,copy)NSString *beLiked;        //被喜欢
@property (nonatomic,copy)NSString *bigPhoto;       //？？？
@property (nonatomic,copy)NSString *birthday;       //生日
@property (nonatomic,copy)NSString *createTime;     //创建时间？
@property (nonatomic,copy)NSString *datePlace;      //约会地点
@property (nonatomic,copy)NSString *distance;       //用户之间的距离
@property (nonatomic,copy)NSString *email;          //邮件
@property (nonatomic,copy)NSString *fans;           //粉丝数量
@property (nonatomic,copy)NSString *follow;         //关注数量
@property (nonatomic,copy)NSString *fromArea;       //？？？
@property (nonatomic,copy)NSString *grade;          //等级
@property (nonatomic,copy)NSString *gradeType;      //等级类型
@property (nonatomic,copy)NSString *haunt;          //常出没地点
@property (nonatomic,copy)NSString *industry;       //行业
@property (nonatomic,copy)NSString *interest;       //兴趣爱好
@property (nonatomic,copy)NSString *jmid;           //jmid账号
@property (nonatomic,copy)NSString *lastOnlineTime; //最后在线时间
@property (nonatomic,copy)NSArray <NSString *>*listUserPhotos;//用户图片数组
@property (nonatomic,copy)NSString *loginName;      //登录名
@property (nonatomic,copy)NSString *name;           //用户昵称
@property (nonatomic,copy)NSString *occupation;     //用户职业
@property (nonatomic,copy)NSString *phone;          //用户手机号
@property (nonatomic,copy)NSString *photo;          //用户头像
@property (nonatomic,copy)NSString *school;         //毕业院校
@property (nonatomic,copy)NSString *sex;            //性别
@property (nonatomic,copy)NSString *signature;      //用户签名
@property (nonatomic,copy)NSString *single;         //是否单身
@property (nonatomic,copy)NSString *stranger;       //是否是陌生人
@property (nonatomic,copy)NSString *upGradePercent; //用户待升级经验的百分比
@property (nonatomic,copy)NSString *zodiac;         //星座
@property (nonatomic,copy)NSString *userJmCode;     //用户近脉号
@property (nonatomic,copy)NSString *opTime;         //拉黑时间
@property (nonatomic,strong)NSArray <NSString *>*activityPhotos;
@property (nonatomic,copy)NSDictionary *relations;         //用户关系


//@property (nonatomic,copy)NSString *userType;       //用户类型 机器人？
@property (nonatomic,copy)NSString *vipGrade;
@property (nonatomic,copy)NSString *getmoney;
@property (nonatomic,copy)NSString *sendmoney;


@property (nonatomic,copy)NSArray<NSString *>*tagLabelStrArr;
@end
