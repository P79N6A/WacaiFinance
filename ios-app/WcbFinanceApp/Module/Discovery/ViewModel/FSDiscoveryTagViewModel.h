//
//  FSDiscoveryTagViewModel.h
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDiscoveryTag.h"

@interface FSDiscoveryTagViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *tagCommand;
@property (nonatomic, strong) NSArray<FSDiscoveryTag *> *tags;

@end
