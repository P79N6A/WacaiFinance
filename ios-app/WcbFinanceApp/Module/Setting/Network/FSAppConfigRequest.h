//
//  FSAppConfigRequest.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/16.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <i-Finance-Library/FSSDKRequest.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((deprecated("FSAppConfigRequest is deprecated, use HiveConfig SDK instead.")))

@interface FSAppConfigRequest : FSSDKRequest

- (instancetype)initWithKey:(NSString *)configKey;

@end

NS_ASSUME_NONNULL_END
