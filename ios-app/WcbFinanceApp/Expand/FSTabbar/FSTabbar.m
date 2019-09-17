//
//  FSTabbar.m
//  FinanceApp
//
//  Created by xingyong on 7/22/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSTabbar.h"
#import "FSTabBarItem.h"

@implementation FSTabbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = ({
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, ScreenWidth, 0.5)];
            lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            lineView;
        });
        [self addSubview:lineView];
        
        self.messageView = [[FSTabBarMessageView alloc] init];
        [self.messageView hide];//默认隐藏
        [self addSubview:self.messageView];
        [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.equalTo(self.mas_left).mas_offset(@22);
            make.right.equalTo(self.mas_right).mas_offset(@-22);
            make.bottom.equalTo(self.mas_top).mas_offset(@-16);
        }];
    }
    return self;
}

- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        
        _tabBarItems = [[NSMutableArray alloc] init];
    }
    return _tabBarItems;
}

- (void)addTabBarItem:(UITabBarItem *)item {
    
    FSTabBarItem *tabBarItem = [[FSTabBarItem alloc] initWithItemImageRatio:self.itemImageRatio];
    
    tabBarItem.badgeTitleFont         = self.badgeTitleFont;
    tabBarItem.itemTitleFont          = self.itemTitleFont;
    tabBarItem.itemTitleColor         = self.itemTitleColor;
    tabBarItem.selectedItemTitleColor = self.selectedItemTitleColor;
    
    tabBarItem.tabBarItemCount = self.tabBarItemCount;
    
    tabBarItem.tabBarItem = item;
    
    [tabBarItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:tabBarItem];
    
    [self.tabBarItems addObject:tabBarItem];
    
    if (self.tabBarItems.count == 1) {
        
        [self buttonClick:tabBarItem];
    }
}

- (void)buttonClick:(FSTabBarItem *)tabBarItem {
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)]) {
        
        [self.delegate tabBar:self didSelectedItemFrom:self.selectedItem.tabBarItem.tag to:tabBarItem.tag];
    }
    if (!USER_INFO.isLogged) {
        if (tabBarItem.tag == 2) {
            return;
        }
    }
  
    self.selectedItem.selected = NO;
    self.selectedItem = tabBarItem;
    self.selectedItem.selected = YES;
}
 
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    NSInteger count =  self.tabBarItems.count;
    CGFloat itemY = 0;
    CGFloat itemW = w / count;
    CGFloat itemH = h;
    
    for (int index = 0; index < count; index++) {
        
        FSTabBarItem *tabBarItem = self.tabBarItems[index];
        tabBarItem.tag = index;
        CGFloat itemX = index * itemW;
        tabBarItem.frame = CGRectMake(itemX, itemY + 5, itemW, itemH);
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.messageView.isHidden) {
        CGPoint pointInMessageView = [self convertPoint:point toView:self.messageView];
        if ([self.messageView pointInside:pointInMessageView withEvent:event]) {
            return YES;
        }
    }
    return [super pointInside:point withEvent:event];
}

@end
