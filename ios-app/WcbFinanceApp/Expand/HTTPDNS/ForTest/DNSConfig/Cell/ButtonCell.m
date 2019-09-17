//
//  ButtonCell.m
//  HttpdnsDemoExample
//
//  Created by 破山 on 2018/11/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

#define HEXCOLOR(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    [self.button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button.titleLabel setFont:[UIFont systemFontOfSize:16]];

    [self.button setBackgroundColor:HEXCOLOR(0xD94B40)];
    
    _button.layer.cornerRadius = 2;
    _button.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContent:(NSString *)content
{
    [self.button setTitle:content forState:UIControlStateNormal];
}

@end
