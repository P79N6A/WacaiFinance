//
//  FSBankAccountEntranceRequest.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 13/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSBankAccountEntranceRequest.h"
#import "EnvironmentInfo.h"

@implementation FSBankAccountEntranceRequest

- (NSString *)requestUrl {
    NSString *financeBaseURL = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
    return [NSString stringWithFormat:@"%@%@", financeBaseURL, fs_passwordManager];
}

@end
