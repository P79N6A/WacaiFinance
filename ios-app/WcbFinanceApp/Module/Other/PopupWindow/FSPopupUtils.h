//
//  FSPopupUtils.h
//  FinanceApp
//
//  Created by xingyong on 09/11/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSPopupUtils : NSObject
+ (FSPopupUtils *)sharedInstance;

- (void)showImageUrl:(NSString *)imageUrl
             linkUrl:(NSString *)linkUrl
             eventId:(NSString *)eventId;

- (void)showImageUrl:(NSString *)imageUrl
             linkUrl:(NSString *)linkUrl
             eventId:(NSString *)eventId
          clickBlock:(void(^ _Nullable)())clickBlock
          closeBlock:(void(^ _Nullable)())closeBlock;

@end
