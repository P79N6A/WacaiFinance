//
//  FSTabbarController.m
//  FinanceApp
//
//  Created by xingyong on 7/22/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSTabbarController.h"
#import "FSTabBarItem.h"
#import "UIColor+FSUtils.h"
#import "AppDelegate.h"
#import "FSTabbarData.h"
#import "UIColor+FSUtils.h"
#import "NSArray+FSUtils.h"
#import "UIButton+WebCache.h"
#import <objc/runtime.h>

#import <i-Finance-Library/FSEventStatisticsAction.h>
#import "FSTabbarController+FSMessage.h"
#import "UIViewController+FSUtil.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>

@interface UIViewController (FSTabbarControllerItemInternal)

- (void)fs_setTabbarController:(FSTabbarController *)tabBarController;

@end

@interface FSTabbarController ()<FSTabBarDelegate, FSTabBarMessageDelegate>


@end

@implementation FSTabbarController

#pragma mark -

- (UIColor *)itemTitleColor {
    
    if (!_itemTitleColor) {
        
        _itemTitleColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _itemTitleColor;
}

- (UIColor *)selectedItemTitleColor {
    
    if (!_selectedItemTitleColor) {
        
        _selectedItemTitleColor = [UIColor colorWithHex:0xd84a3f];
    }
    return _selectedItemTitleColor;
}

- (UIFont *)itemTitleFont {
    
    if (!_itemTitleFont) {
        
        _itemTitleFont = [UIFont systemFontOfSize:10.0f];
    }
    return _itemTitleFont;
}

- (UIFont *)badgeTitleFont {
    
    if (!_badgeTitleFont) {
        
        _badgeTitleFont = [UIFont systemFontOfSize:10.0f];
    }
    return _badgeTitleFont;
}

#pragma mark -

- (void)loadView {
    
    [super loadView];
    
    self.itemImageRatio = 0.5;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.lcTabBar = ({
        FSTabbar *tabBar = [[FSTabbar alloc] init];
        tabBar.delegate  = self;
        tabBar;
    });
    self.lcTabBar.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    [self.view addSubview:self.lcTabBar];
    [self.lcTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@49);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    self.lcTabBar.messageView.delegate = self;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    self.lcTabBar.badgeTitleFont         = self.badgeTitleFont;
    self.lcTabBar.itemTitleFont          = self.itemTitleFont;
    self.lcTabBar.itemImageRatio         = self.itemImageRatio;
    self.lcTabBar.itemTitleColor         = self.itemTitleColor;
    self.lcTabBar.selectedItemTitleColor = self.selectedItemTitleColor;
    
    self.lcTabBar.tabBarItemCount = viewControllers.count;
    
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIViewController *controller = (UIViewController *)obj;
        
        [self addChildViewController:controller];
    
        [self.lcTabBar addTabBarItem:controller.tabBarItem];
    }];
}
- (void)setTabbarDataArray:(NSArray *)tabbarDataArray{
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [self.lcTabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[FSTabBarItem class]]) {
            [items fs_addObject:obj];
        }
    }];
    
    for (NSInteger index = 0 ;index < [items count]; index ++ ) {
        
        FSTabBarItem *buttonItem          = (FSTabBarItem *)[items fs_objectAtIndex:index];
        buttonItem.isNetworkImage         = YES;
        FSTabbarData  *data               = [tabbarDataArray fs_objectAtIndex:index];
        buttonItem.itemTitleColor         = [UIColor colorWithHexString:data.normalColor];
        buttonItem.selectedItemTitleColor = [UIColor colorWithHexString:data.selectedColor];
        
        NSURL *normalURL   = [NSURL URLWithString:data.normalUrl];
        NSURL *selectedURL = [NSURL URLWithString:data.selectedUrl];
        
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:normalURL options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image) {
                [buttonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                
            }
            
        }];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:selectedURL options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                [buttonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
            }
            
        }];
      
        [buttonItem setTitle:data.name forState:UIControlStateNormal];
    }
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.lcTabBar.selectedItem.selected = NO;
    self.lcTabBar.selectedItem = self.lcTabBar.tabBarItems[selectedIndex];
    self.lcTabBar.selectedItem.selected = YES;
    
    [self processMessageDisplay:selectedIndex];
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(FSTabbar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    
    if (to == 0) {
    }else if(to == 1){

        [UserAction skylineEvent:@"finance_wcb_shelf_enter_page"];
        [UserAction skylineEvent:@"finance_wcb_shelf_tab_click"];
        
    }else if(to == 2){
        
        [UserAction skylineEvent:@"finance_wcb_myassets_myassets_click"];

    }
    
    if (to == 2) {
        if(!USER_INFO.isLogged){
            
            self.fsRouterName = @"myassets";
            [FSGotoUtility gotoLoginViewController:self success:^{
                self.selectedIndex = to;
            }];
            return;
        }
     
     }
    
    self.selectedIndex = to;
 }

#pragma mark - FSTabBarMessageDelegate

- (void)onCloseClicked {
    NSDictionary *params = @{@"lc_coupon_code":
                                 self.message.couponCodeList ? self.message.couponCodeList.description : @[]};
    [UserAction skylineEvent:@"finance_wcb_homeremind_close_click" attributes:params];
    
    [self.lcTabBar.messageView hide];
    
    [self reportTabBarMessageClosed];
    
}

- (void)onMessageClicked {
    NSDictionary *params = @{@"lc_coupon_code":
                                 self.message.couponCodeList ? self.message.couponCodeList.description : @[]};
    [UserAction skylineEvent:@"finance_wcb_homeremind_see_click" attributes:params];
    
    [self.lcTabBar.messageView hide];
    
    [FSSDKGotoUtility openURL:self.message.url from:self];
}

@end

@implementation UIViewController (FSTabbarControllerItemInternal)

- (void)fs_setTabbarController:(FSTabbarController *)tabbarController {
    objc_setAssociatedObject(self, @selector(fs_tabBarController), tabbarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (tabbarControllerInternal)

- (FSTabbarController *)fs_tabbarController{
    FSTabbarController *tabBarController = nil;
    objc_getAssociatedObject(self, @selector(fs_tabbarController));
    if (tabBarController) {
        return tabBarController;
    }
    if ([self isKindOfClass:[UIViewController class]] && [(UIViewController *)self parentViewController]) {
        tabBarController = [[(UIViewController *)self parentViewController] fs_tabbarController];
        return tabBarController;
    }
    id<UIApplicationDelegate> delegate = (id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;

    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
       UINavigationController *nav = (UINavigationController *)window.rootViewController;
        tabBarController = (FSTabbarController *)nav.topViewController;
     }

    
    return tabBarController;
}

@end
