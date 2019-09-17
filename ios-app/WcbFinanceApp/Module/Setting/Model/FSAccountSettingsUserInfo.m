//
//  FSDiscoveryUserInfo.m
//  Financeapp
//
//  Created by kuyeluofan on 20/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAccountSettingsUserInfo.h"

@implementation FSAccountSettingsUserInfo

- (NSString *)nickname {
    if (!_nickname) {
        if (!USER_INFO.mNickName || [USER_INFO.mNickName isEqualToString:@""]) {
            _nickname = @"";
        } else {
            _nickname = USER_INFO.mNickName;
        }
    }
    return _nickname;
}

- (UIImage *)avatar {
    if (!_avatar) {
        if (!USER_INFO.userAvator) {
            //默认头像
            _avatar = [UIImage imageNamed:@"default_profile"];
        } else {
            _avatar = USER_INFO.userAvator;
        }
    }
    return _avatar;
}

@end
