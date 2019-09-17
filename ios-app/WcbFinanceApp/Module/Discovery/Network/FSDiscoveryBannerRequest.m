//
//  FSDiscoveryBannerRequest.m
//  Financeapp
//
//  Created by 叶帆 on 23/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBannerRequest.h"
#import "EnvironmentInfo.h"
#import "FSAPPRequestInterface.h"

@implementation FSDiscoveryBannerRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ignoreCache = YES;
    }
    return self;
}

- (NSInteger)cacheTimeInSeconds {
    return INT_MAX;
}

- (NSString *)requestUrl {
    NSString *financeBaseURL = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
    return [NSString stringWithFormat:@"%@%@", financeBaseURL, fs_discovery_banner];
}

- (id)requestParam {
    return @{
             @"belongModule"        : self.belongModule
             };
}

- (CMRequestMethod)requestMethod {
    return CMRequestMethodGET;
}




@end
