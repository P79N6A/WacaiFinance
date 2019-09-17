//
//  FSDiscoveryPostRequest.m
//  Financeapp
//
//  Created by kuyeluofan on 26/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryPostRequest.h"
#import "EnvironmentInfo.h"
#import "FSAPPRequestInterface.h"

@implementation FSDiscoveryPostRequest

- (NSString *)requestUrl {
    NSString *financeBaseURL = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
    return [NSString stringWithFormat:@"%@%@", financeBaseURL, fs_discovery_post];
}


- (id)requestParam {
    return @{
             @"moduleId"        : self.moduleId,
             @"lastPublishTime" : self.lastPublishTime,
             @"pageSize"        : self.pageSize
             };
}

- (NSString *)moduleId {
    if (!_moduleId) {
        _moduleId = @"";
    }
    return _moduleId;
}

- (NSNumber *)lastPublishTime {
    if (!_lastPublishTime) {
        _lastPublishTime = @0;
    }
    return _lastPublishTime;
}

- (NSNumber *)pageSize {
    if (!_pageSize) {
        _pageSize = @10;
    }
    return _pageSize;
}



@end
