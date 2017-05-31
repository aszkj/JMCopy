//
//  FridVideoController.h
//  BFTest
//
//  Created by 伯符 on 16/12/15.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFFriMediaClusterController.h"

typedef void(^SelectVideo)(NSString *imgPath);
@protocol FridVideoDelegate <NSObject>

- (void)didFinishRecordingToOutputFilePath:(NSString *)outputFilePath;

- (void)scrollviewDidScroll:(NSInteger)index;

@end
@interface FridVideoController : UIViewController
@property (nonatomic, assign) NSTimeInterval videoMaximumDuration;
@property (nonatomic, assign) NSTimeInterval videoMinimumDuration;
@property (nonatomic, weak) id<FridVideoDelegate> delegate;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) BFFriMediaClusterController *clusterVC;
@property (nonatomic,strong) UIScrollView *scrollview;

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize themeColor:(UIColor *)themeColor;

- (void)pushVC:(SelectVideo)select;

@end
