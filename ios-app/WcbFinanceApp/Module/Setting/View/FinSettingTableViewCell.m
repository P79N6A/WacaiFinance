//
//  FinSettingTableViewCell.m
//  FinanceSDK
//
//  Created by Alex on 7/20/15.
//  Copyright (c) 2015 com.wac.finance. All rights reserved.
//

#import "FinSettingTableViewCell.h"
#import <QuartzCore/CALayer.h>
#import "UIColor+FSUtils.h"

static const CGFloat kMargin = 16;

@interface FinSettingTableViewCell ()

@property (nonatomic, strong) MASConstraint *titleLeftToSuper;
@property (nonatomic, strong) MASConstraint *titleLeftToIcon;

@property (nonatomic, strong) MASConstraint *detailTitleRightToSuper;
@property (nonatomic, strong) MASConstraint *detailtitleRightToArrow;


@end

@implementation FinSettingTableViewCell


 -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.settingTitleLabel];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.settingDetailLabel];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.redBadge];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kMargin));
            make.centerY.equalTo(@0);
            
            make.width.height.equalTo(@20);
        }];
        
        [self.settingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.titleLeftToIcon = make.left.equalTo(self.iconImageView.mas_right).offset(9);
            self.titleLeftToSuper = make.left.equalTo(@(kMargin));
            
            make.centerY.equalTo(@0);
        }];
        
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-kMargin));
            make.centerY.equalTo(@0);
        }];
        
        [self.settingDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.detailtitleRightToArrow = make.right.equalTo(self.arrowImageView.mas_left).offset(-5);
            self.detailTitleRightToSuper = make.right.equalTo(@(-kMargin));
            make.centerY.equalTo(@0);
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.settingDetailLabel.mas_left).offset(-5);
            make.left.greaterThanOrEqualTo(self.settingTitleLabel.mas_right).offset(5);
            make.width.height.equalTo(@32);
            make.centerY.equalTo(@0);
        }];
        
        [self.redBadge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconImageView).offset(12);
            make.centerY.equalTo(self.iconImageView).offset(-12);
        }];
        
        [self.settingTitleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.iconImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    [self titleToIcon];
    [self detaialTitleToArrow];
    
    return self;
}

- (void)titleToIcon
{
    [self.titleLeftToIcon activate];
    [self.titleLeftToSuper deactivate];
}

- (void)titleToSuper
{
    [self.titleLeftToIcon deactivate];
    [self.titleLeftToSuper activate];
}


- (void)detaialTitleToArrow
{
    [self.detailtitleRightToArrow activate];
    [self.detailTitleRightToSuper deactivate];
}


- (void)detaialTitleToSuper
{
    [self.detailtitleRightToArrow deactivate];
    [self.detailTitleRightToSuper activate];
}


#pragma mark - Getter and Setter
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    
    return _iconImageView;
}

- (UILabel *)settingTitleLabel
{
    if (!_settingTitleLabel) {
        _settingTitleLabel = [UILabel new];
        _settingTitleLabel.backgroundColor = [UIColor clearColor];
        _settingTitleLabel.textColor = [UIColor blackColor];
        _settingTitleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _settingTitleLabel;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
    }
    
    return _rightImageView;
}

- (UILabel *)settingDetailLabel
{
    if (!_settingDetailLabel) {
        _settingDetailLabel = [UILabel new];
        _settingDetailLabel.backgroundColor = [UIColor clearColor];
        _settingDetailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _settingDetailLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _settingDetailLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        UIImage *arrowImage = [UIImage imageNamed:@"arrow_gray"];
        _arrowImageView.image = arrowImage;
    }
    
    return _arrowImageView;
}

- (UIImageView *)redBadge
{
    if (!_redBadge) {
        _redBadge = [UIImageView new];
        UIImage *redBadge = [UIImage imageNamed:@"reddot"];
        _redBadge.image = redBadge;
        _redBadge.hidden = YES;
    }
    
    return _redBadge;
}

@end


























