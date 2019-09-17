//
//  FSEnterPasswordViewModel.h
//  FinanceApp
//
//  Created by Alex on 7/5/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FSEnterPasswordViewModel : NSObject

@property (nonatomic, copy) NSString *accountString;
@property (nonatomic, copy) NSString *pwdString;
@property (nonatomic, copy) NSString *tipString;

@property (nonatomic, copy) NSString *verifyTips;
@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, assign, readonly) BOOL needVerifyCode;
@property (nonatomic, strong) NSURL *verifyCodeImageURL;

@property (nonatomic, strong) RACCommand *loginCmd;

@property (nonatomic, assign) BOOL acceptAgreements;


@end
