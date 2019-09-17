//
//  FSUserStatusRequest.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/18.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSUserStatusRequest.h"
#import "EnvironmentInfo.h"

@implementation FSUserStatusRequest

- (NSString *)requestUrl {
    return fs_userStatus;
}

- (NSString *)baseUrl {
    return [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
}


@end
