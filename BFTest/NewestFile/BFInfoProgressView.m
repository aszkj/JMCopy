//
//  BFInfoProgressView.m
//  BFTest
//
//  Created by JM on 2017/4/15.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFInfoProgressView.h"
@interface BFInfoProgressView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@end
@implementation BFInfoProgressView

-(void)setProgress:(CGFloat)progress{
//    int i = progress * 10;
    int i = progress * 9;
     NSString *progressStr = nil;
    if(i == 0){
        progressStr = [NSString stringWithFormat:@"%zd%%",i];
    }else{
//        progressStr = [NSString stringWithFormat:@"%zd0%%",i];
        progressStr = [NSString stringWithFormat:@"%zd%%",(int)((i/9.0)*100)];
    }
    NSLog(@"thread ----- %@",[NSThread currentThread]);
    self.percentLabel.text = progressStr;
    self.heightConstraint.constant = 60 - (60.f/9)*i;
}

@end
