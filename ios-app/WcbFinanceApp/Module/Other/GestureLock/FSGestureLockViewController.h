//
//  FSGestureLockViewController.h
//  FinanceApp
//
//  Created by xingyong on 8/3/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSBaseViewController.h"
typedef NS_ENUM(NSUInteger, FSGestureLockType) {
    FSGestureLockTypeNone,   // 显示忘记密码，不显示关闭按钮 , 用于解锁
    FSGestureLockTypeSet,    // 设置手势密码，不显示忘记密码，显示关闭按钮，
    FSGestureLockTypeUpdate, // 修改手势密码，不显示忘记密码，显示关闭按钮，
    FSGestureLockTypeClose // 关闭手势密码

};
@interface FSGestureLockViewController : FSBaseViewController

@property(nonatomic,assign) FSGestureLockType type;

@property(nonatomic,copy) void (^gestureLockCompletion) (NSDictionary *resultDic);

 
@end
