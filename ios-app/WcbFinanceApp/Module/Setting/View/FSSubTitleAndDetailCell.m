//
//  FSSubTitleAndDetailCell.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 12/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSSubTitleAndDetailCell.h"

static const CGFloat kMargin = 16;

@implementation FSSubTitleAndDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mTitleLabel];
    [self.contentView addSubview:self.mSubtitleLabel];
    [self.contentView addSubview:self.mArrowImageView];
    [self.contentView addSubview:self.mDetailLabel];
    
    [self.mTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.top.mas_equalTo(12);
    }];
    [self.mSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.top.equalTo(self.mTitleLabel.mas_bottom).mas_offset(4);
    }];
    [self.mArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-kMargin));
        make.centerY.equalTo(@0);
    }];
    [self.mDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mArrowImageView.mas_left).offset(-5);
        make.centerY.equalTo(@0);
    }];
}


#pragma mark - getter & setter
- (UILabel *)mTitleLabel {
    if (!_mTitleLabel) {
        _mTitleLabel = [UILabel new];
        _mTitleLabel.backgroundColor = [UIColor clearColor];
        _mTitleLabel.textColor = [UIColor blackColor];
        _mTitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _mTitleLabel;
}

- (UILabel *)mSubtitleLabel {
    if (!_mSubtitleLabel) {
        _mSubtitleLabel = [[UILabel alloc] init];
        _mSubtitleLabel.font = [UIFont systemFontOfSize:12];
        _mSubtitleLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    return _mSubtitleLabel;
}

- (UILabel *)mDetailLabel {
    if (!_mDetailLabel) {
        _mDetailLabel = [UILabel new];
        _mDetailLabel.backgroundColor = [UIColor clearColor];
        _mDetailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _mDetailLabel.font = [UIFont systemFontOfSize:15];
    }
    return _mDetailLabel;
}

- (UIImageView *)mArrowImageView {
    if (!_mArrowImageView) {
        _mArrowImageView = [UIImageView new];
        UIImage *arrowImage = [UIImage imageNamed:@"arrow_gray"];
        _mArrowImageView.image = arrowImage;
    }
    return _mArrowImageView;
}

@end
