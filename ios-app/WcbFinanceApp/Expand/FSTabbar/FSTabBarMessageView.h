//
//  FSTabBarMessageView.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/8/30.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSTabBarMessageDelegate <NSObject>

@optional
- (void)onCloseClicked;
- (void)onMessageClicked;

@end

@interface FSTabBarMessageView : UIView

@property (weak, nonatomic) id<FSTabBarMessageDelegate> delegate;

- (void)hide;
- (void)showMessage:(NSString *)content;

@end
