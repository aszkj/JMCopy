//
//  BFHotCollectionViewCell.h
//  BFTest
//
//  Created by 伯符 on 16/8/4.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFHotCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UIImageView *tagImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSDictionary *dic;
- (void)setImage:(NSString *)imageUrl
           title:(NSString *)title
          isLive:(BOOL)isLive;
@end
