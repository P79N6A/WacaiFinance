//
//  FSVerificationCodeAlertView.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/1/24.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CMUIAlertView/CMUIAlertView.h>

@interface FSVerificationCodeAlertView : CMCustomAlertView

@property (nonatomic, copy) void(^refreshVercodeBlock)(UIButton *imageBtn);
@property (nonatomic, strong, readonly) NSString *imageVercode;
@property (nonatomic, strong) NSString *tips;


@end
