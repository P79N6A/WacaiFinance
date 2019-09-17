//
//  FSHTTPDNSWhiteListRequest.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/4.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSHTTPDNSWhiteListRequest.h"

@implementation FSHTTPDNSWhiteListRequest

- (instancetype)initWithKey:(NSString *)configKey
{
    self = [super initWithKey:configKey];
    if(self)
    {
        self.ignoreCache = YES;
    }
    return self;
}

- (id)requestParam {
    return @{
             @"subModule": @"frontconfig",
             @"key": @[@"http_dns_whitelist"]
             };
}

- (NSInteger)cacheTimeInSeconds
{
    return 10000;
}

@end
