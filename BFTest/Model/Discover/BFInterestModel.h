//
//  BFInterestModel.h
//  BFTest
//
//  Created by 伯符 on 16/7/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFInterestModel : NSObject

@property (nonatomic, copy) NSString *dtnum;
@property (nonatomic, copy) NSString *jmid;
@property (nonatomic, copy) NSString *nid;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) NSMutableArray *comments;

@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *publish_datetime;
@property (nonatomic, copy) NSString *resource;
@property (nonatomic, copy) NSString *location;
@property (nonatomic,assign) BOOL is_zan;
@property (nonatomic, assign) NSInteger zan;
@property (nonatomic, assign) NSInteger comments_num;
@property (nonatomic,copy) NSString *fromPlace;

@property (nonatomic,copy) NSString *video_index;

@property (nonatomic,copy) NSString *thumbnail;

@property (nonatomic,strong) NSMutableArray *comtArray;

- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;

@end

@interface BFCommentModel : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *publish_datetime;
@property (nonatomic, copy) NSString *reply_user;
@property (nonatomic, copy) NSString *reply_user_jmid;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *comment_user;
@property (nonatomic, copy) NSString *jmid;
@property (nonatomic, copy) NSString *reply_user_nikename;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *comments_num;


- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;
@end


@interface BFFansModel : NSObject

@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *jmid;
@property (nonatomic, copy) NSString *lasttime;
@property (nonatomic, copy) NSString *mybmp;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *otherbmp;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *vip;
@property (nonatomic, copy) NSString *years;


- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;
@end

@interface BFDtAlertModel : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *publish_datetime;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *nid;


- (instancetype)initModelWithDic:(NSDictionary *)dic;

+ (instancetype)configureModelWithDic:(NSDictionary *)dic;
@end

