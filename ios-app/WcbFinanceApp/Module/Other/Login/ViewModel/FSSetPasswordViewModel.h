//
//  FSSetPasswordViewModel.h
//  FinanceApp
//
//  Created by Alex on 7/4/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSFloatWindowViewModel.h"

@interface FSSetPasswordViewModel : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPassword;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL agreeProtocol;

@property (nonatomic, copy) NSString *smsImageVerCode;
@property (nonatomic, copy) NSString *smsTips;

@property (nonatomic, copy) NSString *voiceImageVerCode;
@property (nonatomic, copy) NSString *voiceTips;

@property (nonatomic, strong) RACCommand *getSMSCodeCmd;
@property (nonatomic, strong) RACCommand *getVoiceCodeCmd;
@property (nonatomic, strong) RACCommand *registerCmd;

@property (nonatomic, strong) FSFloatWindowViewModel *floatWindowViewModel;



@end
