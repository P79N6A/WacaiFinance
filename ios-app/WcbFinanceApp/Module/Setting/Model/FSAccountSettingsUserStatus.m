//
//  FSAccountSettingsUserStatus.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/20.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAccountSettingsUserStatus.h"

@implementation FSAccountSettingsUserStatus

- (instancetype)initWithData:(NSDictionary *)dataDic {
    self = [super init];
    if (self) {
        _bindCardStatus       = [dataDic fs_objectMaybeNilForKey:@"bindCardStatus"];
        _realNameStatus       = [dataDic fs_objectMaybeNilForKey:@"realNameStatus"];
        _bankDepositoryStatus = [dataDic fs_objectMaybeNilForKey:@"bankDepositoryStatus"];
    }
    return self;
}

- (NSNumber *)bindCardStatus {
    if (!_bindCardStatus) {
        _bindCardStatus = @(FSUserFinanceStateUnknown);
    }
    return _bindCardStatus;
}

- (NSNumber *)realNameStatus {
    if (!_realNameStatus) {
        _realNameStatus = @(FSUserFinanceStateUnknown);
    }
    return _realNameStatus;
}

- (NSNumber *)bankDepositoryStatus {
    if (!_bankDepositoryStatus) {
        _bankDepositoryStatus = @(FSUserFinanceStateUnknown);
    }
    return _bankDepositoryStatus;
}

@end
