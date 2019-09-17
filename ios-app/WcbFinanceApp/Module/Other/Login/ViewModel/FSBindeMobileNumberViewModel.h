//
//  FSBindeMobileNumberViewModel.h
//  FinanceApp
//
//  Created by Alex on 7/12/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FSBindeMobileNumberViewModel : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *smsImageVerCode;
@property (nonatomic, copy) NSString *smsTips;

@property (nonatomic, copy) NSString *voiceTips;
@property (nonatomic, copy) NSString *voiceImageVerCode;

@property (nonatomic, strong) RACCommand *getSMSCodeCmd;
@property (nonatomic, strong) RACCommand *getVoiceCodeCmd;
@property (nonatomic, strong) RACCommand *bindMobileCmd;

@property (nonatomic, assign) BOOL acceptAgreements;

@end
