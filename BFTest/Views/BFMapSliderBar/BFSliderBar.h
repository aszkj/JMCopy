//
//  BFSliderBar.h
//  BFTest
//
//  Created by 伯符 on 16/6/16.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFSliderBar : UIControl

-(id) initWithFrame:(CGRect) frame Titles:(NSArray *) titles;

-(void) setSelectedIndex:(int)index;

-(void) setTitlesFont:(UIFont *)font;

@property(nonatomic, strong) UIButton *handlerBtn;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, strong) UIColor *TopTitlesColor;
@property(nonatomic, assign) int SelectedIndex;

@end
