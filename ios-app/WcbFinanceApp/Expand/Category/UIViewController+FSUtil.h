//
//  UIViewController+FSUtil.h
//  FinanceApp
//
//  Created by Alex on 1/18/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FSUtil)

+ (UIViewController*)fs_currentViewController;

- (BOOL)fs_isModal;

- (NSString *)fsRouterName;
- (void)setFsRouterName:(NSString *)name;

@end
