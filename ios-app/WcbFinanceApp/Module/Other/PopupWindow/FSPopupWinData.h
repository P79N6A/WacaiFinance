//
//  FSPopupWinData.h
//  FinanceApp
//
//  Created by Alex on 5/9/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    FSPopupWindowScenarioRegister = 1, //注册成功
    FSPopupWindowScenarioNeverLogin = 2, //从未登陆
    FSPopupWindowScenarioHadLoggedIn //已登陆-已购买 未购买
} FSPopupWindowScenario;


@interface FSPopupWinData : NSObject

@property (nonatomic, assign) FSPopupWindowScenario scenario;
@property (nonatomic, copy  ) NSString              *linkUrl;
@property (nonatomic, copy  ) NSString              *imgUrl;



@end
