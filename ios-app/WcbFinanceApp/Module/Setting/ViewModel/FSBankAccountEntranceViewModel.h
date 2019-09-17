//
//  FSBankAccountEntranceViewModel.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 13/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSBankAccountEntranceViewModel : NSObject

@property (assign, nonatomic) BOOL shouldShow;
@property (strong, nonatomic) NSString *stateText;
@property (strong, nonatomic) UIColor *stateColor;
@property (strong, nonatomic) NSString *pwdUrl;

- (BOOL)lastHasShownBankAccontEntrance;
- (void)storageLastHasShownBankAccontEntrance:(NSNumber *)custodyPasswordSwitch;
- (NSString *)lastBanckAccountPwdUrl;
- (void)storageLastBanckAccountPwdUrl:(NSString *)url;
- (void)saveData;

@end
