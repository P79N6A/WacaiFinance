//
//  FSAccountSettingsHandler.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/16.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSAccountSettingsHandler : NSObject


- (void)fetchPageConfig;
- (void)fetchUserInfoIfNeeded;
- (void)fetchUserStatusIfNeeded;

- (NSArray *)localDataSource;
- (NSArray *)updateDataSource;


@end

NS_ASSUME_NONNULL_END
