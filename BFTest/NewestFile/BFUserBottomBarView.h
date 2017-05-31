//
//  BFUserBottomBarView.h
//  BFTest
//
//  Created by JM on 2017/4/21.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFUserBottomBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *chatButtonAction;
@property (weak, nonatomic) IBOutlet UIButton *followButtonAction;
@property (nonatomic,assign)BOOL showFollowButton;

@end
