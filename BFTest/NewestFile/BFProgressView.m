//
//  BFProgressView.m
//  编辑头像模块
//
//  Created by JM on 2017/4/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BFProgressView.h"

@implementation BFProgressView


- (void)drawRect:(CGRect)rect {
//    self.lineWidth = 3.0;
    self.offsetInside = 1.5;
    
    
    [self.lineColor set]; //设置线条颜色
    
    CGPoint center = CGPointMake(rect.size.width/2 + rect.origin.x, rect.size.height/2 + rect.origin.y);
    CGFloat radius = MIN(rect.size.width/2,rect.size.height/2)-self.lineWidth/2-self.offsetInside;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + self.progress * (M_PI + M_PI) ;
    
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    aPath.lineWidth = self.lineWidth;
    
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath stroke];//Draws line 根据坐标点连线
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
    
}


@end
