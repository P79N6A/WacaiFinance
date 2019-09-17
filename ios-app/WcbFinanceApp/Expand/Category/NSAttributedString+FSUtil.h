//
//  NSAttributedString+FSUtil.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/17.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (FSUtil)

- (CGFloat)widthForFixHeight:(CGFloat)height;
- (CGFloat)heightForFixWdith:(CGFloat)width;
@end
