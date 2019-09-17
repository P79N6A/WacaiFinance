//
//  FSDcvrBannerViewModel.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/11.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrBaseViewModel.h"

@class FSDiscoveryBanner;
@interface FSDcvrBannerViewModel : FSDcvrBaseViewModel

@property (nonatomic, strong) NSArray<FSDiscoveryBanner *> *banners;
@property (nonatomic, strong) NSString *belongMode;


+ (UIEdgeInsets)sectionInset;
+ (NSInteger)itemSpacing;
+ (CGSize)imageCellSize;
+ (NSInteger)bannerHeight;

@end
