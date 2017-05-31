//
//  BFChatMoreView.h
//  BFTest
//
//  Created by 伯符 on 16/7/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  functionView 类型
 */
typedef NS_ENUM(NSUInteger, BFMoreViewShowType){
    BFMoreViewShowVedio /**< 显示视频*/,
    BFMoreViewShowMoneyPacket /**< 显示红包 */,
    BFMoreViewShowCollection /**< 显示收藏 */,
    BFMoreViewShowLocation /**< 显示位置 */,
    BFMoreViewShowCall,/**< 语音通话 */

};

@protocol BFChatMoreItemDelegate <NSObject>

@required
- (void)chatMoreViewItemSelect:(BFMoreViewShowType)type;

@end

@interface BFChatMoreView : UIView

@property (nonatomic,assign) id <BFChatMoreItemDelegate> delegate;

@end
