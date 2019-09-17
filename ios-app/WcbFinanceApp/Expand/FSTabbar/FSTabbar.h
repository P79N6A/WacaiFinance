//
//  FSTabbar.h
//  FinanceApp
//
//  Created by xingyong on 7/22/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTabBarMessageView.h"

@class FSTabbar, FSTabBarItem;

@protocol FSTabBarDelegate <NSObject>

@optional
- (void)tabBar:(FSTabbar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface FSTabbar : UIView

@property (nonatomic, strong) FSTabBarMessageView *messageView;

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

@property (nonatomic, assign) NSInteger tabBarItemCount;

@property (nonatomic, strong) FSTabBarItem *selectedItem;

@property (nonatomic, strong) NSMutableArray *tabBarItems;

@property (nonatomic, weak) id<FSTabBarDelegate> delegate;

- (void)addTabBarItem:(UITabBarItem *)item;

- (void)buttonClick:(FSTabBarItem *)tabBarItem;


@end
