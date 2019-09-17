//
//  FSAgreementManager.h
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/19.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAgreementInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^FSAgreementLoadCompletionBlock)(FSAgreementInfo * _Nullable agreementInfo, BOOL isCache);

@interface FSAgreementManager : NSObject

+ (void)loadRegisterAgreements:(FSAgreementLoadCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
