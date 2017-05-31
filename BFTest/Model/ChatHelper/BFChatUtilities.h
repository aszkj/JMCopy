//
//  BFChatUtilities.h
//  BFTest
//
//  Created by 伯符 on 16/7/14.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#ifndef BFChatUtilities_h
#define BFChatUtilities_h


#pragma mark - XMNMessage 相关key值定义

/**
 *  消息聊天类型
 */
typedef NS_ENUM(NSUInteger, BFMessageChat){
    BFMessageChatSingle = 0 /**< 单人聊天,不显示nickname */,
    BFMessageChatGroup /**< 群组聊天,显示nickname */,
};

/**
 *  XMNChatMessageCell menu对应action类型
 */
typedef NS_ENUM(NSUInteger, BFChatMessageCellMenuActionType) {
    BFChatMessageCellMenuActionTypeCopy, /**< 复制 */
    BFChatMessageCellMenuActionTypeRelay, /**< 转发 */
};

/**
 *  消息读取状态,接收的消息时有
 */
typedef NS_ENUM(NSUInteger, BFMessageReadState) {
    BFMessageUnRead = 0 /**< 消息未读 */,
    BFMessageReading /**< 正在接收 */,
    BFMessageReaded /**< 消息已读 */,
};


/**
 *  消息发送状态,自己发送的消息时有
 */
typedef NS_ENUM(NSUInteger, BFMessageSendState){
    BFMessageSendSuccess = 0 /**< 消息发送成功 */,
    BFMessageSendStateSending, /**< 消息发送中 */
    BFMessageSendFail /**< 消息发送失败 */,
};


/**
 *  消息拥有者类型
 */
typedef NS_ENUM(NSUInteger, BFMessageOwner){
    BFMessageOwnerUnknown = 0 /**< 未知的消息拥有者 */,
    BFMessageOwnerSystem /**< 系统消息 */,
    BFMessageOwnerSelf /**< 自己发送的消息 */,
    BFMessageOwnerOther /**< 接收到的他人消息 */,
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSUInteger, BFMessageType){
    BFMessageTypeUnknow  /**< 未知的消息类型 */,
    BFMessageTypeSystem /**< 系统消息 */,
    BFMessageTypeText /**< 文本消息 */,
    BFMessageTypeImage /**< 图片消息 */,
    BFMessageTypeVoice /**< 语音消息 */,
    BFMessageTypeVideo /**< 视频消息 */,
    BFMessageTypeLocation /**< 地理位置消息 */,
//    BFMessageIsTimeShow,
};

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, BFVoiceMessageState){
    BFVoiceMessageStateNormal,/**< 未播放状态 */
    BFVoiceMessageStateDownloading,/**< 正在下载中 */
    BFVoiceMessageStatePlaying,/**< 正在播放 */
    BFVoiceMessageStateCancel,/**< 播放被取消 */
};



/**
 *  消息类型的key
 */
static NSString *const kBFMessageConfigurationTypeKey = @"kBFNMessageConfigurationTypeKey";
/**
 *  消息拥有者的key
 */
static NSString *const kBFMessageConfigurationOwnerKey = @"kBFMessageConfigurationOwnerKey";
/**
 *  消息群组类型的key
 */
static NSString *const kBFMessageConfigurationGroupKey = @"kBFMessageConfigurationGroupKey";

/**
 *  消息昵称类型的key
 */
static NSString *const kBFMessageConfigurationNicknameKey = @"kBFMessageConfigurationNicknameKey";

/**
 *  消息头像类型的key
 */
static NSString *const kBFMessageConfigurationAvatarKey = @"kBFMessageConfigurationAvatarKey";

/**
 *  消息阅读状态类型的key
 */
static NSString *const kBFMessageConfigurationReadStateKey = @"kBFMessageConfigurationReadStateKey";

/**
 *  消息发送状态类型的key
 */
static NSString *const kBFMessageConfigurationSendStateKey = @"kBFMessageConfigurationSendStateKey";

/**
 *  文本消息内容的key
 */
static NSString *const kBFMessageConfigurationTextKey = @"kBFMessageConfigurationTextKey";
/**
 *  图片消息内容的key
 */
static NSString *const kBFMessageConfigurationImageKey = @"kBFMessageConfigurationImageKey";

/**
 *  视频消息内容的key
 */
static NSString *const kBFMessageConfigurationVideoKey = @"kBFMessageConfigurationVideoKey";

/**
 *  语音消息内容的key
 */
static NSString *const kBFMessageConfigurationVoiceKey = @"kBFMessageConfigurationVoiceKey";

/**
 *  语音消息时长key
 */
static NSString *const kBFMessageConfigurationVoiceSecondsKey = @"kBFMessageConfigurationVoiceSecondsKey";

/**
 *  地理位置消息内容的key
 */
static NSString *const kBFMessageConfigurationLocationKey = @"kBFMessageConfigurationLocationKey";

static NSString *const kBFMessageTimeKey = @"com.kBFMessageTimeKey";

#endif /* BFChatUtilities_h */
