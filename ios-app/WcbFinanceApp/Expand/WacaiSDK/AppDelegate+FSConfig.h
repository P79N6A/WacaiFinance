//
//  AppDelegate+FSThirdPartySDKs.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 25/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (FSConfig)

- (void)setupiRate;
- (void)checkWebviewUserAgent;
- (void)parseRouterJson;
- (void)userDataRemoval;
- (void)requestTabData;
@end
