//
//  FSAccountSettingsUserStatus.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/20.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FSUserFinanceState) {
    FSUserFinanceStateNegative = 0,
    FSUserFinanceStatePositive,
    FSUserFinanceStateUnknown,
};


NS_ASSUME_NONNULL_BEGIN

@interface FSAccountSettingsUserStatus : NSObject

@property (strong, nonatomic) NSNumber *bindCardStatus;
@property (strong, nonatomic) NSNumber *realNameStatus;
@property (strong, nonatomic) NSNumber *bankDepositoryStatus;

- (instancetype)initWithData:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
