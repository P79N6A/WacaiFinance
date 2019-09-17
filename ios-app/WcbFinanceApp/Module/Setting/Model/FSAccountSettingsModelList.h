//
//  FSAccountSettingsModelList.h
//  WcbFinanceApp
//
//  Created by howie on 2019/8/9.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAccountSettingsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSAccountSettingsModelList : NSObject

@property (nonatomic, strong) NSArray <FSAccountSettingsModel *> * groups;

@end

NS_ASSUME_NONNULL_END
