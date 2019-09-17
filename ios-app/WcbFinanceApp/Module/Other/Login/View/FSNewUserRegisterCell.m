//
//  FSNewUserRegisterCellTableViewCell.m
//  Financeapp
//
//  Created by luowen on 2017/8/3.
//  Copyright © 2017年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSNewUserRegisterCell.h"

@interface FSNewUserRegisterCell()

@property(nonatomic,strong) UIButton *subscribeButton;

@end

@implementation FSNewUserRegisterCell

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
    _subscribeButton.backgroundColor = [UIColor clearColor];
    [_subscribeButton setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_subscribeButton setTitleColor:[UIColor colorWithHex:0xd94b40] forState:UIControlStateNormal];
    [_subscribeButton setImage:[UIImage imageNamed:@"icon_login_asset"] forState:UIControlStateNormal];
    [_subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_subscribeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _subscribeButton.layer.cornerRadius = 2;
    _subscribeButton.layer.borderWidth = 1;
    _subscribeButton.layer.borderColor = [UIColor colorWithHex:0xd94b40].CGColor;
    _subscribeButton.userInteractionEnabled = NO;
    
    [self.contentView addSubview:_subscribeButton];
    [_subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}

@end
