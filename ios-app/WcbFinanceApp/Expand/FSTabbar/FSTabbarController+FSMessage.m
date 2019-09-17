//
//  FSTabbarController+FSMessage.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/8/30.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSTabbarController+FSMessage.h"
#import "FSTabBarMessageRequest.h"
#import "FSTabBarMessageClosedRequest.h"
#import "FSTabBarMessage.h"
#import <YYModel/NSObject+YYModel.h>

@implementation FSTabbarController (FSMessage)

- (void)processMessageDisplay:(NSUInteger)selectedIndex {
    self.canShowMessage = (selectedIndex == 0);
    if (self.canShowMessage) {
        [self requestTabBarMessage];
    } else {
        [self.lcTabBar.messageView hide];
    }
}

- (void)requestTabBarMessage {
    FSTabBarMessageRequest *request = [[FSTabBarMessageRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        NSInteger code = [[request.responseJSONObject fs_objectMaybeNilForKey:@"code" ofClass:[NSNumber class]] integerValue];
        if (code != 0) { return; }
        
        NSDictionary *data = [request.responseJSONObject fs_objectMaybeNilForKey:@"data" ofClass:[NSDictionary class]];
        if (![data CM_isValidDictionary]) { return; }
        if (!self.canShowMessage) { return; }
        self.message = [FSTabBarMessage yy_modelWithJSON:data];
        NSDictionary *params = @{@"lc_coupon_code":
                                     self.message.couponCodeList ? self.message.couponCodeList.description : @[]};
        [UserAction skylineEvent:@"finance_wcb_homeremind_page" attributes:params];
        [self.lcTabBar.messageView showMessage:self.message.msg];

    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        
    }];
}

- (void)reportTabBarMessageClosed {
    FSTabBarMessageClosedRequest *request = [[FSTabBarMessageClosedRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        
    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        
    }];
}

@end
