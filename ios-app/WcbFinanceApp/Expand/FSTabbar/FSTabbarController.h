//
//  FSTabbarController.h
//  FinanceApp
//
//  Created by xingyong on 7/22/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTabbarData.h"
#import "FSTabbar.h"
#import "FSTabBarMessage.h"

@interface FSTabbarController : UITabBarController
/**
 *  Tabbar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  Tabbar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

/**
 *  Tabbar item title font
 */
@property (nonatomic, strong) UIFont *itemTitleFont;

/**
 *  Tabbar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

/**
 *  Tabbar item image ratio
 */
@property (nonatomic, assign) CGFloat itemImageRatio;

/**
 *  tabbarItem显示不同的颜色
 */
@property (nonatomic, strong) NSArray *tabbarDataArray;

@property (nonatomic, strong) FSTabbar *lcTabBar;

@property (nonatomic, strong) FSTabBarMessage *message;

@property (nonatomic, assign) BOOL canShowMessage;

@end

@interface UIViewController (FSTabbarController)
 
@property(nonatomic, readonly) FSTabbarController *fs_tabbarController;

@end

