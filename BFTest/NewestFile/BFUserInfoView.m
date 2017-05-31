//
//  BFUserInfoView.m
//  BFTest
//
//  Created by JM on 2017/4/6.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserInfoView.h"
#import "SDCycleScrollView.h"
#import "BFProgressView.h"
#import "UserDTViewController.h"
#import "BFNetRequest.h"
#import "BFFriMediaClusterController.h"


@interface BFUserInfoView()
{
    double _personalInfoLabelHeight;
    double _personalInfoLabelTopOffset;
    double _dynamicHeight;
    double _datePlaceHeight;
    double _tagViewHeight;
    double _likeNumViewHeight;
    
}
/*---- 轮播器  -----*/
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
/*---- 对应控件中的属性  -----*/
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;


@property (weak, nonatomic) IBOutlet UILabel *singleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumsLabel;

@property (weak, nonatomic) IBOutlet UILabel *dynamicNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dynamicPic_01;
@property (weak, nonatomic) IBOutlet UIImageView *dynamicPic_02;
@property (weak, nonatomic) IBOutlet UIImageView *dynamicPic_03;
@property (weak, nonatomic) IBOutlet UIImageView *dynamicPic_04;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zodiacLabel;

@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;


@property (weak, nonatomic) IBOutlet UILabel *fromAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePlaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag_01Label;
@property (weak, nonatomic) IBOutlet UILabel *tag_02Label;
@property (weak, nonatomic) IBOutlet UILabel *tag_03Label;
@property (weak, nonatomic) IBOutlet UILabel *tag_04Label;
@property (weak, nonatomic) IBOutlet UILabel *tag_05Label;
@property (weak, nonatomic) IBOutlet UILabel *tag_06Label;
@property (weak, nonatomic) IBOutlet UILabel *tag_07Label;
@property (weak, nonatomic) IBOutlet UILabel *tag_08Label;

@property (weak, nonatomic) IBOutlet UILabel *jmidLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (weak, nonatomic) IBOutlet BFProgressView *gradeProgressView;
@property (weak, nonatomic) IBOutlet BFProgressView *VIPProgressView;

/*---- 需要根据model内容调整是否显示个人信息中控件的约束  -----*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *singleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *singleLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signatureTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signatureHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *industryLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *industryLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *occupationLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *occupationLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schoolLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schoolLabelHeightConstraint;
/*---- 控制是否显示自我介绍的约束-----*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signatrueViewHeightContraint;
/*---- 控制标签显示行数的约束  -----*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;

/*---- 控制是否显示已发布动态UI的约束  -----*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicViewLeadingConstraint;

/*---- 记录动态dynamicView（添加点按手势）  -----*/
@property (weak, nonatomic) IBOutlet UIView *dynamicView;
@property (weak, nonatomic) IBOutlet UILabel *tagReminderLabel;

/*---- 保存动态ImageView的数组  -----*/
@property (nonatomic,strong)NSArray<UIImageView *>* dynamicImageViewArr;
@property (nonatomic,strong)NSArray<UILabel *>*tagLabelArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicHeightConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicBottomSpaceConstaint;
/*---- 控制是否显示喜欢的人数的约束  -----*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeNumViewHeightConstraint;

/*---- 控制是否显示约会地点的约束  -----*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePlaceViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePlaceViewTopSpaceConstraint;

/*---- 动态手势在点按之后 延时后才能点按  -----*/
@property (nonatomic,assign) BOOL isNotBeTouch;

@end



@implementation BFUserInfoView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
- (void)dynamicViewTapAction:(UITapGestureRecognizer *)sender {
    
    
    if(self.isNotBeTouch == YES){
        return;
    }
    
    self.isNotBeTouch = YES;
    //两秒钟内点按失效
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isNotBeTouch = NO;
    });
    
    UIViewController *selfVC = (UIViewController *)self.nextResponder;
    
    if([[BFUserLoginManager shardManager].jmId isEqualToString: self.model.jmid]){
        BFFriMediaClusterController *clustervc = [[BFFriMediaClusterController alloc]init];
        //如果当前导航控制器的顶部控制器已经是动态控制器 则直接跳出 避免重复入栈
        if([clustervc isKindOfClass:[selfVC.navigationController.topViewController class]]){
            return ;
        }
        [selfVC.navigationController pushViewController:clustervc animated:YES];
        return;
    }
    
#warning 这里跳BFTest - 3043 Group转到动态控制器
    
    NSString *url = [NSString stringWithFormat:@"%@/news/",DongTai_URL];
    NSDictionary *para;
    
    
    para = @{@"uid":self.model.jmid,@"token":@"",@"page_item_pos":@0,@"action":@"D"};
    [BFNetRequest getWithURLString:url parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            
            NSDictionary *contentDic = dic[@"content"];
            UserDTViewController *userdt = [[UserDTViewController alloc]init];
            userdt.userDic = contentDic[@"head"];
            userdt.useruid = self.model.jmid;
            userdt.isSelf = [[BFUserLoginManager shardManager].jmId isEqualToString:self.model.jmid];
            userdt.hidesBottomBarWhenPushed = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //如果当前导航控制器的顶部控制器已经是动态控制器 则直接跳出 避免重复入栈
                if([userdt isKindOfClass:[selfVC.navigationController.topViewController class]]){
                    return ;
                }
                [selfVC.navigationController pushViewController:userdt animated:YES];
            });
            
        }
    }failure:^(NSError *error) {
        
    }];
}
/**
 初始化各个控件
 */
- (void)setupUI{
    
    
    //记录需要隐藏的控件的初始高度
    [self recordViewHeight];
    
    //setNillModel
    [self setNilMode];
    
    //初始化轮播器
    [self setup_CycleScrollView];
    
    //初始化动态的点击事件
    [self setupDynamicViewTapGuesture];
    
    [self setupProgressView];
    
    
}


- (void)setupProgressView{
    self.gradeProgressView.lineColor = [UIColor blackColor];
    self.VIPProgressView.lineColor = [UIColor whiteColor];
    self.gradeProgressView.lineWidth = 2;
    self.gradeProgressView.lineWidth = 2;
}

- (void)setupDynamicViewTapGuesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dynamicViewTapAction:)];
    [self.dynamicView addGestureRecognizer:tap];
}

/**
 初始化轮播器
 */
- (void)setup_CycleScrollView{
    self.cycleScrollView.imageURLStringsGroup = self.model.listUserPhotos;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.showPageControl = YES;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
}

/**
 记录控件的原始高度
 */
- (void)recordViewHeight{
    
    _personalInfoLabelHeight = self.singleLabelHeightConstraint.constant;
    _personalInfoLabelTopOffset = self.singleLabelTopConstraint.constant;
    _dynamicHeight = self.dynamicHeightConstaint.constant;
    _datePlaceHeight = self.datePlaceViewHeightConstraint.constant;
    
    _tagViewHeight = self.tagViewHeightConstraint.constant;
    _likeNumViewHeight = self.likeNumViewHeightConstraint.constant;
}

#pragma mark - 设置控件是否隐藏

- (void)hideSingleLabe:(BOOL)trueOrFalse{
    self.singleLabelTopConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelTopOffset;
    self.singleLabelHeightConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelHeight;
}
- (void)hideSignatureLabe:(BOOL)trueOrFalse{
    self.signatureTopConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelTopOffset;
    self.signatureHeightConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelHeight;
}

- (void)hideAddressLabe:(BOOL)trueOrFalse{
    self.addressLabelTopConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelTopOffset;
    self.addressLabelHeightConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelHeight;
}

- (void)hideIndustryLabe:(BOOL)trueOrFalse{
    self.industryLabelTopConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelTopOffset;
    self.industryLabelHeightConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelHeight;
    
}
- (void)hideOccupationLabe:(BOOL)trueOrFalse{
    self.occupationLabelTopConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelTopOffset;
    self.occupationLabelHeightConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelHeight;
}

- (void)hideSchoolLabe:(BOOL)trueOrFalse{
    self.schoolLabelTopConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelTopOffset;
    self.schoolLabelHeightConstraint.constant = trueOrFalse ? 0 : _personalInfoLabelHeight;
}


//是否隐藏引导发布第一条动态的界面
- (void)hideDynamicAddSignView:(BOOL)trueOrFalse{
    
    self.dynamicViewLeadingConstraint.constant = trueOrFalse ? 0 : -self.bounds.size.width;
}

- (void)hideDynamicView:(BOOL)trueOrFalse{
    self.dynamicHeightConstaint.constant = trueOrFalse ? 0 : _dynamicHeight;
    self.dynamicBottomSpaceConstaint.constant = trueOrFalse ? 0 : 5;
    
}
- (void)hideDatePlaceView:(BOOL)trueOrFalse{
    self.datePlaceViewHeightConstraint.constant = trueOrFalse ? 0 : _datePlaceHeight;
    self.datePlaceViewTopSpaceConstraint.constant = trueOrFalse ? 0 : 5;
    
}


- (void)hideSignatureView:(BOOL)trueOrFalse{
    self.signatrueViewHeightContraint.constant = trueOrFalse ? 0 : 300;
}


- (void)hideLikeNumView:(BOOL)trueOrFalse{
    self.likeNumViewHeightConstraint.constant = trueOrFalse ? 0 : _likeNumViewHeight;

}
/**
 根据传入的用户模型信息设置各个控件是否显示
 */
- (void)setViewHeightWithModel:(BFUserInfoModel *)model{
    //判断当前用户不是自己
    [self hideDynamicView:[model.jmid isEqualToString:[BFUserLoginManager shardManager].jmId] || model.activityPhotos.count != 0?NO:YES];
    [self hideSingleLabe:model.single ? NO : YES];
    [self hideSignatureLabe:model.signature ? YES : YES];//因为产品改了需求 个人签名页面单独作为一个栏目独立出来
    [self hideAddressLabe:([model.fromArea isEqualToString:@""]||model.fromArea == nil) ? YES : NO];
    [self hideSingleLabe:model.single ? YES : YES];//因为上面有提示是否单身的状态栏 这里始终隐藏
    [self hideIndustryLabe:![model.industry isEqualToString:@""] && model.industry ? NO : YES];
    [self hideOccupationLabe:![model.occupation isEqualToString:@""] && model.occupation ? NO : YES];
    [self hideSchoolLabe:![model.school isEqualToString:@""] && model.school ? NO : YES];
    [self hideDynamicAddSignView:model.activityPhotos.count == 0 ? NO : YES];
    [self hideSignatureView:((model.signature == nil )||([model.signature isEqualToString:@""]))&&![model.jmid isEqualToString:[BFUserLoginManager shardManager].jmId] ? YES : NO];//该需求现在为 如果是查看别的用户信息时 并且对应用户签名为空时设置隐藏
    [self hideDatePlaceView:((model.datePlace == nil )||([model.datePlace isEqualToString:@""]))&&![model.jmid isEqualToString:[BFUserLoginManager shardManager].jmId] ? YES : NO];//该需求现在为 如果是查看别的用户信息时 并且对应用户签名为空时设置隐藏
    [self hideLikeNumView:![model.jmid isEqualToString:[BFUserLoginManager shardManager].jmId] ? YES : NO];//如果查看自己则显示 别人则不显示
}
- (void)setNilMode{
    //赋值一个空的模型 初始化各个控件
    BFUserInfoModel *model = [[BFUserInfoModel alloc]init];
    self.model = model;
}



/**
 重写Model的set方法
 */
- (void)setModel:(BFUserInfoModel *)model{
    
    _model = model;
    
    
    //设置相关控件的高度
    [self setViewHeightWithModel:model];
    
    //设置性别 以及性别对应的图标
    self.sexLabel.text = model.age;
    if(model.sex){
        //进行非空判断 防止崩溃
        self.sexImageView.image = [UIImage imageNamed:[@"sex" stringByAppendingString:model.sex]];
    }
    //
    NSString *selfJmid = [BFUserLoginManager shardManager].jmId;
    self.singleLabel.text = [model.single isEqualToString:@"保密"]?nil:model.single;
    self.distanceLabel.text = [model.jmid isEqualToString:selfJmid] ? @"0.0km" :model.distance;
    self.timeStampLabel.text = [model.jmid isEqualToString:selfJmid] ? @"1分钟前" : model.lastOnlineTime;
    self.likeNumsLabel.text = model.beLiked == nil ? @"0" : model.beLiked;
    self.followNumsLabel.text = model.follow == nil ? @"0" : model.follow;
    self.fansNumsLabel.text = model.fans ==nil ? @"0" : model.fans;
    self.gradeLabel.text = model.grade;
    self.vipGradeLabel.text = model.vipGrade?model.vipGrade:@"0";
    self.gradeProgressView.progress = model.upGradePercent.floatValue;
    
    [self setDynamicPicturesWithPicURLArr:model.activityPhotos];
    
    self.dynamicNumLabel.text = model.activityPhotos.count == 0 ? @"0":@(model.activityPhotos.count).stringValue;
    self.userTypeLabel.text = model.gradeType.intValue == 1 ?@"活跃型":model.gradeType.intValue == 2?@"财富型":@"魅力型";
    self.zodiacLabel.text = model.zodiac;
    self.signatureLabel.text = (model.signature == nil) || [model.signature isEqualToString:@""] ?@"请做一个简单的自我介绍~" : model.signature  ;
    self.fromAreaLabel.text = model.fromArea;
    self.industryLabel.text = model.industry;
    self.occupationLabel.text = model.occupation;
    self.schoolLabel.text = model.school;
    self.datePlaceLabel.text = (model.datePlace == nil) || [model.datePlace isEqualToString:@""] ?@"请选择你最喜欢的约会地点，让其他人更好的了解你~" : model.datePlace  ;
#warning 这里需要后期后台传参数过来
    [self setTagLabelsWithLabelStrArr:model.tagLabelStrArr];
    
    
    self.jmidLabel.text = model.userJmCode;
    self.createTimeLabel.text = model.createTime;
    
    //给控制器导航栏title重新设值
    UIViewController *vc = (UIViewController *)self.nextResponder;
    vc.title = model.name;
    
    //给轮播器设置图片
    
    self.cycleScrollView.imageURLStringsGroup = model.listUserPhotos;
    [self setup_CycleScrollView];
    
    
}

/**
 设置tagView
 */
- (void)setTagLabelsWithLabelStrArr:(NSArray<NSString *>*)strArr{
#warning 这里测试标签栏
    strArr = @[@"文艺",@"话唠",@"工作狂",@"要有多长啊",@"how about english",@"中二",@"工作狂",@"English"];
    
    //先把所有标签隐藏
    for(UILabel *label in self.tagLabelArr){
        label.text = nil;
        label.superview.hidden = YES;
    }
    //遍历标签设置text 并把有text的标签显示
    for(int i = 0 ; i <strArr.count ;i++){
        UILabel *label = self.tagLabelArr[i];
        label.text = strArr[i];
        label.superview.hidden = NO;
    }
    self.tagReminderLabel.hidden = strArr.count > 0 ? YES : NO ;
    //根据strArr数量显示对应行数
    self.tagViewHeightConstraint.constant = strArr.count > 4 ? _tagViewHeight : _tagViewHeight - 40;
#warning 这里隐藏标签栏
    self.tagViewHeightConstraint.constant = 0;
}

/**
 这里设置dynamicView
 */
- (void)setDynamicPicturesWithPicURLArr:(NSArray<NSString *>*)picUrlStrArr{
    for(int i = 0; i<(picUrlStrArr.count > 4? 4: picUrlStrArr.count);i++){
        [self.dynamicImageViewArr[i] sd_setImageWithURL:[NSURL URLWithString:picUrlStrArr[i]]];
    }
    
}

/**
 懒加载动态图片数组
 */
- (NSArray<UIImageView *> *)dynamicImageViewArr{
    if(!_dynamicImageViewArr){
        _dynamicImageViewArr = @[
                                 _dynamicPic_01,
                                 _dynamicPic_02,
                                 _dynamicPic_03,
                                 _dynamicPic_04
                                 ];
    }
    return _dynamicImageViewArr;
}

/**
 懒加载标签label数组
 */
- (NSArray<UILabel *> *)tagLabelArr{
    if(!_tagLabelArr){
        _tagLabelArr = @[
                         _tag_01Label,
                         _tag_02Label,
                         _tag_03Label,
                         _tag_04Label,
                         _tag_05Label,
                         _tag_06Label,
                         _tag_07Label,
                         _tag_08Label
                         ];
    }
    return _tagLabelArr;
}


@end



