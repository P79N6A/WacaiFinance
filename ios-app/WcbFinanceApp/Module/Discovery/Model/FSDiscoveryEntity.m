//
//  FSDiscoveryEntity.m
//  Financeapp
//
//  Created by 叶帆 on 10/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryEntity.h"

@implementation FSDiscoveryEntity

+ (instancetype)entityWithType:(FSDiscoveryEntityType)type {
    return [[self alloc] initWithEntityType:type];
}

+ (instancetype)entityWithMenuData:(NSArray *)menus {
    return [[self alloc] initWithMenuData:menus];
}

+ (instancetype)entityWithPost:(FSDiscoveryPost *)post {
    return [[self alloc] initWithPost:post];
}

+ (instancetype)entityWithBanners:(NSArray<FSDiscoveryBanner *> *)banners {
    return [[self alloc] initWithBanners:banners];
}

+ (instancetype)entityWithBindPromotionText:(NSString *)text {
    return [[self alloc] initWithBindPromotionText:text];
}

+ (instancetype)entityWithExceptionCellHeight:(CGFloat)height {
    return [[self alloc] initWithExceptionCellHeight:height];
}

- (instancetype)initWithEntityType:(FSDiscoveryEntityType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (instancetype)initWithMenuData:(NSArray *)menus {
    self = [super init];
    if (self) {
        _type = FSDiscoveryEntityTypeMenu;
        _menuArray = menus;
    }
    return self;
}

- (instancetype)initWithPost:(FSDiscoveryPost *)post {
    self = [super init];
    if (self) {
        _type = FSDiscoveryEntityTypePost;
        _post = post;
    }
    return self;
}

- (instancetype)initWithBanners:(NSArray<FSDiscoveryBanner *> *)banners {
    self = [super init];
    if (self) {
        _type = FSDiscoveryEntityTypeBanner;
        _banners = banners;
    }
    return self;
}

- (instancetype)initWithBindPromotionText:(NSString *)text {
    self = [super init];
    if (self) {
        _type = FSDiscoveryEntityTypeBindPromotion;
        _bindPromotionText = text;
    }
    return self;
}

- (instancetype)initWithExceptionCellHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        _type = FSDiscoveryEntityTypeDataException;
        _exceptionCellHeight = height;
    }
    return self;
}



#pragma mark - IGListDiffable
- (id<NSObject>)diffIdentifier {
    //TODO 待优化
//    return @(_type);
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}


@end
