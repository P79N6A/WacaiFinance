//
//  FSTabBarMessageRequest.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/8/30.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSTabBarMessageRequest.h"
#import "EnvironmentInfo.h"
#import "FSAPPRequestInterface.h"

@implementation FSTabBarMessageRequest

- (NSString *)requestUrl {
    NSString *financeBaseURL = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
    return [NSString stringWithFormat:@"%@%@", financeBaseURL, fs_tabBar_message];
}

@end
