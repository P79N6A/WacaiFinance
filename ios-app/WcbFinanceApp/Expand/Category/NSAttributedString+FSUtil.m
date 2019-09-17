//
//  NSAttributedString+FSUtil.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/17.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "NSAttributedString+FSUtil.h"

@implementation NSAttributedString (FSUtil)

- (CGFloat)widthForFixHeight:(CGFloat)height
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return ceil(rect.size.width);
}

- (CGFloat)heightForFixWdith:(CGFloat)width
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return ceil(rect.size.height);
}

@end
