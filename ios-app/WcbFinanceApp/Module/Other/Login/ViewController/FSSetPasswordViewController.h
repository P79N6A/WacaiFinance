//
//  FinancialRegisterViewController.h
//  financial
//
//  Created by wac on 14-6-16.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseViewController.h"


// "手机注册登录"注册页面

@interface FSSetPasswordViewController : FSBaseViewController 

@property (nonatomic, copy) NSString *mTelephone;
@property (nonatomic, copy) NSString *codeString;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic, copy) NSString *confirmPasswordString;

@property (nonatomic, strong) UIButton *agreeCheckButton;


@end
