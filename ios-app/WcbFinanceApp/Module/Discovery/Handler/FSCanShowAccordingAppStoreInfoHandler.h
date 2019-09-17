//
//  FSCanShowAccordingAppStoreInfoHandler.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/12.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSCanShowAccordingAppStoreInfoHandler : NSObject

- (void)requestAppStoreInfo:(void(^)(BOOL canshow))block;

@end
