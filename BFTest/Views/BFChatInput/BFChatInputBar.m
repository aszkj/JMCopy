//
//  BFChatInputBar.m
//  BFTest
//
//  Created by 伯符 on 16/7/5.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFChatInputBar.h"
#import "BFPhotoPicker.h"

#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"

#import "BFButtonView.h"
#import "BFVoiceIndicatorView.h"
#import "BFHXDelegateManager+Chat.h"

#define distance_Y_Max  40
#define placeHolderLabelLeftMargin 5
#define placeHolderLabelTopMargin 8
#define TextViewFrame CGRectMake(30*ScreenRatio+10, 5, Screen_width - 31*ScreenRatio-30, self.height/2 - 10)

#define VOICE_ON_color BFColor(200, 200, 200, 1)
#define VOICE_OFF_color [UIColor whiteColor]


#define kChatFuntionNum  6

 static float distance_Y = 0;

@interface BFChatInputBar ()<UITextViewDelegate,BFPhotoPickerDelegate,BFChatMoreItemDelegate,EMFaceDelegate,UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat version;

@property (nonatomic) CGFloat previousTextViewContentHeight;//上一次inputTextView的contentSize.height

@property (nonatomic,strong) UITextView *textView; /* 输入框 */

@property (nonatomic,strong) BFButtonView *faceButton; /* 表情按钮 */
@property (nonatomic,strong) BFButtonView *voiceRecordButton; /* 录音按钮 */
@property (nonatomic,strong) BFButtonView *photoButton; /* 图片按钮 */
@property (nonatomic,strong) BFButtonView *drawButton; /* 绘画按钮 */
@property (nonatomic,strong) BFButtonView *shortVideoButton; /* 短视频按钮 */
@property (nonatomic,strong) BFButtonView *presentButton; /* 礼物按钮 */
@property (nonatomic,strong) BFButtonView *moreButton; /* 更多按钮 */


@property (nonatomic,strong) UILabel *placeHolderLabel;
@property (nonatomic,strong) UIView *inputBackView;
@property (nonatomic,strong) UIImageView *voicePanGuestureImageView;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,assign) BOOL isRecordingVoice;
@property (nonatomic,assign) UILabel *voiceLabel;
@property (nonatomic,strong) BFVoiceIndicatorView *voiceIndicatorView;
@property (nonatomic,strong) UIView *placeHolderLabelBackView;



@property (nonatomic,strong) NSArray *inputBtnArray;

@property (nonatomic,strong) UIView *upView;

@property (nonatomic,strong) UIView *botView;

@property (nonatomic,assign) CGRect keyboardFrame;

@property (nonatomic,assign) CGRect originalRect;

@property (nonatomic,assign) CGFloat currentShowViewHeight;

@property (nonatomic,strong) NSTimer *refreshPowerImageTimer;

@end

@implementation BFChatInputBar

#pragma mark - GETTERS 方法
- (UIButton *)back{
    if (!_back) {
        _back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        _back.backgroundColor = [UIColor clearColor];
        [_back addTarget:self action:@selector(resignKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _back;
}
//表情View
- (EaseFaceView *)faceView{
    
    if (_faceView == nil) {
        _faceView = [[EaseFaceView alloc] initWithFrame:CGRectMake(0, Screen_height, Screen_width, kFunctionFaceViewHeight)];
        [(EaseFaceView *)_faceView setDelegate:self];
        _faceView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _faceView;
}

- (BFChatMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[BFChatMoreView alloc] initWithFrame:CGRectMake(0, Screen_height, Screen_width, kMoreViewHeight/2)];
    }
    
    return _moreView;
}

- (BFPhotoPicker *)photoView{
    if (!_photoView) {
        _photoView = [[BFPhotoPicker alloc]initWithFrame:CGRectMake(0, Screen_height, Screen_width, kFunctionFaceViewHeight)];
        _photoView.delegate = self;
    }
    return _photoView;
}

- (BFVedioView *)recordVedioView{
    if (!_recordVedioView) {
        _recordVedioView = [[BFVedioView alloc] initWithFrame:CGRectMake(0, Screen_height, Screen_width, kMoreViewHeight)];
    }
    return _recordVedioView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(30*ScreenRatio+10, 5, Screen_width - 31*ScreenRatio-30, self.height/2 - 10)];
        _textView.font = [UIFont systemFontOfSize:17.0f];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.masksToBounds = YES;
        _textView.backgroundColor = [UIColor clearColor];
        _previousTextViewContentHeight = [self _getTextViewContentH:_textView];
        
        UIView *placeHolderLabelBackView = [[UIView alloc]init];
        placeHolderLabelBackView.size = _textView.size;
        placeHolderLabelBackView.origin = CGPointMake(1, 1);
        placeHolderLabelBackView.backgroundColor = [UIColor whiteColor];
        placeHolderLabelBackView.layer.cornerRadius = 4;
        placeHolderLabelBackView.clipsToBounds = YES;
        self.placeHolderLabelBackView = placeHolderLabelBackView;
        
        UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:_textView.frame];
        placeHolderLabel.font = [UIFont systemFontOfSize:17.0f];
        placeHolderLabel.textColor = BFColor(160, 160, 160, 1);
        placeHolderLabel.textAlignment = NSTextAlignmentCenter;
        placeHolderLabel.text = @"请输入消息...";
        _placeHolderLabel = placeHolderLabel;
        
        UIImageView *voiceImgv = [[UIImageView alloc]initWithFrame:_textView.frame];
        UILabel *voiceLabel = [[UILabel alloc]init];
        voiceLabel.size = voiceImgv.size;
        voiceLabel.origin = CGPointZero;
        voiceLabel.font = [UIFont systemFontOfSize:17.0f];
        voiceLabel.textColor = [UIColor grayColor];
        voiceLabel.textAlignment = NSTextAlignmentCenter;
        voiceLabel.text = @"按住 说话";
        self.voiceLabel = voiceLabel;
        
        
        self.voicePanGuestureImageView = voiceImgv;
        voiceImgv.backgroundColor = VOICE_OFF_color;
        voiceImgv.userInteractionEnabled = YES;
        voiceImgv.hidden = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.1;
        pan.delegate = self;
        tap.delegate = self;
        
        
        [voiceImgv addSubview:voiceLabel];
        [voiceImgv addGestureRecognizer:pan];
        [voiceImgv addGestureRecognizer:longPress];
        [voiceImgv addGestureRecognizer:tap];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_textView.origin.x-1, _textView.origin.y-1, _textView.size.width+2, _textView.size.height+2)];
        view.backgroundColor = BFColor(230, 230, 230, 1);
        view.layer.cornerRadius = 3;
        view.clipsToBounds = YES;
        [view addSubview:placeHolderLabelBackView];
        _inputBackView = view;
        
    }
    return _textView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    //手势判断成功  状态开始手势 并且当前没有在录音  触发录音
    if(sender.state == UIGestureRecognizerStateBegan && self.isRecordingVoice == NO){
        [self begainRecord];
        
    }
    //手势判断成功  状态结束手势 并且当前在录音  触发发送
    if(((distance_Y < 0 && -distance_Y <= distance_Y_Max)||(distance_Y >= 0)) && sender.state == UIGestureRecognizerStateEnded && self.isRecordingVoice == YES){
        [self sendRecord];
    }
    
    
    if([sender isMemberOfClass:[UITapGestureRecognizer class]]){
        //只对点按手势做简单的事件拦截 不做任何操作 以防键盘下拉事件被触发 ——>然而并没有用 已经换思路实现
        NSLog(@"tap_state ->%zd ",sender.state);
//        return;
    }else{
        NSLog(@"longPress_state ->%zd ",sender.state);
    }
    
}


- (void)panAction:(UIPanGestureRecognizer*)sender{
    CGPoint translation = [sender translationInView:sender.view];
    distance_Y += translation.y;
   
    
    if(self.voiceIndicatorView && -distance_Y > distance_Y_Max){
        [self.voiceIndicatorView showCancelStateOn:YES];
    }
    if(self.voiceIndicatorView && -distance_Y < distance_Y_Max){
        [self.voiceIndicatorView showCancelStateOn:NO];
    }
    
    //手势判断成功  状态开始手势 并且当前没有在录音  触发录音
    if(sender.state == UIGestureRecognizerStateBegan && self.isRecordingVoice == NO){
        [self begainRecord];
//        [self addVoiceIndicator];
    }
    
    //手势判断成功  状态结束手势 并且当前在录音  已经向上拖拽超出最大距离  触发取消录制
    if(distance_Y < 0 && -distance_Y > distance_Y_Max && sender.state == UIGestureRecognizerStateEnded && self.isRecordingVoice == YES){
        //拖拽到最大距离放手 取消录音
        distance_Y = 0;
        [self cancelRecord];
    }
    
    //手势判断成功  状态结束手势 并且当前在录音  已经向上拖拽 但没有超出最大距离  触发发送录音
    if(  ((distance_Y < 0 && -distance_Y <= distance_Y_Max)||(distance_Y >= 0)) && sender.state == UIGestureRecognizerStateEnded && self.isRecordingVoice == YES){
        distance_Y = 0;
        [self sendRecord];
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];
//    NSLog(@"%f",distance_Y);
     NSLog(@"pan_state ->%zd ",sender.state);
}

- (void)addVoiceIndicator{
    self.voiceIndicatorView = [[BFVoiceIndicatorView alloc]initWithStateOnImage:[UIImage imageNamed:@"voiceLargeBack"] stateOffImage:[UIImage imageNamed:@"voiceLarge"] timeFullCallBack:^{
            //时长达到60秒 发送语音
        [self.voiceIndicatorView removeFromSuperview];
        [self sendRecord];
    }];
    BFVoiceIndicatorView *voiceIndicatorView = self.voiceIndicatorView;
    UINavigationController *currentNav = ((UIViewController *)(self.nextResponder.nextResponder)).navigationController;
    [currentNav.view addSubview:voiceIndicatorView];
    [voiceIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        float y = ( self.frame.origin.y);
        make.width.mas_equalTo(ScreenRatio*150);
        make.height.mas_equalTo(ScreenRatio*180);
//        make.top.mas_equalTo( y - ScreenRatio*(180 + 15));
        make.centerX.equalTo(currentNav.view.mas_centerX);
        make.centerY.equalTo(currentNav.view.mas_centerY);
    }];
}

- (void)removeVoiceindicator{
    if(self.voiceIndicatorView){
        [self.voiceIndicatorView removeFromSuperview];
        self.voiceIndicatorView = nil;
    }
}


-(void)refreshVoiceImage {
    double voiceSound = 0;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    if(self.voiceIndicatorView){
        self.voiceIndicatorView.powerLevel = (int)(voiceSound*7 + 1);
    }else{
        [self.refreshPowerImageTimer invalidate];
        self.refreshPowerImageTimer = nil;
    }
    NSLog(@"power_level -> %zd",(int)(voiceSound*7 + 1));
}

- (void)begainRecord{
    NSLog(@"***************************** begin");
    self.isRecordingVoice = YES;
    self.voicePanGuestureImageView.backgroundColor = VOICE_ON_color;
    self.voiceLabel.text = self.isRecordingVoice ? @"松开 结束":@"按住 说话";
    [self addVoiceIndicator];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]){
        [self.delegate performSelector:@selector(didStartRecordingVoiceAction:) withObject:nil];
    }
    if(self.refreshPowerImageTimer == nil){
        self.refreshPowerImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(refreshVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    }
}
- (void)sendRecord{
    NSLog(@"***************************** send");
    self.isRecordingVoice = NO;
    self.voicePanGuestureImageView.backgroundColor = VOICE_OFF_color;
    self.voiceLabel.text = self.isRecordingVoice ? @"松开 结束":@"按住 说话";
    [self removeVoiceindicator];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]){
        [self.delegate performSelector:@selector(didFinishRecoingVoiceAction:) withObject:nil];
    }
}
- (void)cancelRecord{
    NSLog(@"***************************** cancel");
    self.isRecordingVoice = NO;
    self.voicePanGuestureImageView.backgroundColor = VOICE_OFF_color;
    self.voiceLabel.text = self.isRecordingVoice ? @"松开 结束":@"按住 说话";
    [self removeVoiceindicator];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]){
        [self.delegate performSelector:@selector(didCancelRecordingVoiceAction:) withObject:nil];
    }
}

- (BFButtonView *)faceButton{
    if (!_faceButton) {
        _faceButton = [[BFButtonView alloc]initViewImage:@"face" imgframe:CGRectMake(0, 0, Screen_width/kChatFuntionNum, ChatInputBarHeight/2) inputBar:self btntag:BFFunctionViewShowFace];
    }
    return _faceButton;
}

- (BFButtonView *)voiceRecordButton{
    if (!_voiceRecordButton) {
        _voiceRecordButton = [[BFButtonView alloc]initViewImage:@"yuyin" imgframe:CGRectMake(0, 0, ChatInputBarHeight/2, ChatInputBarHeight/2) inputBar:self btntag:BFFunctionViewShowVoice];
        [_voiceRecordButton.pressBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [_voiceRecordButton.pressBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
    return _voiceRecordButton;
}

- (BFButtonView *)photoButton{
    if (!_photoButton) {
        _photoButton = [[BFButtonView alloc]initViewImage:@"picture" imgframe:CGRectMake(0, 0, Screen_width/kChatFuntionNum, ChatInputBarHeight/2) inputBar:self btntag:BFFunctionViewShowPicture];
    }
    return _photoButton;
    
}

- (BFButtonView *)drawButton{
    if (!_drawButton) {
        _drawButton = [[BFButtonView alloc]initViewImage:@"drawing" imgframe:CGRectMake(0, 0, Screen_width/kChatFuntionNum, ChatInputBarHeight/2) inputBar:self btntag:BFFunctionViewShowDraw];
    }
    return _drawButton;
}

- (BFButtonView *)shortVideoButton{
    if (!_shortVideoButton) {
        _shortVideoButton = [[BFButtonView alloc]initViewImage:@"short_video" imgframe:CGRectMake(0, 0, Screen_width/kChatFuntionNum, ChatInputBarHeight/2) inputBar:self btntag:BFFunctionViewShowShortVideo];
    }
    return _shortVideoButton;
}

- (BFButtonView *)presentButton{
    if (!_presentButton) {
        _presentButton = [[BFButtonView alloc]initViewImage:@"present" imgframe:CGRectMake(0, 0, Screen_width/kChatFuntionNum, ChatInputBarHeight/2) inputBar:self btntag:BFFunctionViewShowPresent];
    }
    return _presentButton;
}

- (BFButtonView *)moreButton{
    if (!_moreButton) {
        _moreButton = [[BFButtonView alloc]initViewImage:@"more" imgframe:CGRectMake(0, 0, Screen_width/kChatFuntionNum, ChatInputBarHeight/2) inputBar:self btntag:BFFunctionViewShowMore];
    }
    return _moreButton;
}


#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0; i < self.inputBtnArray.count ; i ++) {
        BFButtonView *btn = self.inputBtnArray[i];
        btn.frame = CGRectMake((Screen_width/self.inputBtnArray.count)*i, 0, Screen_width/self.inputBtnArray.count, self.height / 2);
    }
    self.voiceRecordButton.frame = CGRectMake(0, 0, ChatInputBarHeight / 2, ChatInputBarHeight / 2);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
        [self configureUI];
    }
    return self;
}

#pragma mark - 配置UI
- (void)configureUI{
    self.upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.height/2)];
    self.botView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.upView.frame), Screen_width, self.height/2)];
    self.upView.backgroundColor = BFColor(240, 240, 240, 1);
    self.botView.backgroundColor = BFColor(28, 29, 30, 1);
    
    
    
    [self addSubview:self.upView];
    [self addSubview:self.botView];
    
    UIView *view = self.textView;
    [self.upView addSubview:self.inputBackView];
    [self.upView addSubview:self.placeHolderLabel];
    [self.upView addSubview:self.textView];
    [self.upView addSubview:self.voicePanGuestureImageView];
    
    [self.botView addSubview:self.faceButton];
    [self.upView addSubview:self.voiceRecordButton];
    [self.botView addSubview:self.photoButton];
    [self.botView addSubview:self.drawButton];
    [self.botView addSubview:self.presentButton];
    [self.botView addSubview:self.moreButton];
    [self.botView addSubview:self.shortVideoButton];
    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    if ([hidebtn[@"Gift"]isEqualToString:@"0"] || [UserwordMsg isEqualToString:@"123456jm"]){
        self.drawButton.hidden = YES;
        self.presentButton.hidden = YES;
        self.inputBtnArray = @[self.photoButton,self.shortVideoButton,self.faceButton,self.moreButton];
    }else{
        self.inputBtnArray = @[self.photoButton,self.drawButton,self.shortVideoButton,self.presentButton,self.faceButton,self.moreButton];
        
    }
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - 键盘控制
- (void)keyboardFrameWillChange:(NSNotification *)notification{
    
    [self.superview addSubview:self.back];
    [self.superview bringSubviewToFront:self];
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.currentShowViewHeight = self.keyboardFrame.size.height;
    NSInteger duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] intValue];
    //    [self textViewDidChange:self.textView];
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, - self.keyboardFrame.size.height);
    } completion:^(BOOL finished) {
    }];
    if ([self.sendDelegate respondsToSelector:@selector(chatBar:changeKeyboardHeight:)]) {
        [self.sendDelegate chatBar:self changeKeyboardHeight:self.keyboardFrame.size.height];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    //    [self resignKeyboard:nil];
}

#pragma mark - 收回键盘
- (void)resignKeyboard:(UIButton *)btn{
    [self.textView resignFirstResponder];
    [self.back removeFromSuperview];
    [self showBottomView:nil button:nil];
    [UIView animateWithDuration:KeyboardDuration animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    if ([self.sendDelegate respondsToSelector:@selector(chatBar:changeKeyboardHeight:)]) {
        [self.sendDelegate chatBar:self changeKeyboardHeight:0];
    }
    
}

#pragma mark - 点击键盘
- (void)buttonAction:(UIButton *)btn{
    
    [self.superview addSubview:self.back];
    [self.superview bringSubviewToFront:self];
    
    switch (btn.tag) {
        case BFFunctionViewShowPicture:
            [self showBottomView:self.photoView button:btn];
            break;
        case BFFunctionViewShowFace:
            [self showBottomView:self.faceView button:btn];
            break;
        case BFFunctionViewShowVoice:
        {
            self.voiceRecordButton.stateHightLight = !self.voiceRecordButton.stateHightLight;
            
            self.voiceRecordButton.centerImg.image = self.voiceRecordButton.stateHightLight ? [UIImage imageNamed:@"yuyin_open"]:[UIImage imageNamed:@"yuyin"];
            self.voicePanGuestureImageView.hidden = !self.voiceRecordButton.stateHightLight;
//            [self showBottomView:self.recordVedioView button:btn];
//            UIButton *btn = [[UIButton alloc]init];
//            btn.tag = BFFunctionViewShowVoice;
            [self showBottomView:nil button:btn];
            break;
        }
        case BFFunctionViewShowDraw:
            NSLog(@"BFFunctionViewShowDraw");
            if ([self.delegate respondsToSelector:@selector(selectDrawing)]) {
                [self.delegate selectDrawing];
            }
            break;
        case BFFunctionViewShowPresent:
            NSLog(@"BFFunctionViewShowPresent");
            if ([self.delegate respondsToSelector:@selector(selectPresent)]) {
                [self.delegate selectPresent];
            }
            break;
        case BFFunctionViewShowMore:
            [self showBottomView:self.moreView button:btn];
            break;
        case BFFunctionViewShowShortVideo:
            NSLog(@"ggggggggggg");
            if ([self.delegate respondsToSelector:@selector(selectShortVideo)]) {
                [self.delegate selectShortVideo];
            }
            break;
        default:
            break;
    }
}

- (void)showBottomView:(UIView *)view button:(UIButton *)btn{
    
    NSArray *viewArr = @[self.faceView,self.moreView,self.recordVedioView,self.photoView];
    
    for (UIView *bottomView in viewArr) {
        if ([NSStringFromClass(bottomView.class) isEqualToString:NSStringFromClass(view.class)]) {
            [self.superview addSubview:bottomView];
            [UIView animateWithDuration:KeyboardDuration animations:^{
                [bottomView setFrame:CGRectMake(0, Screen_height - bottomView.height, Screen_width, bottomView.height)];
                
            } completion:nil];
            self.currentShowViewHeight = bottomView.height;
        }else{
            [UIView animateWithDuration:KeyboardDuration animations:^{
                [bottomView setFrame:CGRectMake(0, Screen_height, Screen_width, bottomView.height)];
            } completion:^(BOOL finished) {
                [bottomView removeFromSuperview];
            }];
           
        }
    }
    
    [self.textView resignFirstResponder];
    [self changeSelfFrameWithViewType:btn.tag];
}

- (void)changeSelfFrameWithViewType:(NSInteger)type{
    CGFloat height = 0.0;
    if (type == BFFunctionViewShowFace || type == BFFunctionViewShowPicture ) {
        height = - kFunctionFaceViewHeight;
    }else if ( type == BFFunctionViewShowVoice){
        height = - 0;
    }else if (type == BFFunctionViewShowMore){
        height = - kMoreViewHeight/2;
    }
    [UIView animateWithDuration:KeyboardDuration animations:^{
        self.transform = CGAffineTransformMakeTranslation(0,height);
    } completion:^(BOOL finished) {
        
    }];
    // 聊天上移
    if ([self.sendDelegate respondsToSelector:@selector(chatBar:changeKeyboardHeight:)]) {
        [self.sendDelegate chatBar:self changeKeyboardHeight: - height];
    }
}


#pragma mark - textview Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [self showBottomView:nil button:nil];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    CGRect textViewFrame = self.textView.frame;
    
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), MAXFLOAT)];
    self.textView.contentSize = CGSizeMake(textSize.width, textSize.height);
    if (textSize.height > 4 * 25.0f) {
        textSize.height = 4 * 25.0f;
    }
    CGFloat textviewHeight = MAX(70*ScreenRatio/2 - 5, textSize.height);
    NSLog(@" ------------  %f",self.currentShowViewHeight);
    self.upView.frame = CGRectMake(0, 0, Screen_width, textviewHeight + 5);
    self.botView.frame = CGRectMake(0, CGRectGetMaxY(self.upView.frame), Screen_height, 70*ScreenRatio/2);
    
    self.textView.frame = CGRectMake(30*ScreenRatio+10, 5, Screen_width - 31*ScreenRatio-30, textviewHeight);
    self.inputBackView.frame = CGRectMake(_textView.origin.x-1, _textView.origin.y-1, _textView.size.width+2, _textView.size.height+2);
    self.placeHolderLabelBackView.size = CGSizeMake(_textView.size.width, _textView.size.height-2);
    self.placeHolderLabelBackView.origin = CGPointMake(1, 1);
    
    CGFloat y = Screen_height - self.currentShowViewHeight - 70*ScreenRatio;
    self.frame = CGRectMake(0, y - (self.upView.height + self.botView.height - 70*ScreenRatio), Screen_width, self.upView.height + self.botView.height);
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    
    if (!isDelete && str.length > 0) {
        if (self.version >= 7.0) {
            NSRange range = [self.textView selectedRange];
            [attr insertAttributedString:[[EaseEmotionEscape sharedInstance] attStringFromTextForInputView:str textFont:self.textView.font] atIndex:range.location];
            self.textView.attributedText = attr;
        } else {
            self.textView.text = @"";
            self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
        }
    }
    else {
        if (self.version >= 7.0) {
            if (chatText.length > 0) {
                NSInteger length = 1;
                if (chatText.length >= 2) {
                    NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                    if ([EaseEmoji stringContainsEmoji:subStr]) {
                        length = 2;
                    }
                }
                self.textView.attributedText = [self backspaceText:attr length:length];
            }
        } else {
            if (chatText.length >= 2)
            {
                NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                if ([(EaseFaceView *)self.faceView stringIsFace:subStr]) {
                    self.textView.text = [chatText substringToIndex:chatText.length-2];
                    [self textViewDidChange:self.textView];
                    return;
                }
            }
            
            if (chatText.length > 0) {
                self.textView.text = [chatText substringToIndex:chatText.length-1];
            }
        }
    }
    
    [self textViewDidChange:self.textView];
}

-(NSMutableAttributedString*)backspaceText:(NSMutableAttributedString*) attr length:(NSInteger)length
{
    NSRange range = [self.textView selectedRange];
    if (range.location == 0) {
        return attr;
    }
    [attr deleteCharactersInRange:NSMakeRange(range.location - length, length)];
    return attr;
}

- (void)sendFace
{
    NSString *chatText = self.textView.text;
    if (chatText.length > 0) {
        if ([self.sendDelegate respondsToSelector:@selector(chatBar:sendMessage:)]) {
            
            if (![_textView.text isEqualToString:@""]) {
                
                //转义回来
                NSMutableString *attStr = [[NSMutableString alloc] initWithString:self.textView.attributedText.string];
                [_textView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                     inRange:NSMakeRange(0, self.textView.attributedText.length)
                                                     options:NSAttributedStringEnumerationReverse
                                                  usingBlock:^(id value, NSRange range, BOOL *stop)
                 {
                     if (value) {
                         EMTextAttachment* attachment = (EMTextAttachment*)value;
                         NSString *str = [NSString stringWithFormat:@"%@",attachment.imageName];
                         [attStr replaceCharactersInRange:range withString:str];
                     }
                 }];
                [self.sendDelegate chatBar:self sendMessage:attStr];
                self.textView.text = @"";
                [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.textView]];;
            }
        }
    }
}

#pragma mark - private input view

- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < 36) {
        toHeight = 36;
    }
    if (toHeight > 150) {
        toHeight = 150;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.frame;
        rect.size.height += changeHeight;
        self.frame = rect;
        
        if (self.version < 7.0) {
            [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
        
        //        if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
        //            [_delegate chatToolbarDidChangeFrameToHeight:self.frame.size.height];
        //        }
    }
}

#pragma mark - private bottom view

//- (void)_willShowBottomHeight:(CGFloat)bottomHeight
//{
//    CGRect fromFrame = self.frame;
//    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
//    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
//
//    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
//    {
//        return;
//    }
//
//    if (bottomHeight == 0) {
//        self.isShowButtomView = NO;
//    }
//    else{
//        self.isShowButtomView = YES;
//    }
//
//    self.frame = toFrame;
//
//    if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
//        [_delegate chatToolbarDidChangeFrameToHeight:toHeight];
//    }
//}
//
//- (void)_willShowBottomView:(UIView *)bottomView
//{
//    if (![self.activityButtomView isEqual:bottomView]) {
//        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
//        [self _willShowBottomHeight:bottomHeight];
//
//        if (bottomView) {
//            CGRect rect = bottomView.frame;
//            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
//            bottomView.frame = rect;
//            [self addSubview:bottomView];
//        }
//
//        if (self.activityButtomView) {
//            [self.activityButtomView removeFromSuperview];
//        }
//        self.activityButtomView = bottomView;
//    }
//}
//
//- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
//{
//    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
//    {
//        [self _willShowBottomHeight:toFrame.size.height];
//        if (self.activityButtomView) {
//            [self.activityButtomView removeFromSuperview];
//        }
//        self.activityButtomView = nil;
//    }
//    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
//    {
//        [self _willShowBottomHeight:0];
//    }
//    else{
//        [self _willShowBottomHeight:toFrame.size.height];
//    }
//}


- (void)sendFaceWithEmotion:(EaseEmotion *)emotion
{
    if (emotion) {
        if ([self.sendDelegate respondsToSelector:@selector(didSendText:withExt:)]) {
            [self.sendDelegate didSendText:emotion.emotionTitle withExt:@{EASEUI_EMOTION_DEFAULT_EXT:emotion}];
            [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.textView]];;
        }
    }
}

#pragma mark -  BFPhotoPickerDelegate
// 点击发送按钮发送图片
- (void)sendPicture:(NSMutableArray *)imgArray{
    if ([self.sendDelegate respondsToSelector:@selector(chatBar:sendPhotoes:)]) {
        [self.sendDelegate chatBar:self sendPhotoes:imgArray];
    }
}


#pragma mark - UITextViewDelegate
// 发送文本表情信息
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.placeHolderLabel.text = ([self.textView.text isEqualToString:@""]||self.textView.text == nil) ? @"请输入消息...":@"";
    });
    
    if ([text isEqualToString:@"\n"]) {
        self.upView.frame = CGRectMake(0, 0, Screen_width, 70*ScreenRatio/2);
        self.botView.frame = CGRectMake(0, CGRectGetMaxY(self.upView.frame), Screen_width, 70*ScreenRatio/2);
        self.textView.frame = TextViewFrame;
        self.textView.contentSize = CGSizeMake(Screen_width - 35*ScreenRatio, 70*ScreenRatio/2 - 5);
        CGFloat y = Screen_height - self.keyboardFrame.size.height - 70*ScreenRatio;
        self.frame = CGRectMake(0, y, Screen_width, 70*ScreenRatio);
        
        [self sendTextMessage:textView.text];
        return NO;
    }else if (text.length == 0){
        //判断删除的文字是否符合表情文字规则
        NSString *deleteText = [textView.text substringWithRange:range];
        NSLog(@"%@",deleteText);
        NSUInteger location = range.location; // 3
        NSUInteger length = range.length; // 1
        if ([deleteText isEqualToString:@"]"]) {
            
            NSString *subText;
            while (YES) {
                if (location == 0) {
                    return YES;
                }
                location --;
                length ++ ;
                subText = [textView.text substringWithRange:NSMakeRange(location, length)];
                NSLog(@"%@",subText);
                if (([subText hasPrefix:@"["] && [subText hasSuffix:@"]"])) {
                    break;
                }
            }
            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
            [textView setSelectedRange:NSMakeRange(location, 0)];
            [self textViewDidChange:self.textView];
            return NO;
        }else{
            textView.text = [textView.text stringByReplacingCharactersInRange:range withString:@""];
            //            [self textViewDidChange:self.textView];
        }
    }
    return YES;
}


#pragma mark - 发送文本表情类消息

- (void)sendTextMessage:(NSString *)text{
    if (!text || text.length == 0) {
        return;
    }
    
    if (self.sendDelegate && [self.sendDelegate respondsToSelector:@selector(chatBar:sendMessage:)]) {
        [self.sendDelegate chatBar:self sendMessage:text];
    }
    //    self.inputText = @"";
    self.textView.text = @"";
    
}

#pragma mark - BFChatMoreItemDelegate

- (void)chatMoreViewItemSelect:(BFMoreViewShowType)type{
    if ([self.delegate respondsToSelector:@selector(selectMoreViewItemType:)]) {
        [self.delegate selectMoreViewItemType:type];
    }
}


- (void)setFrame:(CGRect)frame animated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            [self setFrame:frame];
        }];
    }else{
        [self setFrame:frame];
    }
    
}
- (CGFloat)bottomHeight{
    
    if (self.faceView.superview || self.moreView.superview) {
        return MAX(self.keyboardFrame.size.height, MAX(self.faceView.frame.size.height, self.moreView.frame.size.height));
    }else{
        return MAX(self.keyboardFrame.size.height, CGFLOAT_MIN);
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
