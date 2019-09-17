//
//  FSDcvrTypeTitleCell.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSBaseAnimatedCell.h"
#import "FSDiscoveryTypeTitleData.h"

@interface FSDcvrTypeTitleCell : FSBaseAnimatedCell

@property (nonatomic, strong) FSDiscoveryTypeTitleData *titleData;

- (void)adjustForDiscovery;

@end
