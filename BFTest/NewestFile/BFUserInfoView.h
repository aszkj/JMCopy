//
//  BFUserInfoView.h
//  BFTest
//
//  Created by JM on 2017/4/6.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFUserInfoModel.h"

@interface BFUserInfoView : UIView

@property (nonatomic,strong)BFUserInfoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *progressBackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *progressBackImageView_02;

@end
