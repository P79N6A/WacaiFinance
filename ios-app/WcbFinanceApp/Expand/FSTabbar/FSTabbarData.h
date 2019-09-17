//
//  FSTabbarData.h
//  FinanceApp
//
//  Created by xingyong on 7/25/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTabbarData : NSObject
@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString *normalColor;
@property(nonatomic,copy) NSString *selectedColor;

@property(nonatomic,copy) NSString *normalUrl;
@property(nonatomic,copy) NSString *selectedUrl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
@end
