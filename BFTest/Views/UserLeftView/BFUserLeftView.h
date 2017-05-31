//
//  BFUserLeftView.h
//  BFTest
//
//  Created by 伯符 on 16/6/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFDataGenerator.h"
#import "BFUserLeftView.h"
#import "BFTabbarController.h"
//#import "ANBlurredImageView.h"
#import "BFSliderCell.h"
#import "BFMapMainController.h"
#import "YYWebImage.h"
#import "BFUserInfoView.h"


@protocol BFUserLeftViewSelectDelegate <NSObject>

- (void)selectedIndex:(NSInteger)index;

- (void)hiddenStatusBar;

@end

@interface BFUserLeftView : UIView<UITableViewDelegate,UITableViewDataSource>

{
    UILabel *nameLabel;
    UIView *back;
    UILabel *assign;
    UIImageView *view;
    
}
@property(nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong) UIImage *backImg;
@property (nonatomic,strong) UITableView *leftList;
@property (nonatomic,strong) NSDictionary *userDic;
@property (nonatomic,assign)id <BFUserLeftViewSelectDelegate> delegate;
@property (nonatomic,strong) UIViewController *vc;

- (void)showLeftView;

- (void)showWithGesture:(UIPanGestureRecognizer *)pan;

- (void)performBackAnimate;

- (void)setbackgroundViewImageWithImage:(UIImage *)image;

- (void)refreshIconImageAndBackgroundImage:(NSURL *)url;
@end
