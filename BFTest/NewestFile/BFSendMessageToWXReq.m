//
//  BFSendMessageToWXReq.m
//  BFTest
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFSendMessageToWXReq.h"

@implementation BFSendMessageToWXReq

+ (void)shareAction {
    
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = kLinkTitle;//分享标题
    urlMessage.description = kLinkDescription;//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"appIcon"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkURL;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}

@end
