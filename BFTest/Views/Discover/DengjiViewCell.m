//
//  DengjiViewCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "DengjiViewCell.h"
@interface DengjiViewCell (){
    CAShapeLayer *progressLayer;
    CAShapeLayer *progressLayer2;

    UIView *vipCircle;
    UIView *activeCircle;
    UILabel *gradeLabel1;
    UILabel *gradeLabel2;
}
@end
@implementation DengjiViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *grade = [[UILabel alloc]initWithFrame:CGRectMake(UserCellMargin, 15, 80, 20)];
        grade.text = @"账号等级";
        grade.textAlignment = NSTextAlignmentLeft;
        grade.textColor = [UIColor blackColor];
        grade.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:grade];
        
        activeCircle = [[UIView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(grade.frame)+15, 46*ScreenRatio, 46*ScreenRatio)];
        activeCircle.backgroundColor = [UIColor blackColor];
        activeCircle.layer.cornerRadius = 23*ScreenRatio;
        activeCircle.layer.masksToBounds = YES;
        [self.contentView addSubview:activeCircle];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 46*ScreenRatio, 46*ScreenRatio)];
        label1.backgroundColor = [UIColor clearColor];
        label1.center = activeCircle.center;
        label1.text = @"活跃型";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:label1];
        
        gradeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70*ScreenRatio, 20*ScreenRatio)];
        gradeLabel1.center = CGPointMake(CGRectGetMaxX(label1.frame)+20 + 23*ScreenRatio, activeCircle.center.y);
        gradeLabel1.backgroundColor = [UIColor clearColor];
        gradeLabel1.textAlignment = NSTextAlignmentLeft;
        gradeLabel1.textColor = [UIColor lightGrayColor];
        gradeLabel1.font = BFFontOfSize(16);
        [self.contentView addSubview:gradeLabel1];
        
        UIView *verticleLine = [[UIView alloc]initWithFrame:CGRectMake(Screen_width/2, CGRectGetMaxY(grade.frame)+15, 1, 46*ScreenRatio)];
        verticleLine.backgroundColor = BFColor(243, 243, 242, 1);
        [self.contentView addSubview:verticleLine];
        
        vipCircle = [[UIView alloc]initWithFrame:CGRectMake(Screen_width/2 + 45*ScreenRatio, CGRectGetMaxY(grade.frame)+15, 46*ScreenRatio, 46*ScreenRatio)];
        vipCircle.backgroundColor = BFColor(248, 212, 48, 1);
        vipCircle.layer.cornerRadius = 23*ScreenRatio;
        vipCircle.layer.masksToBounds = YES;
        [self.contentView addSubview:vipCircle];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 46*ScreenRatio, 46*ScreenRatio)];
        label2.backgroundColor = [UIColor clearColor];
        label2.center = vipCircle.center;
        label2.text = @"VIP";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor blackColor];
        label2.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:label2];
        
        gradeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70*ScreenRatio, 20*ScreenRatio)];
        gradeLabel2.center = CGPointMake(CGRectGetMaxX(label2.frame)+20 + 23*ScreenRatio, vipCircle.center.y);
        gradeLabel2.backgroundColor = [UIColor clearColor];
        gradeLabel2.textAlignment = NSTextAlignmentLeft;
        gradeLabel2.textColor = [UIColor lightGrayColor];
        gradeLabel2.font = BFFontOfSize(16);
        [self.contentView addSubview:gradeLabel2];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    gradeLabel1.text = [NSString stringWithFormat:@"等级:%@",dic[@"grade"]];
    gradeLabel2.text = [NSString stringWithFormat:@"VIP:%@",dic[@"vip"]];

    progressLayer = [CAShapeLayer layer];
    progressLayer.fillColor = nil;
    progressLayer.strokeColor = BFColor(248, 212, 48, 1).CGColor;
    progressLayer.lineWidth = 2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(activeCircle.center.x,
                                                             activeCircle.center.y)
                                          radius:activeCircle.width / 2 - 3
                                      startAngle:-M_PI_2
                                        endAngle:-M_PI_2 + M_PI *2
                                       clockwise:YES];
    progressLayer.path = path.CGPath;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:[dic[@"grade_value"] floatValue]];
    animation.duration = 0.5;
    progressLayer.strokeEnd = [dic[@"grade_value"] floatValue];
    [progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    [self.contentView.layer addSublayer:progressLayer];
    
    progressLayer2 = [CAShapeLayer layer];
    progressLayer2.fillColor = nil;
    progressLayer2.strokeColor = [UIColor blackColor].CGColor;
    progressLayer2.lineWidth = 2;
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(vipCircle.center.x,
                                                             vipCircle.center.y)
                                          radius:vipCircle.width / 2 - 3
                                      startAngle:-M_PI_2
                                        endAngle:-M_PI_2 + M_PI *2
                                       clockwise:YES];
    progressLayer2.path = path2.CGPath;
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:[dic[@"grade_vip"] floatValue]];
    animation.duration = 0.5;
    progressLayer2.strokeEnd = [dic[@"grade_vip"] floatValue];
    [progressLayer2 addAnimation:animation forKey:@"strokeEndAnimation"];
    [self.contentView.layer addSublayer:progressLayer2];

}

+ (NSInteger)getGradeCellHeight{
    return 110*ScreenRatio;
}

@end
