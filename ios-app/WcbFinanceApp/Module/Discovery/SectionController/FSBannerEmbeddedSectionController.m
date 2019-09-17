//
//  FSBannerEmbeddedSectionController.m
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSBannerEmbeddedSectionController.h"
#import "FSDiscoveryBannerImageViewCell.h"
#import "FSDcvrBannerViewModel.h"
#import <UIImageView+WebCache.h>
#import <i-Finance-Library/FSSDKGotoUtility.h>

@interface FSBannerEmbeddedSectionController()

@property (nonatomic, strong) NSArray<FSDiscoveryBanner *> *banners;

@end

@implementation FSBannerEmbeddedSectionController

- (NSInteger)numberOfItems {
    return self.banners.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat height = 100 + 32;
    CGFloat width = 180 + 16;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDiscoveryBannerImageViewCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    FSDiscoveryBannerImageViewCell *bannerImageViewCell = (FSDiscoveryBannerImageViewCell *)cell;
    NSString *imgURL = ((FSDiscoveryBanner *)[self.banners fs_objectAtIndex:index]).imgURL;
    if ([imgURL CM_isValidString]) {
        [bannerImageViewCell.imageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    }
    return bannerImageViewCell;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerEmbeddedSectionDidClicked)]) {
        [self.delegate bannerEmbeddedSectionDidClicked];
    }
    
    FSDiscoveryBanner *bannerData = [self.banners fs_objectAtIndex:index];
    NSString *linkURL = bannerData.linkURL;
    NSString *bannerID = bannerData.bannerID ?: @"";
    if ([linkURL CM_isValidString]) {
        [FSSDKGotoUtility openURL:linkURL from:self.viewController];
    }
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[FSDcvrBannerViewModel class]]) {
        FSDcvrBannerViewModel *entity = (FSDcvrBannerViewModel *)object;
        _banners = entity.banners;
    }
}

@end
