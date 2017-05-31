//
//  RelateTopicsController.h
//  BFTest
//
//  Created by 伯符 on 17/3/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
@interface RelateTopicsController : UIViewController

@property (nonatomic,assign) MLEmojiLabelLinkType type;

@property (nonatomic,copy) NSString *linkStr;

@end
