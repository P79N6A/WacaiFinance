//
//  FSDiscoveryBadgeViewModel.h
//  Financeapp
//
//  Created by 叶帆 on 07/09/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDiscoveryBadgeViewModel : NSObject

@property (nonatomic, strong) NSNumber *unreadCount;

- (void)requestBadgeCount;

@end
