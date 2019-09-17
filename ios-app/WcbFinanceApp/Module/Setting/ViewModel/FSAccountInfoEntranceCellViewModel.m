//
//  FSAccountInfoEntranceCellViewModel.m
//  FinanceApp
//
//  Created by kuyeluofan on 19/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSAccountInfoEntranceCellViewModel.h"
#import "FSAccountSettingsUserInfo.h"

@implementation FSAccountInfoEntranceCellViewModel

- (instancetype)initWithUserInfo:(FSAccountSettingsUserInfo *)userInfo {
    self = [super init];
    if (self) {
        _avatar = userInfo.avatar;
        _nickname = userInfo.nickname;
        _linkURL = @"nt://WcbFinanceApp/account-info";
    }
    return self;
}

- (NSString *)nickname {
    if (USER_INFO.isLogged) {
        return _nickname;
    } else {
        return @"立即登录";
    }
}

- (NSString *)skylineEventName {
    if (USER_INFO.isLogged) {
        return @"finance_wcb_accountsetting_portrait_click";
    } else {
        return @"finance_wcb_accountsetting_login_click";
    }
}

@end
