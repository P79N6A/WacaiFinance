//
//  FSLoginButtonCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/9.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLoginButtonCell.h"

@interface FSLoginButtonCell()

@property (nonatomic, assign) BOOL mEnable;

@end

@implementation FSLoginButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    [self.button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.layer.cornerRadius = 1;
    self.button.layer.masksToBounds = YES;
    [_button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _button.layer.cornerRadius = 2;
    _button.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEnable:(BOOL)enable
{
    UIColor *grayColor = RGBA(0xD9, 0x4b, 0x40, 0.7);
    _mEnable = enable;
    if(!enable)
    {
        [self.button setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateHighlighted];
        [self.button setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateDisabled];
    }
    else
    {
        [self.button setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD94B40)] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xB8453F)] forState:UIControlStateHighlighted];
        [self.button setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateDisabled];
    }
}

- (BOOL)enable
{
    return _mEnable;
}

- (void)fillContent:(NSString *)content
{
    [self.button setTitle:content forState:UIControlStateNormal];
}


@end
