//
//  FSHiveConfigEvent.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/26.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FSHiveConfigErrorType) {
    FSHiveConfigErrorTypeNet,
    FSHiveConfigErrorTypeData
};

@interface FSHiveConfigEvent : NSObject

+ (void)hiveConfigEvent:(NSString *)key errorType:(FSHiveConfigErrorType)errorType;

@end

NS_ASSUME_NONNULL_END
