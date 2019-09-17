//
//  FSAccountSettingsModel.h
//  WcbFinanceApp
//
//  Created by howie on 2019/8/9.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAccountSettingsItemModel.h"
#import <YYModel/YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface FSAccountSettingsModel : NSObject

@property (nonatomic, copy) NSString * groupID;
@property (nonatomic, strong) NSArray <FSAccountSettingsItemModel *>* items;


@end

NS_ASSUME_NONNULL_END
