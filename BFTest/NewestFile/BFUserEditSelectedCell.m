//
//  BFUserEditSelectedCell.m
//  BFTest
//
//  Created by JM on 2017/4/9.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserEditSelectedCell.h"

@interface BFUserEditSelectedCell()
{
    UIFont *labelFont;
}

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (nonatomic,assign) BOOL showBlackFont;

@end

@implementation BFUserEditSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self recordLabelFont];
}
- (void)recordLabelFont{
    labelFont = self.infoLabel.font;
    self.selectedImageView.hidden = YES;
}
- (void)cellShowSelectedSurface{
    self.infoLabel.font = self.showBlackFont ? [UIFont fontWithName:@"Helvetica-Bold" size:15] : labelFont ;
    self.selectedImageView.hidden = self.showBlackFont ? NO : YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.showBlackFont = self.selected;
    [self cellShowSelectedSurface];
}

@end
