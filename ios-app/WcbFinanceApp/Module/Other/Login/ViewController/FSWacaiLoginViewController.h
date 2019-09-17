//
//  WacaiLoginViewController.h
//  financial
//
//  Created by wac on 14-6-18.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseViewController.h"

// ”挖财账号登录“界面.

typedef NS_ENUM(NSUInteger, FSLoginViewCloseType) {

    FSLoginViewCloseTypePop = 0,
    FSLoginViewCloseTypeDismiss,
};

@interface FSWacaiLoginViewController : FSBaseViewController

@property (nonatomic, strong) NSString *comeFrom; //来源, 埋点使用

- (instancetype)initWithLoginPhone:(NSString *)loginPhone;
- (instancetype)initWithLoginPhone:(NSString *)loginPhone
                         closeType:(FSLoginViewCloseType)type
                          needEdit:(BOOL)needEdit;

@end
