//
//  DongtaiViewCell.h
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongtaiViewCell : UITableViewCell

@property (nonatomic,copy) NSString *jmid;
@property (nonatomic,strong) NSDictionary *imgDic;

- (NSInteger)getDongtaiHeight;

@end
