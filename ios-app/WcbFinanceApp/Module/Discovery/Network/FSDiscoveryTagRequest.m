//
//  FSDiscoveryTagRequest.m
//  Financeapp
//
//  Created by 叶帆 on 23/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryTagRequest.h"
#import "EnvironmentInfo.h"
#import "FSAPPRequestInterface.h"

@implementation FSDiscoveryTagRequest

- (NSString *)requestUrl {
    NSString *financeBaseURL = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
    return [NSString stringWithFormat:@"%@%@", financeBaseURL, fs_discovery_tag];
}

@end
