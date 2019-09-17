//
//  TitleWithSwitchCell.m
//  FinanceApp
//
//  Created by new on 15/2/14.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import "TitleWithSwitchCell.h"
#import "UIColor+FSUtils.h"

static const CGFloat kMargin = 16;

@implementation TitleWithSwitchCell

@synthesize mDelegate;

+ (TitleWithSwitchCell*)cellWithTitle:(NSString*)title switchState:(BOOL)isOn delegate:(id<TitleWithSwitchCellDelegate>)delegate {
    return [[TitleWithSwitchCell alloc] initWithTitle:title subTitle:nil switchState:isOn delegate:delegate];
}

+ (TitleWithSwitchCell*)cellWithTitle:(NSString*)title subTitle:(NSString *)subTitle switchState:(BOOL)isOn delegate:(id<TitleWithSwitchCellDelegate>)delegate {
    return [[TitleWithSwitchCell alloc] initWithTitle:title subTitle:subTitle switchState:isOn delegate:delegate];
}

- (instancetype)initWithTitle:(NSString*)title subTitle:(NSString *)subTitle switchState:(BOOL)isOn delegate:(id<TitleWithSwitchCellDelegate>)delegate {
    self = [super init];
    if (self) {
        self.mTitleLabel.text = title;
        self.mSubtitleLabel.text = subTitle;
        self.mSwitch.on = isOn;
        self.mDelegate = delegate;
        [self initWithSubTitle:subTitle];
    }
    return self;
}

- (void)initWithSubTitle:(NSString *)subTitle {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mSwitch];
    [self.mSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kMargin);
        make.centerY.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.mTitleLabel];
    [self.mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.centerY.equalTo(self.contentView);
    }];
    if (subTitle) {
        [self.mTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMargin);
            make.top.mas_equalTo(12);
        }];
        [self.contentView addSubview:self.mSubtitleLabel];
        [self.mSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMargin);
            make.top.equalTo(self.mTitleLabel.mas_bottom).mas_offset(4);
        }];
    }
}

- (void)updateSwitchState:(BOOL)isOn switchCell:(id)sender{
    [_mSwitch setOn:isOn];
}

- (IBAction)doSwitch:(id)sender {
    if ([mDelegate respondsToSelector:@selector(switchStateTo:switchCell:)]) {
        [mDelegate switchStateTo:_mSwitch.isOn switchCell:self];
    }
}

- (void)setSwitchonTintColor:(UIColor *)color {
    self.mSwitch.onTintColor = color;
}

- (UILabel *)mTitleLabel{
    if (_mTitleLabel == nil) {
        _mTitleLabel           = [[UILabel alloc] init];
        _mTitleLabel.font      = [UIFont systemFontOfSize:16];
        _mTitleLabel.textColor = [UIColor colorWithHex:0x000000];
    }
    return _mTitleLabel;
}

- (UILabel *)mSubtitleLabel {
    if (_mSubtitleLabel == nil) {
        _mSubtitleLabel = [[UILabel alloc] init];
        _mSubtitleLabel.font = [UIFont systemFontOfSize:12];
        _mSubtitleLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    return _mSubtitleLabel;
}

- (UISwitch *)mSwitch{
    if(_mSwitch == nil){
        _mSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_mSwitch addTarget:self action:@selector(doSwitch:) forControlEvents:UIControlEventValueChanged];
        _mSwitch.onTintColor = [UIColor colorWithHexString:@"#0e9dff"];
    }
    return _mSwitch;
}
@end
