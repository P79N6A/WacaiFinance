//
//  FSDiscoveryPostRequest.h
//  Financeapp
//
//  Created by kuyeluofan on 26/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <i-Finance-Library/FSSDKRequest.h>

@interface FSDiscoveryPostRequest : FSSDKRequest

@property (nonatomic, copy)     NSString *moduleId;
@property (nonatomic, strong)   NSNumber *lastPublishTime;
@property (nonatomic, strong)   NSNumber *pageSize;

@end
