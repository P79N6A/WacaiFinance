//
//  FSEnterPasswordViewModelSpec.m
//  FinanceApp
//
//  Created by Alex on 13/02/2017.
//  Copyright 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSEnterPasswordViewModel.h"


SPEC_BEGIN(FSEnterPasswordViewModelSpec)

describe(@"FSEnterPasswordViewModel", ^{
    context(@"when ViewModel is created", ^{
        __block FSEnterPasswordViewModel *viewModel = nil;
        beforeAll(^{
            viewModel = [FSEnterPasswordViewModel new];
        });
        
        afterAll(^{
            viewModel = nil;
        });
        
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"should have loginCmd", ^{
            [[viewModel.loginCmd shouldNot] beNil];
        });
    });
    
    context(@"when accountString change", ^{
        __block FSEnterPasswordViewModel *viewModel = nil;
        beforeEach(^{
            viewModel = [FSEnterPasswordViewModel new];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should change tipString", ^{
            viewModel.accountString = @"18511111111";
            [[viewModel.tipString should] equal:@"Hi, 185****1111, 欢迎回来!"];
            
            viewModel.accountString = @"18511111122";
            [[viewModel.tipString should] equal:@"Hi, 185****1122, 欢迎回来!"];
            
            viewModel.accountString = nil;
            [[viewModel.tipString should] equal:@"Hi, , 欢迎回来!"];
        });
    });
    
    context(@"when login", ^{
        __block FSEnterPasswordViewModel *viewModel = nil;
        __block NSError *error = nil;
        beforeEach(^{
            viewModel = [FSEnterPasswordViewModel new];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should have accountString", ^{
            viewModel.accountString = nil;
            [viewModel.loginCmd.errors subscribeNext:^(NSError *x) {
                [[x.localizedDescription should] equal:@"用户名不能为空"];
            }];
            [[viewModel.loginCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
        it(@"should have pwdString", ^{
            viewModel.accountString = @"18511111111";
            [viewModel.loginCmd.errors subscribeNext:^(NSError *x) {
                [[x.localizedDescription should] equal:NSLocalizedString(@"error_password_empty", nil)];
            }];
            [[viewModel.loginCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
    });
    
    context(@"when need needVerifyCode", ^{
        __block FSEnterPasswordViewModel *viewModel = nil;
        __block NSError *error = nil;
        beforeEach(^{
            viewModel = [FSEnterPasswordViewModel new];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should have verifyTips", ^{
            viewModel.verifyTips = @"verifyTips";
            [[theValue(viewModel.needVerifyCode) should] beYes];
            
            viewModel.verifyTips = @"";
            [[theValue(viewModel.needVerifyCode) should] beNo];
            
            viewModel.verifyTips = nil;
            [[theValue(viewModel.needVerifyCode) should] beNo];
        });
        
        it(@"should failed, if needVerifyCode is empty ", ^{
            viewModel.accountString = @"18511111111";
            viewModel.pwdString = @"111111";
            viewModel.verifyTips = @"verifyTips";
            viewModel.verifyCode = @"";
            
            [viewModel.loginCmd.errors subscribeNext:^(NSError *x) {
                [[x.localizedDescription should] equal:@"验证码不能为空"];
            }];
            [[viewModel.loginCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
    });
});

SPEC_END
