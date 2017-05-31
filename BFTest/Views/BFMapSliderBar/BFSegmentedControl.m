//
//  BFSegmentedControl.m
//  BFTest
//
//  Created by 伯符 on 16/8/1.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFSegmentedControl.h"

@interface BFSegmentedControl ()

@property (nonatomic, strong) CALayer *selectedSegmentLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;

@end

@implementation BFSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setDefaults];
    }
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles{
    if (self = [super initWithFrame:CGRectZero]) {
        self.sectionTitles = sectiontitles;
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults{
//    self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0f];
    self.font = [UIFont boldSystemFontOfSize:17.0f];
    self.textColor = [UIColor whiteColor];
    self.selectionIndicatorColor = BFColor(251, 213, 0, 1);
    self.backgroundColor = BFColor(36.5, 36.5, 36.5, 1);
    self.selectedIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.height = 32.0f;
    self.selectionIndicatorHeight = 2.0f;
    self.selectionIndicatorMode = BFSelectionIndicatorFillsSegment;
    
    self.selectedSegmentLayer = [CALayer layer];
}

- (void)drawRect:(CGRect)rect{
    [self.backgroundColor set];
    UIRectFill([self bounds]);
    [self.textColor set];
    [self.sectionTitles enumerateObjectsUsingBlock:^(id  _Nonnull titleString, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat stringHeight = [titleString sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
        CGFloat y = ((self.height - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2);
        CGRect rect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        [titleString drawInRect:rect
                       withFont:self.font
                  lineBreakMode:UILineBreakModeClip
                      alignment:UITextAlignmentCenter];
#else
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [titleString drawInRect:rect withAttributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:self.textColor}];
        
#endif
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
        [self.layer addSublayer:self.selectedSegmentLayer];
        
    }];
}

- (CGRect)frameForSelectionIndicator{
    CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedIndex] sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
    
    if (self.selectionIndicatorMode == BFSelectionIndicatorResizesToStringWidth) {
        CGFloat widthTillEndOfSelectedIndex = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
        CGFloat widthTillBeforeSelectedIndex = (self.segmentWidth * self.selectedIndex);
        
        CGFloat x = ((widthTillEndOfSelectedIndex - widthTillBeforeSelectedIndex) / 2) + (widthTillBeforeSelectedIndex - stringWidth / 2);
        return CGRectMake(x, self.height - self.selectionIndicatorHeight, stringWidth, self.selectionIndicatorHeight);
    } else {
        return CGRectMake(self.segmentWidth * self.selectedIndex, self.height - self.selectionIndicatorHeight + 5, self.segmentWidth, self.selectionIndicatorHeight);
    }

}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview == nil)
        return
    
    [self updateSegmentsRects];
    
}

- (void)updateSegmentsRects {
    if (CGRectIsEmpty(self.frame)) {
        self.segmentWidth = 0;
        
        for (NSString *titleString in self.sectionTitles) {
            CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }
        self.bounds = CGRectMake(0, 0, self.segmentWidth * self.sectionTitles.count, self.height);
    } else {
        self.segmentWidth = self.frame.size.width / self.sectionTitles.count;
        self.height = self.frame.size.height;
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = touchLocation.x / self.segmentWidth;
        
        if (segment != self.selectedIndex) {
            [self setSelectedIndex:segment animated:YES];
        }
    }
}
- (void)moveIndexToIndex:(NSInteger)index animated:(BOOL)animated{
    _selectedIndex = index ;
    
    if (animated) {
        self.selectedSegmentLayer.actions = nil;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setCompletionBlock:^{
            if (self.superview)
                [self sendActionsForControlEvents:UIControlEventValueChanged];
}];
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        [CATransaction commit];
        
    }else{
        // Disable CALayer animations
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectedSegmentLayer.actions = newActions;
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        
        if (self.superview)
            [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated{
    _selectedIndex = index ;
    
    if (animated) {
        self.selectedSegmentLayer.actions = nil;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setCompletionBlock:^{
            if (self.superview)
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            
            if (self.indexChangeBlock)
                self.indexChangeBlock(index);
        }];
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        [CATransaction commit];

    }else{
        // Disable CALayer animations
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectedSegmentLayer.actions = newActions;
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        
        if (self.superview)
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        if (self.indexChangeBlock)
            self.indexChangeBlock(index);
        
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

@end
