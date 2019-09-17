//
//  FSAccountSettingsModel.m
//  WcbFinanceApp
//
//  Created by howie on 2019/8/9.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAccountSettingsModel.h"

@implementation FSAccountSettingsModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"groupID" : @"groudID",
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"items" : [FSAccountSettingsItemModel class],
             };
}

@end
