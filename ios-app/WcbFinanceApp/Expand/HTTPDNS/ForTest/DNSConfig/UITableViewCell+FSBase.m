//
//  UITableViewCell+FSBase.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/13.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "UITableViewCell+FSBase.h"

@implementation UITableViewCell (FSBase)

+ (NSString *)FSCellIdentifier
{
    return NSStringFromClass([self class]);
}

@end
