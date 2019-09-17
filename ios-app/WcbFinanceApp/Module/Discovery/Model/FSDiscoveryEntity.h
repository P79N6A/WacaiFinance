//
//  FSDiscoveryEntity.h
//  Financeapp
//
//  Created by 叶帆 on 10/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDiscoveryPost.h"
#import "FSDiscoveryTag.h"
#import "FSDiscoveryBanner.h"

typedef NS_ENUM(NSUInteger, FSDiscoveryEntityType) {
    FSDiscoveryEntityTypeUserInfo       = 0,
    FSDiscoveryEntityTypeVIPEntrance    = 1,
    FSDiscoveryEntityTypeMenu           = 2,
    FSDiscoveryEntityTypeTag            = 3,
    FSDiscoveryEntityTypePost           = 4,
    FSDiscoveryEntityTypeBanner         = 5,
    FSDiscoveryEntityTypeBindPromotion  = 6,
    FSDiscoveryEntityTypeDataException  = 7,
};

@interface FSDiscoveryEntity : NSObject<IGListDiffable>

//TODO 优化为子类实现 or 类簇
@property (nonatomic, strong, readonly) NSArray *menuArray;
@property (nonatomic, strong, readonly) FSDiscoveryPost *post;
@property (nonatomic, strong, readonly) NSArray<FSDiscoveryBanner *> *banners;
@property (nonatomic, assign, readonly) FSDiscoveryEntityType type;
@property (nonatomic, copy, readonly) NSString *bindPromotionText;
@property (nonatomic, assign, readonly) CGFloat exceptionCellHeight;



+ (instancetype)entityWithType:(FSDiscoveryEntityType)type;
+ (instancetype)entityWithMenuData:(NSArray *)menus;
+ (instancetype)entityWithPost:(FSDiscoveryPost *)post;
+ (instancetype)entityWithBanners:(NSArray<FSDiscoveryBanner *> *)banners;
+ (instancetype)entityWithBindPromotionText:(NSString *)text;
+ (instancetype)entityWithExceptionCellHeight:(CGFloat)height;

@end
