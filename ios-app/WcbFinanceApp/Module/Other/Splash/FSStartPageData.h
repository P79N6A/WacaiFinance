//
//  FSStartPageData.h
//  FinanceApp
//
//  Created by xingyong on 29/11/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSStartPageData : NSObject

@property(nonatomic,copy) NSString *mid;
@property(nonatomic,strong) NSArray<NSString *> *mimgUrls;
@property(nonatomic,copy) NSString *mimgUrl;

@property(nonatomic,copy) NSString *mlinkUrl;
@property(nonatomic,copy) NSString *mpageName;
@property(nonatomic, strong) UIImage *downImage;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
@end
