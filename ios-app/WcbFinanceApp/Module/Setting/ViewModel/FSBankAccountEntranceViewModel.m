//
//  FSBankAccountEntranceViewModel.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 13/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSBankAccountEntranceViewModel.h"

static NSString *const kLastHasShownBankAccontEntrance = @"lastHasShownBankAccontEntrance";
static NSString *const kLastBanckAccountPwdUrl = @"lastBanckAccountPwdUrl";

@implementation FSBankAccountEntranceViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    _shouldShow = [self lastHasShownBankAccontEntrance];
    _stateText = @"";
    _stateColor = [UIColor clearColor];
    _pwdUrl =  [self lastBanckAccountPwdUrl];
}


- (BOOL)lastHasShownBankAccontEntrance {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *entranceStateNumber = [userDefaults objectForKey:kLastHasShownBankAccontEntrance];
    return [entranceStateNumber boolValue];
}

- (void)storageLastHasShownBankAccontEntrance:(NSNumber *)custodyPasswordSwitch {
    custodyPasswordSwitch = custodyPasswordSwitch ?: @(0);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:custodyPasswordSwitch forKey:kLastHasShownBankAccontEntrance];
    [userDefaults synchronize];
}

- (NSString *)lastBanckAccountPwdUrl
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:kLastBanckAccountPwdUrl];
    return url;
}

- (void)storageLastBanckAccountPwdUrl:(NSString *)url
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:url forKey:kLastBanckAccountPwdUrl];
    [userDefaults synchronize];
}

- (void)saveData
{
    [self storageLastHasShownBankAccontEntrance:@(self.shouldShow)];
    [self storageLastBanckAccountPwdUrl:self.pwdUrl];
}

@end
