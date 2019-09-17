//
//  HostListManager.h
//  HTTPDNSExample
//
//  Created by 破山 on 2018/11/20.
//  Copyright © 2018年 Wacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FSHTTPDNS/FSHTTPDNSWhiteListProtocol.h>

@interface HostListManager : NSObject <FSHTTPDNSWhiteListProtocol>

+ (instancetype)sharedInstance;

- (void)addHost:(NSString *)host;

- (NSArray *)currentHostList;

- (BOOL)isRequestUseHttpDns:(NSURLRequest *)request;

@end
