//
//  FSDiscoveryWechatPopView.h
//  WcbFinanceApp
//
//  Created by tesila on 2018/11/20.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSDiscoveryWeChatPopViewDelegate <NSObject>

- (void)onWeChatPopCloseAreaClicked;

@end


@interface FSDiscoveryWeChatPopView : UIView

@property (nonatomic, weak) id<FSDiscoveryWeChatPopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
