//
//  FSAssetUserAssetView.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/25.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSProductData.h"

@interface FSAssetUserAssetView : UIView

@property(nonatomic,strong) FSProductData *productData;

- (void)hiddenMoney;


@end
