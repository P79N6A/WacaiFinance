//
//  FSDiscoveryNavView.m
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryNavView.h"

@implementation FSDiscoveryNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHex:0xd84a3f];
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"发现";
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_StatusBarHeight);
        make.right.left.bottom.mas_equalTo(0);
    }];
    
    [self addSubview:self.settingBtn];
    
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(FS_StatusBarHeight);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)onButtonAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(navViewSettingBtnTap:)])
    {
        [self.delegate navViewSettingBtnTap:sender];
    }
}

- (UIButton *)settingBtn
{
    if(!_settingBtn)
    {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.tag = 2;
        
        _settingBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_settingBtn setTitle:@"账户设置" forState:UIControlStateNormal];
        [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

@end
