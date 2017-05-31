//
//  BFSegmentedControl.h
//  BFTest
//
//  Created by 伯符 on 16/8/1.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

enum BFSelectionIndicatorMode{
    BFSelectionIndicatorResizesToStringWidth = 0,
    BFSelectionIndicatorFillsSegment = 1
};

@interface BFSegmentedControl : UIControl


@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, copy) void (^indexChangeBlock)(NSUInteger index); // you can also use addTarget:action:forControlEvents:

@property (nonatomic, strong) UIFont *font; // default is [UIFont fontWithName:@"Avenir-Light" size:19.0f]
@property (nonatomic, strong) UIColor *textColor; // default is [UIColor blackColor]
@property (nonatomic, strong) UIColor *backgroundColor; // default is [UIColor whiteColor]
@property (nonatomic, strong) UIColor *selectionIndicatorColor; // default is 52, 181, 229
@property (nonatomic, assign) enum BFSelectionIndicatorMode selectionIndicatorMode; // Default is HMSelectionIndicatorResizesToStringWidth

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat height; // default is 32.0
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight; // default is 5.0
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset; // default is UIEdgeInsetsMake(0, 5, 0, 5)

- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)moveIndexToIndex:(NSInteger)index animated:(BOOL)animated;
@end
