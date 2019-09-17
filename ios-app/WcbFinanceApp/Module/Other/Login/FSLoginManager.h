//
//  FSLoginManager.h
//  FinanceApp
//
//  Created by Alex on 5/5/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(void);
typedef void(^CancelBlock)(void);


@interface FSLoginManager : NSObject

+ (instancetype)manager;

/**
 *  返回一个包含 NavigationController 的登录界面
 *
 *  @param successBlock 登录成功后的回调
 *
 *  @return 包含 NavigationController 的登录界面
 */
- (UINavigationController *)loginViewControllerSuccess:(CompletionBlock)successBlock cancel:(CancelBlock)cancelBlock comeFrom:(NSString *)comFrom;

+ (UIViewController *)appropriateLoginViewController:(NSString *)comeFrom;

+ (UIViewController *)ntLoginViewController;

@end
