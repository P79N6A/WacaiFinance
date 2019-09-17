//
//  FSDiscoveryPostCell.m
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryPostCell.h"

@interface FSDiscoveryPostCell ()

@property (nonatomic, strong) UIImageView *tagImageView;

@end

@implementation FSDiscoveryPostCell

- (void)setupSubviews {
    [super setupSubviews];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = ({
        CMAttributedLabel *label = [[CMAttributedLabel alloc] init];
        [label setVerticalAlign:kCMVerticalTopAlign];
        label.numberOfLines = 2;
        label;
    });
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(18);
        make.height.equalTo(@46);
    }];
    
    self.illustrationImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView;
    });
    [self.contentView addSubview:self.illustrationImageView];
    [self.illustrationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-16);
        make.left.equalTo(self.titleLabel.mas_right).offset(8);
        make.width.height.equalTo(@90);
    }];
    
    self.tagImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView;
    });
    [self.contentView addSubview:self.tagImageView];
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        CGFloat tagWidth = [self shouldShowTag] ? 22 : 0;
        make.width.equalTo(@(tagWidth));
        make.height.equalTo(@12);
    }];
    
    
    self.moduleNameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"#FF666666"];
        label.font = [UIFont systemFontOfSize:10];
        label;
    });
    [self.contentView addSubview:self.moduleNameLabel];
    [self.moduleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self shouldShowTag]) {
            make.left.equalTo(self.contentView).offset(16+22+6);
        } else {
            make.left.equalTo(self.contentView).offset(16);
        }
        make.centerY.equalTo(self.tagImageView);
        make.height.equalTo(@10);
    }];
    
    
    self.authorNameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"#FF999999"];
        label.font = [UIFont systemFontOfSize:10];
        label;
    });
    [self.contentView addSubview:self.authorNameLabel];
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.bottom.equalTo(self.illustrationImageView);
        make.height.equalTo(@10);
        make.width.equalTo(@110);
    }];
    
    
    self.readCountLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"#FF999999"];
        label.font = [UIFont systemFontOfSize:10];
        label;
    });
    [self.contentView addSubview:self.readCountLabel];
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel).mas_offset(-12);
        make.bottom.equalTo(self.authorNameLabel);
        make.height.equalTo(@10);
    }];
    
    
    UIView *bottomLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        view;
    });
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}

- (void)updateConstraints {
    [self.tagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat tagWidth = [self shouldShowTag] ? 22 : 0;
        make.width.equalTo(@(tagWidth));
    }];
    
    [self.moduleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([self shouldShowTag]) {
            make.left.equalTo(self.contentView).offset(16+22+6);
        } else {
            make.left.equalTo(self.contentView).offset(16);
        }
    }];
    
    [super updateConstraints];
}

- (void)setType:(FSDiscoveryPostType)type {
    if (type != _type) {
        _type = type;
        if ([self shouldShowTag]) {
            self.tagImageView.image = [self tagImage:type];
        }
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
}

- (BOOL)shouldShowTag {
    if (self.type == FSDiscoveryPostTypeNone) {
        return NO;
    } else {
        return YES;
    }
}

- (UIImage *)tagImage:(FSDiscoveryPostType)type {
    if (FSDiscoveryPostTypeHot == type) {
        return [UIImage imageNamed:@"discovery_post_hot"];
    } else if (FSDiscoveryPostTypeLatest == type) {
        return [UIImage imageNamed:@"discovery_post_new"];
    } else {
        return nil;
    }
}

@end
