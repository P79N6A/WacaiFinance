//
//  LogGroup.h
//  AliyunLogObjc
//
//  Created by MegviiDev on 2018/06/27.
//  Copyright © 2016年 MegviiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGAlog;

@interface MGALogGroup : NSObject
{
    NSString *_mTopic;
    NSString *_mSource;
    NSMutableArray<NSDictionary<NSString*,NSObject*>*> *_mContent;
}

- (instancetype)initWithTopic:(NSString *)topic
                    andSource:(NSString *)source;

- (void)PutTopic:(NSString *)topic;
- (void)PutSource:(NSString *)source;
- (void)PutLog:(MGAlog *)log;
- (NSString *)GetJsonPackage;

@end

