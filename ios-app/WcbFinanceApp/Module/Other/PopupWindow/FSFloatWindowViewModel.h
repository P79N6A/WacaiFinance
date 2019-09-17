//
//  FSFloatWindowViewModel.h
//  FinanceApp
//
//  Created by Alex on 6/29/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//


// 接口文档 http://git.caimi-inc.com/finance/wac-finance-app/wikis/json-app-popupwin
#import <Foundation/Foundation.h>
#import "FSPopupWinData.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN
@interface FSFloatWindowViewModel : NSObject
@property (nonatomic, assign) BOOL userRegister;
@property (nonatomic, assign) BOOL userNeverLogin;
@property (nonatomic, assign) BOOL userLoggedIn;

@property (nonatomic, strong) RACCommand *showPopupWindowCmd;

@end
NS_ASSUME_NONNULL_END
