//
//  BFInterestModelFrame.h
//  BFTest
//
//  Created by 伯符 on 16/11/18.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFInterestModel;
@interface BFInterestModelFrame : NSObject

@property (nonatomic,assign) CGRect iconFrame;

@property (nonatomic,assign) CGRect nameFrame;

@property (nonatomic,assign) CGRect guanzhuFrame;

@property (nonatomic,assign) CGRect fromPlaceFrame;

@property (nonatomic,assign) CGRect timeFrame;

@property (nonatomic,assign) CGRect uplineFrame;

@property (nonatomic,assign) CGRect locateFrame;

@property (nonatomic,assign) CGRect stateFrame;

@property (nonatomic,assign) CGRect videoFrame;

@property (nonatomic,assign) CGRect zanFrame;

@property (nonatomic,assign) CGRect commentFrame;

@property (nonatomic,assign) CGRect shareFrame;

@property (nonatomic,assign) CGRect moreFrame;

@property (nonatomic,assign) CGRect moreBtnFrame;

@property (nonatomic,assign) CGRect botlineFrame;

@property (nonatomic,assign) CGRect jubaoFrame;

@property (nonatomic,assign) CGRect botlineSecFrame;


@property (nonatomic,assign) CGRect zanNumFrame;

@property (nonatomic,assign) CGRect zanLogoFrame;

@property (nonatomic,assign) CGRect comNumFrame;

@property (nonatomic,assign) CGRect replyFrame;

@property (nonatomic,assign) BOOL haveMoreBtn;

@property (nonatomic,assign) BOOL shrinkMore;

@property (nonatomic,assign) BOOL haszan;

@property (nonatomic,assign) NSInteger cellHeight;

/** 评论*/
@property (nonatomic, strong) NSMutableArray *commentFrameArray;

@property (nonatomic,strong) BFInterestModel *interestModel;

@end
