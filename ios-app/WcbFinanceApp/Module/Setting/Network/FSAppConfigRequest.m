//
//  FSAppConfigRequest.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/16.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAppConfigRequest.h"
#import "EnvironmentInfo.h"

@implementation FSAppConfigRequest {
    NSArray<NSString *> *_configKeys;
}

- (instancetype)initWithKey:(NSString *)configKey {
    return [self initWithKeys:@[configKey]];
}

- (instancetype)initWithKeys:(NSArray *)configKeys {
    self = [super init];
    if (self) {
        _configKeys = configKeys;
    }
    return self;
}

- (NSString *)requestUrl {
    BOOL isDebug = [EnvironmentInfo sharedInstance].isDebugEnvironment;
    NSString *host = isDebug ? @"http://app.finance.k2.test.wacai.info" : @"https://8.wacai.com";
    return [NSString stringWithFormat:@"%@/finance/akita/api/hive", host];
}

- (id)requestParam {
    return @{
             @"subModule": @"frontconfig",
             @"key": _configKeys ?: @[]
             };
}

- (CMRequestMethod)requestMethod {
    return CMRequestMethodPOST;
}


@end
