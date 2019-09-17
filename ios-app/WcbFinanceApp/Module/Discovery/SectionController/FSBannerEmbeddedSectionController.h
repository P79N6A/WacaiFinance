//
//  FSBannerEmbeddedSectionController.h
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "FSDiscoveryBanner.h"

@protocol FSBannerEmbeddedSetcionDelegate <NSObject>
@optional
- (void)bannerEmbeddedSectionDidClicked;
@end

@interface FSBannerEmbeddedSectionController : IGListSectionController

@property (nonatomic, weak) id<FSBannerEmbeddedSetcionDelegate> delegate;

@end
