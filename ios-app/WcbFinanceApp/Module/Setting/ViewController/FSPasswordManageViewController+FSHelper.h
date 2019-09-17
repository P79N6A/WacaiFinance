//
//  FSPasswordManageViewController+FSHelper.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 12/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSPasswordManageViewController.h"
#import "FSBankAccountEntranceModel.h"
#import "FSBankAccountEntranceViewModel.h"

@interface FSPasswordManageViewController (FSHelper)

- (BOOL)hasSetGesture;
- (BOOL)shouldEnableBiometricsAuthSwitch;

- (void)onClickWacaiBaoling;
- (void)onClickBankPassword:(NSString *)url;
- (void)onModifyGesture;
- (void)onModifyPassword;

- (FSBankAccountEntranceViewModel *)convertViewModelOfBankAccountEntranceModel:(FSBankAccountEntranceModel *)model;

@end
