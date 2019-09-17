//
//  FSProductTabData.h
//  FinanceApp
//
//  Created by xingyong on 2/2/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSProductTabData : NSObject
@property (nonatomic, copy) NSString *mtabName;
@property (nonatomic, copy) NSString *mtabId;
@property (nonatomic, copy) NSString *mTabURL;
@property (nonatomic, copy) NSString *mTabType;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryDescription;
- (BOOL)save;
+ (FSProductTabData *)loadTabData;

@end
