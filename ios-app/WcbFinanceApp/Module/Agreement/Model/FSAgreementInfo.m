//
//  FSAgreementInfo.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/19.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAgreementInfo.h"

@implementation FSAgreementInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"agreementArray" : @"agreements"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"agreementArray" : [FSAgreementModel class]};
}

@end
