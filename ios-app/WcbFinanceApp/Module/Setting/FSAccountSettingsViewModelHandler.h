//
//  FSAccountSettingsViewModelHandler.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/18.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FSAccountSettingsUserInfo;
@class FSAccountSettingsUserStatus;
@class FSAccountSettingsModelList;

NS_ASSUME_NONNULL_BEGIN

@interface FSAccountSettingsViewModelHandler : NSObject

- (NSArray *)buildPageViewModelWithConfig:(FSAccountSettingsModelList *)configModel
                                 userInfo:(FSAccountSettingsUserInfo *)userInfo
                               userStatus:(FSAccountSettingsUserStatus *)userStatus;

@end

NS_ASSUME_NONNULL_END
