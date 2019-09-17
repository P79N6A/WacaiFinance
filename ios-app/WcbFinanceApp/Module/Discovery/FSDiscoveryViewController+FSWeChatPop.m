//
//  FSDiscoveryViewController+FSWeChatPop.m
//  WcbFinanceApp
//
//  Created by tesila on 2018/11/20.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryViewController+FSWeChatPop.h"
#import "FSWeChatStatusRequest.h"

NSString *const kFSDiscoveryWeChatPopClosedKey = @"kFSDiscoveryWeChatPopClosed";

@implementation FSDiscoveryViewController (FSWeChatPop)

- (void)requestAndShowWeChatPopIfNeeded {
    if ([self shouldRequestWeChatStatus]) {
        FSWeChatStatusRequest *request = [[FSWeChatStatusRequest alloc] init];
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            NSDictionary *data = [request.responseObject CM_dictionaryForKey:@"data"];
            NSInteger hide = [data CM_intForKey:@"hide"];
            if (hide == 1) { // 灰度及历史用户处理用
                return;
            }
            
            NSInteger subscribed = [data CM_intForKey:@"subscribed"];
            if (subscribed == 2) { //未绑定
                [self showWeChatPopView];
            }
        } failure:^(__kindof CMBaseRequest * _Nonnull request) {
            
        }];
    }
}

- (BOOL)shouldRequestWeChatStatus {
    if (!USER_INFO.isLogged) {
        return NO; // 未登录不用请求
    }
    
    if ([self hasWeChatPopClosed]) {
        return NO; // 已经展示过且被关闭不用请求
    }
    
    return YES;
}

- (void)showWeChatPopView {
    self.weChatPopView.hidden = NO;
}

- (void)hideWeChatPopViewForever {
    if (self.weChatPopView.hidden == YES) {
        // 未展示时不处理
        return;
    }
    self.weChatPopView.hidden = YES;
    [self markWeChatPopHasClosed];
}

- (BOOL)hasWeChatPopClosed {
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:kFSDiscoveryWeChatPopClosedKey];
    return value.boolValue;
}

- (void)markWeChatPopHasClosed {
    NSNumber *value = [NSNumber numberWithBool:YES];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kFSDiscoveryWeChatPopClosedKey];
}

@end
