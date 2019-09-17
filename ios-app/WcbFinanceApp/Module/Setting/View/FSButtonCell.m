//
//  FSButtonCell.m
//  WcbFinanceApp
//
//  Created by howie on 2019/9/4.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSButtonCell.h"
#import "UIColor+FSUtils.h"
#import <Masonry/Masonry.h>

@implementation FSButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView{
    
    _subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subscribeButton.backgroundColor = [UIColor colorWithHex:0xd94b40];
    [_subscribeButton setTitle:@"立即申购" forState:UIControlStateNormal];
    [_subscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_subscribeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _subscribeButton.layer.cornerRadius = 2;
    _subscribeButton.userInteractionEnabled = NO;
    
    [self.contentView addSubview:_subscribeButton];
    [_subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
}

- (void)configButtonTitle:(NSString *)title{
    [self.subscribeButton setTitle:title forState:UIControlStateNormal];
}

- (void)configButtonTitle:(NSString *)title backgroundColor:(UIColor *)color{
    [self.subscribeButton setTitle:title forState:UIControlStateNormal];
    
    [self.subscribeButton setTitleColor:[UIColor colorWithHex:0x2c88de] forState:UIControlStateNormal];
    [self.subscribeButton setBackgroundColor:color];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

