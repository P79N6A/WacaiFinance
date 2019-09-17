//
//  FSDcvrFinServerMenuViewModel.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/11.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrFinServerMenuViewModel.h"

@implementation FSDcvrFinServerMenuViewModel

- (NSInteger)heightForMenus
{
    NSInteger lineHeight = 60;
    NSInteger lineCount = 0;
    if(self.menuArray.count % 2 == 0)
    {
        lineCount = self.menuArray.count /2;
    }
    else
    {
        lineCount = (self.menuArray.count + 1) /2;
    }
    
    return lineCount * lineHeight;
}

@end
