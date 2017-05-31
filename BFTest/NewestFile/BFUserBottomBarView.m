//
//  BFUserBottomBarView.m
//  BFTest
//
//  Created by JM on 2017/4/21.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserBottomBarView.h"
@interface BFUserBottomBarView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatButtonWidth;

@end

@implementation BFUserBottomBarView

-(void)setShowFollowButton:(BOOL)showFollowButton{
    _showFollowButton = showFollowButton;
    [self.chatButtonAction mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(showFollowButton == YES?Screen_width/2:Screen_width);
        make.height.left.top.equalTo(self);
    }];
    
    
}

@end
