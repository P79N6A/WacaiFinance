//
//  FSBankAccountEntranceModel.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 13/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSBankAccountEntranceModel : NSObject

@property (assign, nonatomic) BOOL hasPassword;
@property (strong, nonatomic) NSNumber *custodyPasswordSwitch;
@property (strong, nonatomic) NSString *pwdUrl;

@end
