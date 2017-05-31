//
//  BFInterestModelFrame.m
//  BFTest
//
//  Created by 伯符 on 16/11/18.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFInterestModelFrame.h"
#import "BFInterestModel.h"
#import "CommentFrame.h"
@interface BFInterestModelFrame ()
@property (nonatomic,assign) CGRect stateRect;
@property (nonatomic,assign) CGFloat stateheight;
@property (nonatomic,assign) CGFloat zanWidth;

@end
@implementation BFInterestModelFrame

- (NSMutableArray *)commentFrameArray{
    if (!_commentFrameArray) {
        _commentFrameArray = [NSMutableArray array];
    }
    return _commentFrameArray;
}


- (void)setInterestModel:(BFInterestModel *)interestModel{
    _interestModel = interestModel;
    self.stateheight = [interestModel.message getHeightWithWidth:Screen_width - 20*ScreenRatio font:16];
    if ([interestModel.message isEqualToString:@""]) {
        self.stateheight = 0;
    }

    self.iconFrame = CGRectMake(10 *ScreenRatio, 10*ScreenRatio, 37*ScreenRatio, 37*ScreenRatio);
    CGFloat width = [interestModel.nikename getWidthWithHeight:13*ScreenRatio font:16];
    CGFloat fromePlacewidth = [interestModel.location getWidthWithHeight:13*ScreenRatio font:15];
    self.nameFrame = CGRectMake(CGRectGetMaxX(self.iconFrame)+5*ScreenRatio, 10*ScreenRatio, width, 17*ScreenRatio);
    
    self.guanzhuFrame =  CGRectMake(CGRectGetMaxX(self.nameFrame)+5*ScreenRatio, 8*ScreenRatio, 32*ScreenRatio, 16*ScreenRatio);
    self.fromPlaceFrame = CGRectMake(self.nameFrame.origin.x, CGRectGetMaxY(self.nameFrame)+ 7*ScreenRatio, fromePlacewidth + 9*ScreenRatio, 15*ScreenRatio);
    CGFloat timewidth = [interestModel.publish_datetime getWidthWithHeight:13*ScreenRatio font:13];

    self.timeFrame = CGRectMake(Screen_width - timewidth, 20*ScreenRatio, timewidth, 10);
    
    self.videoFrame = CGRectMake(0, CGRectGetMaxY(self.iconFrame)+ 9 *ScreenRatio,Screen_width, Screen_width);
    
    CGFloat zanY = CGRectGetMaxY(self.videoFrame);
    self.zanFrame = CGRectMake(- 1 , zanY ,45*ScreenRatio, 45*ScreenRatio);
    self.commentFrame = CGRectMake(CGRectGetMaxX(self.zanFrame), zanY, 45*ScreenRatio, 45*ScreenRatio);
    self.shareFrame = CGRectMake(CGRectGetMaxX(self.commentFrame), zanY, 45*ScreenRatio, 45*ScreenRatio);
    self.botlineFrame = CGRectMake(0 , CGRectGetMaxY(self.shareFrame), Screen_width, 0.5);

    self.jubaoFrame = CGRectMake(Screen_width - 45*ScreenRatio , zanY , 45*ScreenRatio, 45*ScreenRatio);
    
    if (self.stateheight < 66) {
        self.shrinkMore = NO;
        self.haveMoreBtn = NO;
//        maxY = CGRectGetMaxY(self.stateFrame) + 5*ScreenRatio;
    }else{
        self.shrinkMore = YES;
        self.haveMoreBtn = YES;
    }
}

- (void)setHaveMoreBtn:(BOOL)haveMoreBtn{
    _haveMoreBtn = haveMoreBtn;
    if (!_haveMoreBtn) {
        NSLog(@" ---------stateheight: %f",self.stateheight);
        self.stateFrame = CGRectMake(10*ScreenRatio, CGRectGetMaxY(self.botlineFrame)+ 9*ScreenRatio, Screen_width - 20*ScreenRatio, self.stateheight);
        [self configureUIHavemore:NO];
    }else{
        if (self.shrinkMore) {
            self.stateFrame = CGRectMake(10*ScreenRatio,CGRectGetMaxY(self.botlineFrame)+ 5*ScreenRatio , Screen_width - 20*ScreenRatio, 66);
            [self configureUIHavemore:YES];
        }else{
            self.stateFrame = CGRectMake(10*ScreenRatio,CGRectGetMaxY(self.botlineFrame)+ 5*ScreenRatio , Screen_width - 20*ScreenRatio, self.stateheight);
            [self configureUIHavemore:YES];
        }
    }
}


/*
- (void)setShrinkMore:(BOOL)shrinkMore{
    _shrinkMore = shrinkMore;
    if (!_shrinkMore) {
        self.stateFrame = CGRectMake(5*ScreenRatio,CGRectGetMaxY(self.uplineFrame)+ 5*ScreenRatio , self.stateRect.size.width, self.stateRect.size.height);
        [self configureUI];

    }else{
        self.stateFrame = CGRectMake(5*ScreenRatio, CGRectGetMaxY(self.uplineFrame)+ 5*ScreenRatio, self.stateRect.size.width, 66);
        [self configureUI];
    }
}
 */


- (void)configureUIHavemore:(BOOL)more{
    
    if (_interestModel.zan > 0) {
        self.haszan = YES;
        NSString *str = [NSString stringWithFormat:@"%ld次赞",_interestModel.zan];
        self.zanWidth = [str getWidthWithHeight:13*ScreenRatio font:17];
    }else{
        self.haszan = NO;
    }
    if ([_interestModel.message isEqualToString:@""]) {
        self.moreBtnFrame = CGRectMake(Screen_width - 5*ScreenRatio - 37*ScreenRatio, CGRectGetMaxY(self.stateFrame), 37*ScreenRatio, more ? 19 : 0);
        self.botlineSecFrame = CGRectMake(0 , CGRectGetMaxY(self.moreBtnFrame), Screen_width, 0);

    }else{
        self.moreBtnFrame = CGRectMake(Screen_width - 5*ScreenRatio - 37*ScreenRatio, CGRectGetMaxY(self.stateFrame) + 5*ScreenRatio, 37*ScreenRatio, more ? 19 : 0);
        self.botlineSecFrame = CGRectMake(0 , CGRectGetMaxY(self.moreBtnFrame)+5*ScreenRatio, Screen_width, 0.5);
    }
    
    self.zanLogoFrame = CGRectMake(9*ScreenRatio, CGRectGetMaxY(self.botlineSecFrame) + 7*ScreenRatio,18*ScreenRatio, self.haszan ? 12*ScreenRatio : 0);
    
    self.zanNumFrame = CGRectMake(CGRectGetMaxX(self.zanLogoFrame)+5*ScreenRatio, CGRectGetMinY(self.zanLogoFrame) - 4, self.zanWidth, self.haszan ? 18 *ScreenRatio : 0);

    self.comNumFrame = CGRectMake(9*ScreenRatio,CGRectGetMaxY(self.zanNumFrame)+5, 150*ScreenRatio, _interestModel.comments.count == 0 ? 0 : 19*ScreenRatio);
    
    CGRect comrect = CGRectMake(5*ScreenRatio, CGRectGetMaxY(self.comNumFrame), 0, 0);;
    [self.commentFrameArray removeAllObjects];
    CGFloat commentsNum = _interestModel.comments.count > 2 ? 2 : _interestModel.comments.count;
    
    for (int i = 0; i < commentsNum; i ++) {
        
        comrect = CGRectMake(9*ScreenRatio, CGRectGetMaxY(self.comNumFrame)+5*ScreenRatio + (15*ScreenRatio + 5*ScreenRatio)*i, Screen_width - 10*ScreenRatio, 15*ScreenRatio);
        [self.commentFrameArray addObject:[NSValue valueWithCGRect:comrect]];
    }
    self.cellHeight = CGRectGetMaxY(comrect)+ 17*ScreenRatio;
}

@end
