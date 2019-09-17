//
//  FSDiscoveryTag.h
//  Financeapp
//
//  Created by 叶帆 on 21/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDiscoveryTag : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tagID;

+ (instancetype)tagWithName:(NSString *)name ID:(NSString *)tagID;

@end
