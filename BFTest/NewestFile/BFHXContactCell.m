//
//  BFHXContactCell.m
//  BFTest
//
//  Created by JM on 2017/4/20.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFHXContactCell.h"
@interface BFHXContactCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastOnlineTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageView;

@end
@implementation BFHXContactCell


- (void)setModel:(BFUserInfoModel *)model{
    _model = model;
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"appuserlogo"]];
    self.nameLabel.text = model.name;
    //判断是否是黑名单的cell样式
    if(self.isblackListCell == NO){
        self.sexImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sex%@",model.sex]];
        self.distanceLabel.text = model.distance;
        self.lastOnlineTimeLabel.text = model.lastOnlineTime;
        self.signatureLabel.text = model.signature;
        self.ageLabel.text = model.age;
        self.gradeLabel.text = model.grade;
    }else{
        self.signatureLabel.text = [NSString stringWithFormat:@"拉黑时间 %@",model.opTime];
        self.sexImageView.image = nil;
        self.distanceLabel.text = nil;
        self.lastOnlineTimeLabel.text = nil;
        self.ageLabel.text = nil;
        self.gradeLabel.text = nil;
        self.gradeImageView.image = nil;

    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
