//
//  BFChatMoreView.m
//  BFTest
//
//  Created by 伯符 on 16/7/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFChatMoreView.h"
#import "PKRecordShortVideoViewController.h"
@interface BFChatMoreView ()
@property (nonatomic,strong) UIButton *vedioButton; /* 视频按钮 */
@property (nonatomic,strong) UIButton *moneyPacketButton; /* 红包按钮 */
@property (nonatomic,strong) UIButton *collectButton; /* 收藏按钮 */
@property (nonatomic,strong) UIButton *locateButton; /* 位置按钮 */
@property (nonatomic,strong) UIButton *callButton; /* 语音通话按钮 */


@property (nonatomic,strong) UILabel *vedioLabel;
@property (nonatomic,strong) UILabel *moneyPacketLabel;
@property (nonatomic,strong) UILabel *collectLabel;
@property (nonatomic,strong) UILabel *locateLabel;
@property (nonatomic,strong) UILabel *callLabel; /* 语音通话 */

@property (nonatomic,strong) NSArray *moreFuncArray;
@property (nonatomic,strong) NSArray *funcLabelArray;
@end

@implementation BFChatMoreView


#pragma mark - GETTERS 方法

- (UIButton *)vedioButton{
    if (!_vedioButton) {
        _vedioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _vedioButton.tag = BFMoreViewShowVedio;
        [_vedioButton setBackgroundImage:[UIImage imageNamed:@"vedio"] forState:UIControlStateNormal];
        [_vedioButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_vedioButton sizeToFit];
    }
    
    return _vedioButton;
}

- (UIButton *)moneyPacketButton{
    if (!_moneyPacketButton) {
        _moneyPacketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moneyPacketButton.tag = BFMoreViewShowMoneyPacket;
        [_moneyPacketButton setBackgroundImage:[UIImage imageNamed:@"money"] forState:UIControlStateNormal];
        [_moneyPacketButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moneyPacketButton sizeToFit];
    }
    return _moneyPacketButton;
}
- (UIButton *)collectButton{
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.tag = BFMoreViewShowCollection;
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_collectButton sizeToFit];
    }
    return _collectButton;
}
- (UIButton *)locateButton{
    if (!_locateButton) {
        _locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locateButton.tag = BFMoreViewShowLocation;
        [_locateButton setBackgroundImage:[UIImage imageNamed:@"locate"] forState:UIControlStateNormal];
        [_locateButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_locateButton sizeToFit];
    }
    return _locateButton;
}

- (UIButton *)callButton{
    if (!_callButton) {
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callButton.tag = BFMoreViewShowCall;
        [_callButton setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [_callButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_callButton sizeToFit];
    }
    return _callButton;
}

- (UILabel *)vedioLabel{
    if (!_vedioLabel) {
        _vedioLabel = [[UILabel alloc]init];
        _vedioLabel.font = BFFontOfSize(11);
        _vedioLabel.textColor = [UIColor whiteColor];
        _vedioLabel.backgroundColor = [UIColor clearColor];
        _vedioLabel.textAlignment = NSTextAlignmentCenter;
        _vedioLabel.text = @"视频";
    }
    return _vedioLabel;
}
- (UILabel *)moneyPacketLabel{
    if (!_moneyPacketLabel) {
        _moneyPacketLabel = [[UILabel alloc]init];
        _moneyPacketLabel.font = BFFontOfSize(11);
        _moneyPacketLabel.textColor = [UIColor whiteColor];
        _moneyPacketLabel.backgroundColor = [UIColor clearColor];
        _moneyPacketLabel.textAlignment = NSTextAlignmentCenter;
        _moneyPacketLabel.text = @"红包";
    }
    return _moneyPacketLabel;
}
//- (UILabel *)collectLabel{
//    if (!_collectLabel) {
//        _collectLabel = [[UILabel alloc]init];
//        _collectLabel.font = BFFontOfSize(11);
//        _collectLabel.textColor = [UIColor whiteColor];
//        _collectLabel.backgroundColor = [UIColor clearColor];
//        _collectLabel.textAlignment = NSTextAlignmentCenter;
//        _collectLabel.text = @"收藏";
//    }
//    return _collectLabel;
//}
- (UILabel *)locateLabel{
    if (!_locateLabel) {
        _locateLabel = [[UILabel alloc]init];
        _locateLabel.font = BFFontOfSize(11);
        _locateLabel.textColor = [UIColor whiteColor];
        _locateLabel.backgroundColor = [UIColor clearColor];
        _locateLabel.textAlignment = NSTextAlignmentCenter;
        _locateLabel.text = @"位置";
    }
    return _locateLabel;
}

- (UILabel *)callLabel{
    if (!_callLabel) {
        _callLabel = [[UILabel alloc]init];
        _callLabel.font = BFFontOfSize(11);
        _callLabel.textColor = [UIColor whiteColor];
        _callLabel.backgroundColor = [UIColor clearColor];
        _callLabel.textAlignment = NSTextAlignmentCenter;
        _callLabel.text = @"电话";
    }
    return _callLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 设置UI
- (void)setupUI{
    self.backgroundColor = BFColor(35, 35, 35, 1);
    [self addSubview:self.callButton];

    [self addSubview:self.locateButton];

    [self addSubview:self.callLabel];
    [self addSubview:self.locateLabel];
    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    if ([hidebtn[@"Gift"]isEqualToString:@"0"]||[UserwordMsg isEqualToString:@"123456jm"]){
        [self addSubview:self.vedioButton];
        [self addSubview:self.vedioLabel];
        self.moreFuncArray = @[self.callButton,self.vedioButton,self.locateButton];
        self.funcLabelArray = @[self.callLabel,self.vedioLabel,self.locateLabel];
        
    }else{
        [self addSubview:self.moneyPacketButton];
        [self addSubview:self.moneyPacketLabel];
        [self addSubview:self.vedioButton];
        [self addSubview:self.vedioLabel];
        
        self.moreFuncArray = @[self.vedioButton,self.callButton,self.moneyPacketButton,self.locateButton];
        self.funcLabelArray = @[self.vedioLabel,self.callLabel,self.moneyPacketLabel,self.locateLabel];
    }
    
}

#pragma mark - 点击键盘
- (void)buttonAction:(UIButton *)btn{
//    [self.superview addSubview:self.back];
//    [self.superview bringSubviewToFront:self];
//    switch (btn.tag) {
//        case BFMoreViewShowVedio:{
            /*
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *fileName = [NSProcessInfo processInfo].globallyUniqueString;
            NSString *path = [paths[0] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"mp4"]];
            //跳转默认录制视频ViewController
            PKRecordShortVideoViewController *viewController = [[PKRecordShortVideoViewController alloc] initWithOutputFilePath:path outputSize:CGSizeMake(320, 240) themeColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1]];
            //通过代理回调
            viewController.delegate = self;
            [self presentViewController:viewController animated:YES completion:nil];
            */
//        }
//            
//            break;
//        case BFMoreViewShowCollection:
//            NSLog(@"BFMoreViewShowCollection");
//            [self showFaceView:YES];
//            [self resignKeyboard:btn];
//            [self.textView resignFirstResponder];
//            [self changeSelfFrame];
//            break;
//        case BFMoreViewShowMoneyPacket:
//            NSLog(@"BFMoreViewShowMoneyPacket");
//            break;
//        case BFMoreViewShowLocation:
//            NSLog(@"BFMoreViewShowLocation");
//            break;
//
//        default:
//            break;
//    }
    
    if ([self.delegate respondsToSelector:@selector(chatMoreViewItemSelect:)]) {
        [self.delegate chatMoreViewItemSelect:btn.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger space = (Screen_width - 30*ScreenRatio - 40*ScreenRatio * 4)/ (4 - 1);
    for (int i = 0; i < self.moreFuncArray.count; i ++) {
        UIButton *btn = self.moreFuncArray[i];
        UILabel *label = self.funcLabelArray[i];
        btn.frame = CGRectMake(15*ScreenRatio + (40*ScreenRatio + space)* (i%4), 16*ScreenRatio + (40*ScreenRatio + space) * (i/4), 40*ScreenRatio, 40*ScreenRatio);
        label.frame = CGRectMake(0, 0, 25*ScreenRatio, 9*ScreenRatio);
        label.center = CGPointMake(btn.centerX, CGRectGetMaxY(btn.frame) + 10*ScreenRatio);
    }
}
@end
