//
//  AppointmentAlert.h
//  BFTest
//
//  Created by 伯符 on 17/1/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AppointmentAlertType){
    AppointmentAlertTypeWaitting,
    AppointmentAlertTypeNoresponse,
    AppointmentAlertTypeRefuse,
    AppointmentAlertTypeAgree,
};

@interface AppointmentAlert : UIView

- (void)showAlert:(AppointmentAlertType)type;


@end
