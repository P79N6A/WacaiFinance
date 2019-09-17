//
//  FSDiscoveryViewController+FSWeChatPop.h
//  WcbFinanceApp
//
//  Created by tesila on 2018/11/20.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSDiscoveryViewController (FSWeChatPop)

- (void)requestAndShowWeChatPopIfNeeded;

- (void)hideWeChatPopViewForever;

@end

NS_ASSUME_NONNULL_END
