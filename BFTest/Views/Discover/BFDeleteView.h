//
//  BFDeleteView.h
//  BFTest
//
//  Created by 伯符 on 17/3/11.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteDTDelegate <NSObject>

- (void)deleteUserDT;

@end

@interface BFDeleteView : UIView

typedef void(^jubaoBlock)(NSString *jbmesg);

@property (nonatomic,assign) id<DeleteDTDelegate>delegate;
@property (nonatomic,strong) jubaoBlock block;

- (instancetype)initViewWithTitle:(NSString *)title;

- (void)show;

@end
