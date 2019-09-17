//
//  FSDiscoveryBannerViewModel.h
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDiscoveryBanner.h"

@interface FSDiscoveryBannerViewModel : NSObject

- (instancetype)initWithBelongModule:(NSString *)belongModule;

@property (nonatomic, strong, readonly) RACCommand *bannerCommand;
@property (nonatomic, strong) NSString* belongModule;

@property (nonatomic, strong) NSArray<FSDiscoveryBanner *> *banners;
@property (nonatomic, strong) NSError *error;

@end
