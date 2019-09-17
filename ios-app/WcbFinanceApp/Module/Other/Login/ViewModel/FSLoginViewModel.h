//
//  FSLoginViewModel.h
//  FinanceApp
//
//  Created by Alex on 1/17/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FSLoginViewModel : NSObject

@property (nonatomic, strong) RACCommand *thirdLogin;
@property (nonatomic, assign) BOOL fromRegistration;

@end
