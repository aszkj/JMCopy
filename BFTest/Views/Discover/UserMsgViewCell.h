//
//  UserMsgViewCell.h
//  BFTest
//
//  Created by 伯符 on 16/10/26.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMsgViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) NSString *detailStr;

- (NSInteger)getMsgCellHeight;

@end
