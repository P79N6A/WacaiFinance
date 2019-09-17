//
//  FSTextField.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/21.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSTextField.h"

@implementation FSTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    [self setCustomPlaceHolder];
}

- (void)setCustomPlaceHolder
{
    NSString *holderText = self.placeholder;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xc0c0c0) range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, holderText.length)];
    
    self.attributedPlaceholder = placeholder;
}


@end
