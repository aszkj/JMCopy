//
//  BFSliderBar.m
//  BFTest
//
//  Created by 伯符 on 16/6/16.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFSliderBar.h"

#define LEFT_OFFSET 20
#define RIGHT_OFFSET 20
#define TITLE_SELECTED_DISTANCE 9
#define TITLE_FADE_ALPHA 0.5f
#define TITLE_SHADOW_COLOR [UIColor lightGrayColor]

@interface BFSliderBar (){
    CGPoint diffPoint;
    NSArray *titlesArr;
    float oneSlotSize;
}

@end

@implementation BFSliderBar

- (UIButton *)handlerBtn{
    if (!_handlerBtn) {
        _handlerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handlerBtn setFrame:CGRectMake(LEFT_OFFSET, 8, 30, 30)];
        [_handlerBtn setAdjustsImageWhenHighlighted:NO];
        [_handlerBtn setSelected:YES];
        [_handlerBtn setCenter:CGPointMake(_handlerBtn.center.x-(_handlerBtn.frame.size.width/2.f), self.frame.size.height-24.0f)];
        [_handlerBtn addTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
        [_handlerBtn addTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_handlerBtn addTarget:self action:@selector(TouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
        
        UIImage *image1 = [UIImage imageNamed:@"mapslider"];
        UIImage *image2 = [UIImage imageNamed:@"mapslider"];
        
        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0 ; // 底端盖高度
        CGFloat left = 0; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        
        image1 = [image1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [_handlerBtn setBackgroundImage:image1 forState:UIControlStateNormal];
        [_handlerBtn setBackgroundImage:image2 forState:UIControlStateSelected];
    }
    return _handlerBtn;
}


- (id)initWithFrame:(CGRect)frame Titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        self.layer.cornerRadius = 9;
        self.layer.masksToBounds = YES;
        titlesArr = [[NSArray alloc]initWithArray:titles];
        [self setProgressColor:BFColor(103, 173, 202, 1)];
        [self setTopTitlesColor:BFColor(103, 173, 202, 1)];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ItemSelected:)];
        [self addGestureRecognizer:gest];
        [self addSubview:self.handlerBtn];
        int i;
        NSString *title;
        UILabel *itemLb;
        oneSlotSize = 1.f*(self.frame.size.width-LEFT_OFFSET-RIGHT_OFFSET-1)/(titlesArr.count-1);
        for (i = 0; i < titlesArr.count; i++) {
            title = [titlesArr objectAtIndex:i];
            itemLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, oneSlotSize, 10)];
            itemLb.backgroundColor = [UIColor clearColor];
            [itemLb setText:title];
            [itemLb setFont:[UIFont boldSystemFontOfSize:12]];
            [itemLb setTextColor:[UIColor whiteColor]];
            [itemLb setLineBreakMode:NSLineBreakByTruncatingMiddle];
            [itemLb setAdjustsFontSizeToFitWidth:YES];
            [itemLb setTextAlignment:NSTextAlignmentCenter];
            [itemLb setShadowOffset:CGSizeMake(0, 1)];
            [itemLb setTag:i+50];
            [itemLb setCenter:[self getCenterPointForIndex:i]];
            [self addSubview:itemLb];
        }
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(LEFT_OFFSET, rect.size.height-26.5, rect.size.width-RIGHT_OFFSET-LEFT_OFFSET, 5));
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    CGPoint centerPoint;
    int i;
    
    for (i = 0; i < titlesArr.count; i++) {
        centerPoint = [self getCenterPointForIndex:i];
        CGContextSetFillColorWithColor(context, BFThemeColor.CGColor);
        CGContextSetLineWidth(context, 1.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextAddArc(context, centerPoint.x - 3, rect.size.height-24, 6, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void) TouchDown: (UIButton *) btn withEvent: (UIEvent *) ev{
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(currPoint));
    diffPoint = CGPointMake(currPoint.x - btn.frame.origin.x, currPoint.y - btn.frame.origin.y);
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}


-(void) setTitlesFont:(UIFont *)font{
    int i;
    UILabel *lbl;
    for (i = 0; i < titlesArr.count; i++) {
        lbl = (UILabel *)[self viewWithTag:i+50];
        [lbl setFont:font];
    }
}

-(void) animateTitlesToIndex:(int) index{
    int i;
    UILabel *lbl;
    for (i = 0; i < titlesArr.count; i++) {
        lbl = (UILabel *)[self viewWithTag:i+50];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (i == index) {
            //选中时label颜色
            [lbl setCenter:CGPointMake(lbl.center.x, self.frame.size.height-41-TITLE_SELECTED_DISTANCE)];
            [lbl setTextColor: self.TopTitlesColor];
            [lbl setAlpha:1];
        }else{
            //未选中时label颜色
            [lbl setCenter:CGPointMake(lbl.center.x, self.frame.size.height-45)];
            [lbl setTextColor:[UIColor whiteColor]];
            [lbl setAlpha:1];
        }
        [UIView commitAnimations];
    }
}

-(void) animateHandlerToIndex:(int) index{
    CGPoint toPoint = [self getCenterPointForIndex:index];
    toPoint = CGPointMake(toPoint.x-(self.handlerBtn.frame.size.width/2.f), self.handlerBtn.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint];
    
    [UIView beginAnimations:nil context:nil];
    [self.handlerBtn setFrame:CGRectMake(toPoint.x, toPoint.y, self.handlerBtn.frame.size.width, self.handlerBtn.frame.size.height)];
    [UIView commitAnimations];
}


-(void) setSelectedIndex:(int)index{
    _SelectedIndex = index;
    [self animateTitlesToIndex:index];
    [self animateHandlerToIndex:index];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(int)getSelectedTitleInPoint:(CGPoint)pnt{
    return round((pnt.x-LEFT_OFFSET)/oneSlotSize);
}

-(void) ItemSelected: (UITapGestureRecognizer *) tap {
    self.SelectedIndex = [self getSelectedTitleInPoint:[tap locationInView:self]];
    [self setSelectedIndex:self.SelectedIndex];
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) TouchUp: (UIButton*) btn{
    btn.selected = YES;
    self.SelectedIndex = [self getSelectedTitleInPoint:btn.center];
    [self animateHandlerToIndex:self.SelectedIndex];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) TouchMove: (UIButton *) btn withEvent: (UIEvent *) ev {
    btn.selected = NO;
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    CGPoint toPoint = CGPointMake(currPoint.x-diffPoint.x, self.handlerBtn.frame.origin.y);
    
    toPoint = [self fixFinalPoint:toPoint];
    
    [self.handlerBtn setFrame:CGRectMake(toPoint.x, toPoint.y, self.handlerBtn.frame.size.width, self.handlerBtn.frame.size.height)];
    
    int selected = [self getSelectedTitleInPoint:btn.center];
    
    [self animateTitlesToIndex:selected];
    
    [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}

-(CGPoint)getCenterPointForIndex:(int) i{
    return CGPointMake((i/(float)(titlesArr.count-1)) * (self.frame.size.width-RIGHT_OFFSET-LEFT_OFFSET) + LEFT_OFFSET, i==0?self.frame.size.height-55-TITLE_SELECTED_DISTANCE:self.frame.size.height-55);
}

-(CGPoint)fixFinalPoint:(CGPoint)pnt{
    if (pnt.x < LEFT_OFFSET-(self.handlerBtn.frame.size.width/2.f)) {
        pnt.x = LEFT_OFFSET-(self.handlerBtn.frame.size.width/2.f);
    }else if (pnt.x+(self.handlerBtn.frame.size.width/2.f) > self.frame.size.width-RIGHT_OFFSET){
        pnt.x = self.frame.size.width-RIGHT_OFFSET- (self.handlerBtn.frame.size.width/2.f);
    }
    return pnt;
}

@end
