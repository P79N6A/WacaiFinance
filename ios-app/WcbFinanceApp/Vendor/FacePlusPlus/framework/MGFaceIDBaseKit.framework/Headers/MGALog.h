//
//  Log.h
//  AliyunLogObjc
//
//  Created by MegviiDev on 2018/06/27.
//  Copyright © 2016年 MegviiDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGAlog : NSObject
{
    NSMutableDictionary<NSString*,NSObject*> *_mContent;
}

- (void)PutContent:(NSString *)value withKey:(NSString *)key;
- (void)PutTime:(int)time;
- (NSDictionary<NSString*,NSObject*> *)GetContent;
- (NSUInteger)GetContentCount;

@end

