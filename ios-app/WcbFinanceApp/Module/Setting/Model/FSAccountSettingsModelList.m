//
//  FSAccountSettingsModelList.m
//  WcbFinanceApp
//
//  Created by howie on 2019/8/9.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAccountSettingsModelList.h"

@implementation FSAccountSettingsModelList

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"groups" : [FSAccountSettingsModel class],
             };
}

@end
