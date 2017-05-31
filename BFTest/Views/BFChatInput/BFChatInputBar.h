//
//  BFChatInputBar.h
//  BFTest
//
//  Created by 伯符 on 16/7/5.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BFChatMoreView.h"
#import "EaseFaceView.h"
#import "BFPhotoPicker.h"
#import "BFVedioView.h"

#define kMaxHeight 60.0f
#define kMinHeight 45.0f
#define kFunctionFaceViewHeight ((210.0/375)*320)*ScreenRatio
#define kMoreViewHeight         ((180.0/375)*320)*ScreenRatio
/**
 *  functionView 类型
 */
typedef NS_ENUM(NSUInteger, BFFunctionViewShowType){
    BFFunctionViewShowNothing /**< 不显示functionView */,
    BFFunctionViewShowFace /**< 显示表情View */,
    BFFunctionViewShowVoice /**< 显示录音view */,
    BFFunctionViewShowPicture /**< 显示图片view */,
    BFFunctionViewShowDraw /**< 显示画图view */,
    BFFunctionViewShowShortVideo /**< 显示短视频 */,
    BFFunctionViewShowPresent /**< 显示地图view */,
    BFFunctionViewShowMore /**< 显示更多view */,
    BFFunctionViewShowKeyboard /**< 显示键盘 */,
};

@protocol BFChatSendDelegate;


/**
 *  选择画图
 */
@protocol BFInputBtnSelectDelegate <NSObject>

@required

- (void)selectDrawing;

- (void)selectMoreViewItemType:(BFMoreViewShowType)type;

- (void)selectShortVideo;

- (void)selectPresent;

@end



@interface BFChatInputBar : UIView

@property (strong,nonatomic) UIButton *back;

@property (strong, nonatomic) EaseFaceView *faceView;

@property (strong,nonatomic) BFPhotoPicker *photoView;

@property (strong, nonatomic) BFChatMoreView *moreView; /**< 当前活跃的底部view,用来指向moreView */

@property (strong, nonatomic) BFVedioView *recordVedioView; /**< 当前活跃的底部view,录音功能 */
@property (nonatomic,assign) id <BFInputBtnSelectDelegate> delegate;

@property (nonatomic,assign) id <BFChatSendDelegate> sendDelegate;

- (void)buttonAction:(UIButton *)btn;


@end

@protocol BFChatSendDelegate <NSObject>

- (void)chatBar:(BFChatInputBar *)chatBat changeKeyboardHeight:(CGFloat)height;

/**
 *  发送普通的文字信息,可能带有表情
 *
 *  @param chatBar
 *  @param message 需要发送的文字信息
 */
- (void)chatBar:(BFChatInputBar *)chatBar sendMessage:(NSString *)message;

/**
 *  发送图片照片
 *
 *  @param chatBar
 *  @param message 需要发送的图片
 */
- (void)chatBar:(BFChatInputBar *)chatBar sendPhotoes:(NSMutableArray *)pictures;


- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext;

- (void)showphotoAccessibleAlert;

@end
