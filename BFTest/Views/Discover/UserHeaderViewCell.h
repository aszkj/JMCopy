//
//  UserHeaderViewCell.h
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectUserScollDelegate <NSObject>
- (void)selectScrollImg;
@end
@interface UserHeaderViewCell : UITableViewCell

@property (nonatomic,assign) NSDictionary *dic;

@property (nonatomic,assign) id <SelectUserScollDelegate> delegate;

+ (NSInteger)getUserHeaderHeight;

@end
