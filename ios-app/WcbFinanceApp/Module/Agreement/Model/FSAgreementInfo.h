//
//  FSAgreementInfo.h
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/19.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAgreementModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSAgreementInfo : NSObject

@property (nonatomic, strong) NSArray<FSAgreementModel *> *agreementArray;
@property (nonatomic, assign) BOOL focus; //是否需要选中
@property (nonatomic, assign) NSUInteger loginMax;
@property (nonatomic, assign) NSUInteger registerMax;

@end

NS_ASSUME_NONNULL_END
