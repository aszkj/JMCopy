//
//  BFClusterAnnotationView.m
//  BFTest
//
//  Created by 伯符 on 16/8/8.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFClusterAnnotationView.h"
@interface BFClusterAnnotationView(){
    UIImageView *iconImg;
//    UIButton *iconPro;
}
@end
@implementation BFClusterAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.image = [UIImage imageNamed:@"mapnumbc"];
        self.centerOffset = CGPointMake(0, -kAnnoView_Height/2);
        
        iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAnnoView_Width - 5*ScreenRatio, kAnnoView_Width - 5*ScreenRatio)];
        iconImg.center = CGPointMake(kAnnoView_Width / 2, (kAnnoView_Width/2)+0.9*ScreenRatio);
        iconImg.layer.cornerRadius = (kAnnoView_Width - 5*ScreenRatio)/ 2;
        iconImg.layer.masksToBounds = YES;
        [self addSubview:iconImg];
//
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kAnnoView_Width, kAnnoView_Width)];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont boldSystemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        self.alpha = 0.85;
    }
    return self;
}

- (void)setSize:(NSInteger)size{
    _size = size;
    if (_size == 1) {
        
        
        if(self.isShop){
            self.image = [UIImage imageNamed:@"sellerback"];
        }else{
            if([self.sex isEqualToString:@"1"]){
                self.image = [UIImage imageNamed:@"mapnumbc_1"];
            }else if([self.sex isEqualToString:@"0"]){
                self.image = [UIImage imageNamed:@"mapnumbc_0"];
            }else{
                self.image = [UIImage imageNamed:@"mapnumbc"];
            }
        }
        
        if (self.isShop) {
            self.frame = CGRectMake(0, 0, kAnnoView_Width, kAnnoView_Width);
            iconImg.frame = CGRectMake(0, 0, kAnnoView_Width-3*ScreenRatio, kAnnoView_Width-3*ScreenRatio);
            iconImg.center = self.center;
             self.centerOffset = CGPointMake(0, 0);
        }else{
            self.frame = CGRectMake(0, 0, kAnnoView_Width, kAnnoView_Height);
            iconImg.frame = CGRectMake(0, 0, kAnnoView_Width - 5*ScreenRatio, kAnnoView_Width - 5*ScreenRatio);
            iconImg.center = CGPointMake(kAnnoView_Width / 2, (kAnnoView_Width/2)+0.9*ScreenRatio);
             self.centerOffset = CGPointMake(0, -kAnnoView_Height/2);

        }
        NSLog(@"%@",self.imgStr);
        iconImg.hidden = NO;
        self.label.hidden = YES;
        [iconImg sd_setImageWithURL:[NSURL URLWithString:self.imgStr] placeholderImage:nil];

        
        return ;
    }else{
        self.image = [UIImage imageNamed:@"mapnumbc"];
        self.centerOffset = CGPointMake(0, -(kAnnoView_Height/2));
    }
// 不要问我这两个数是怎么来的  我不知道 我是反推算出来的
    float r = kResolution == 3 ? 0.775:0.836;
    self.label.frame = CGRectMake(0, 0, kAnnoView_Width*r, kAnnoView_Width*r);
    iconImg.hidden = YES;
    self.label.hidden = NO;
    self.label.text = [NSString stringWithFormat:@"%ld",size];
}

@end
