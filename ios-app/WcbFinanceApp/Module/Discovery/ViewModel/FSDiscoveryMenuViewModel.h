//
//  FSDiscoveryMenuViewModel.h
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDiscoveryMenuViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *menuCommand;
@property (nonatomic, copy) NSArray *menuModels;
@property (nonatomic, strong) NSError *error;

@end
