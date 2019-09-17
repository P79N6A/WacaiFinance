//
//  FSDiscoveryVIPEntranceCell.m
//  Financeapp
//
//  Created by 叶帆 on 10/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryVIPEntranceCell.h"

@interface FSDiscoveryVIPEntranceCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FSDiscoveryVIPEntranceCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.imageView = ({
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView;
    });
    
    self.titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        [self addSubview:label];
        label;
    });
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.centerX.equalTo(@16);
    }];
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel.mas_left).offset(-10);
    }];
}

- (void)setIcon:(UIImage *)image title:(NSString *)title {
    self.imageView.image = image;
    self.titleLabel.text = title;
}

@end
