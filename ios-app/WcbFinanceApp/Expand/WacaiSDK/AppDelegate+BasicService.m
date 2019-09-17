//
//  AppDelegate+BasicService.m
//  WcbFinanceApp
//
//  Created by howie on 2019/8/28.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "AppDelegate+BasicService.h"
#import <Neutron/TNTRouter.h>
#import <TrinityInit/TITrinityInitManager.h>
#import <AuthSDK/ASKAuthManager.h>

@implementation AppDelegate (BasicService)

- (void)initNeutron {
    [[TNTRouter sharedRouter] registerFetchRoutingTableInMGetTask];
}

- (void)initAuth {
    [[ASKAuthManager sharedInstance] setup];
}

- (void)initTrinity {
    [[TITrinityInitManager sharedInstance] setup];
}

@end
