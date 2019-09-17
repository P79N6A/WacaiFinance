//
//  FSAgreementModel.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/19.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAgreementModel.h"

@implementation FSAgreementModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"agreementTitle" : @"agreementName",
             @"agreementURL" : @"agreementUrl"
             };
}

@end
