//
//  FSDiscoveryBanner.h
//  Financeapp
//
//  Created by 叶帆 on 21/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDiscoveryBanner : NSObject<IGListDiffable>

@property (nonatomic, strong) NSString *bannerID;
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *linkURL;

@end
