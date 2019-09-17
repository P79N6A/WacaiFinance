//
//  FSLoginNeutronRouter.m
//  WcbFinanceApp
//
//  Created by xingyong on 04/12/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLoginNeutronRouter.h"

@implementation FSLoginNeutronRouter

+ (UIViewController*)loginWithQS:(NSString *)qs
                                context:(TNTRoutingContext *)context{
    [FSGotoUtility gotoLoginViewController:nil success:^{
        [context.callback onDone:@"login done"];
    } cancel:^{
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"login cancelled"};
        NSError *error = [NSError errorWithDomain:@"com.hangzhoucaimi.finance"
                                             code:1000
                                         userInfo:userInfo];
        [context.callback onError:error];
    }];
    return nil;
}

@end
