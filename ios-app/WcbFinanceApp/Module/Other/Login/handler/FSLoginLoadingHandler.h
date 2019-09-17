//
//  FSLoginLoadingHandler.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/6/8.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSLoginLoadingHandler : NSObject

- (void)addLoadingWithParentView:(UIView *)parentView activityView:(UIView *)activityView;

- (void)removeLoadingWithCompletion:(void(^)(void))completion;

@end
