//
//  FSFloatWindowHandler.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFloatWindowHandler : NSObject

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)requestPopupDataWhenViewDidLoad;


@end
