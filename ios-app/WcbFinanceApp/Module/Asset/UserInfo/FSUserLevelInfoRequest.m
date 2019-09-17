//
//  FSUserLevelInfoRequest.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/8/28.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSUserLevelInfoRequest.h"
#import "EnvironmentInfo.h"
#import "FSAPPRequestInterface.h"

@implementation FSUserLevelInfoRequest

- (NSString *)requestUrl {
    NSString *memberCenterHost = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeMemberCenter];
    return [NSString stringWithFormat:@"%@/api/vip/levelInfo", memberCenterHost];
}

@end
