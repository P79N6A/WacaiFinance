//
//  FSDiscoveryBindPromotionViewModel.h
//  Financeapp
//
//  Created by 叶帆 on 23/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDiscoveryBindPromotionViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *promotionTextCommand;

@property (nonatomic, copy) NSString *bindPromotionText;

@end
