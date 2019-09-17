//
//  FSDiscoveryBannerSectionController.h
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <IGListKit/IGListKit.h>

@protocol FSDiscoveryBannerSectionDelegate <NSObject>
@optional
- (void)discoveryBannerSectionDidClicked;
@end

@interface FSDiscoveryBannerSectionController : IGListSectionController

@property (nonatomic, weak) id<FSDiscoveryBannerSectionDelegate> delegate;

@end
