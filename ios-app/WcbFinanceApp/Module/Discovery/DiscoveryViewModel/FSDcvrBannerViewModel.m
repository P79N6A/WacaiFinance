//
//  FSDcvrBannerViewModel.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/11.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrBannerViewModel.h"

@implementation FSDcvrBannerViewModel

+ (UIEdgeInsets)sectionInset
{
    return UIEdgeInsetsMake(10, 16, 12, 16);
}

+ (NSInteger)itemSpacing
{
    return 10;
}

+ (CGSize)imageCellSize
{
    CGFloat showCount = 2.04;
    NSInteger spacing = [self itemSpacing];
    
    UIEdgeInsets inset = [self sectionInset];
    
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSInteger width = (screenWidth - inset.left - 2 *spacing) / showCount;
    
    NSInteger height = (75.0 / 166.0)* width;
    
    CGSize size = CGSizeMake(width, height);
    return size;
}

+ (NSInteger)bannerHeight
{
    UIEdgeInsets inset = [self sectionInset];
    CGSize cellSize = [self imageCellSize];
    
    NSInteger height = inset.top + inset.bottom + cellSize.height;
    return height;
}

@end
