//
//  FSLoginNeutronRouter.h
//  WcbFinanceApp
//
//  Created by xingyong on 04/12/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Neutron/Neutron.h>

@interface FSLoginNeutronRouter : NSObject

TNT_TARGET("sdk-user_login_1512369531784_6")
+ (UIViewController*)loginWithQS:(NSString *)qs
                                context:(TNTRoutingContext *)context;

@end
