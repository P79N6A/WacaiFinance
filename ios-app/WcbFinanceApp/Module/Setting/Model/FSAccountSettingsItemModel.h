//
//  FSAccountSettingsItemModel.h
//  WcbFinanceApp
//
//  Created by howie on 2019/8/9.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSAccountSettingsItemModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * eventCode;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * iOSURL;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * descColor;

@end

NS_ASSUME_NONNULL_END
