//
//  FSDcvrFinServerBannerSectionController.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/13.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "IGListSectionController.h"

@protocol FSDcvrFinServerBannerSectionDelegate <NSObject>
@optional
- (void)dcvrFinServerBannerSectionDidClicked;
@end

@interface FSDcvrFinServerBannerSectionController : IGListSectionController

@property (nonatomic, weak) id<FSDcvrFinServerBannerSectionDelegate>delegate;


@end
