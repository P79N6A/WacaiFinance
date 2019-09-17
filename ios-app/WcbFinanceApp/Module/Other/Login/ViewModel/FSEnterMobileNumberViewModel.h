//
//  FSEnterMobileNumberViewModel.h
//  FinanceApp
//
//  Created by Alex on 7/5/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN
@interface FSEnterMobileNumberViewModel : NSObject

@property (nonatomic, copy, nullable) NSString *mobileString;
@property (nonatomic, strong) RACCommand *mobileHasRegisteCmd;

@end
NS_ASSUME_NONNULL_END
