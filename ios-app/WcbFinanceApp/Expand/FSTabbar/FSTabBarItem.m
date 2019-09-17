//
//  FSTabBarItem.m
//  FinanceApp
//
//  Created by xingyong on 7/22/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSTabBarItem.h"
// 1 #import <RKNotificationHub/RKNotificationHub.h>
#import <JSBadgeView/JSBadgeView.h>

@interface FSTabBarItem ()

@property (nonatomic, strong) JSBadgeView *badgeView;

@end

@implementation FSTabBarItem

- (void)dealloc {
    
    [self.tabBarItem removeObserver:self forKeyPath:@"badgeValue"];
    [self.tabBarItem removeObserver:self forKeyPath:@"title"];
    [self.tabBarItem removeObserver:self forKeyPath:@"image"];
    [self.tabBarItem removeObserver:self forKeyPath:@"selectedImage"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [[UserActionStatistics sharedInstance] skylineEvent:@"wcb_will_init_badgeView"];
        _badgeView = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentTopCenter];
        _badgeView.badgeTextFont = [UIFont systemFontOfSize:10];
        _badgeView.badgePositionAdjustment = CGPointMake(15. , 5.);
        [[UserActionStatistics sharedInstance] skylineEvent:@"wcb_did_init_badgeView"];
        
    }
    return self;
}

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio {
    
    if (self = [super init]) {
        
        self.itemImageRatio = itemImageRatio;
    }
    return self;
}

#pragma mark -

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    
    _itemTitleFont = itemTitleFont;
    
    self.titleLabel.font = itemTitleFont;
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    
    _itemTitleColor = itemTitleColor;
    
    [self setTitleColor:itemTitleColor forState:UIControlStateNormal];
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor {
    
    _selectedItemTitleColor = selectedItemTitleColor;
    
    [self setTitleColor:selectedItemTitleColor forState:UIControlStateSelected];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    
    _badgeTitleFont = badgeTitleFont;
    
//    self.tabBarBadge.badgeTitleFont = badgeTitleFont;
}

#pragma mark -

- (void)setTabBarItemCount:(NSInteger)tabBarItemCount {
    
    _tabBarItemCount = tabBarItemCount;
    
//    self.tabBarBadge.tabBarItemCount = self.tabBarItemCount;
}


- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    
    _tabBarItem = tabBarItem;
    [tabBarItem addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];

    if (_isNetworkImage) {
        return;
    }
    [tabBarItem addObserver:self forKeyPath:@"title" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"image" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    [[UserActionStatistics sharedInstance] skylineEvent:@"wcb_will_set_badge_value"];
    _badgeView.badgeText = self.tabBarItem.badgeValue;
    [[UserActionStatistics sharedInstance] skylineEvent:@"wcb_did_set_badge_value"];
    
    if (_isNetworkImage) {
        return;
    }
    
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
}

#pragma mark - Reset TabBarItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = 0.f;
    CGFloat imageY = 0.f;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * self.itemImageRatio;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleX = 0.f;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleY = contentRect.size.height * self.itemImageRatio + (self.itemImageRatio == 1.0f ? 100.0f : -5.0f);
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted {
}

@end
