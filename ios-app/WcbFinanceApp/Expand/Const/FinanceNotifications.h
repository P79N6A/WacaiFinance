//
//  FinanceNotifications.h
//  FinanceApp
//
//  Created by new on 15/1/27.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#ifndef FinanceApp_FinanceNotifications_h
#define FinanceApp_FinanceNotifications_h

  
// 移除手势密码. 例如，密码更改后可能需要移除手势密码.
#define NOTIFY_REMOVE_GUESTURE_PASSWORD  @"NotificationRemoveGuesturePassword"

// 设置手势密码. 包括重设手势密码.
#define NOTIFY_SET_GUESTURE_PASSWORD     @"NotificationRemoveGuesturePassword"

// 启动界面加载完毕
#define NOTIFY_LAUNCH_SCREEN_APPEAR      @"NotificationLaunchScreenAppear"

// 用户切换. 包括登录，注销，切换用户等.
#define NOTIFY_USER_SWITCHED             @"NotificationUserSwitched"

#define ThirdActionLoginSucessNotifyName @"kThirdActionLoginSucessNotify"
#define ThirdActionLoginFailNotifyName   @"kThirdActionLoginFailNotify"
#define ThirdActionLogoutNofityName      @"kThirdActionLogoutNofity"
#define ThirdActonShareSucessNofifyName  @"kThirdActonShareSucessNofify"
#define ThirdActionShareFailNotifyName   @"kThirdActionShareFailNotify"
#define ThirdActionShareCancelNotifyName @"kThirdActionShareCancelNotify"

#define StopNextLoadNotify @"StopNextLoadName"


#define FSLoginDidFinishNotification      @"com.hangzhoucaimi.finance.login.completion"
#define FSLoginCancelNotification      @"com.hangzhoucaimi.finance.login.cancel"


// 有新的消息
#define NOTIFY_NEWS_ARRIVAL              @"NotificationNewsArrival"



#endif



