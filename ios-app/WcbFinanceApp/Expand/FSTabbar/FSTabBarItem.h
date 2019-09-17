//
//  FSTabBarItem.h
//  FinanceApp
//
//  Created by xingyong on 7/22/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTabBarItem : UIButton

@property (nonatomic, strong) UITabBarItem *tabBarItem;

@property (nonatomic, assign) BOOL isNetworkImage;


@property (nonatomic, assign) NSInteger tabBarItemCount;

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

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio;

@end
