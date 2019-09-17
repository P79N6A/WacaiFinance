//
//  FinNotificationBody.h
//  FinanceApp
//
//  Created by new on 15/1/31.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinNotificationBody : NSObject

- (instancetype)initWithDic:(NSDictionary*)dic;

@property (nonatomic, copy) NSString* mNotifyTitle;
@property (nonatomic, copy) NSString* mNotifyUrl;

@end
