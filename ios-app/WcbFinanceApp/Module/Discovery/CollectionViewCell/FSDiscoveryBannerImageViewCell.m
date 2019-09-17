//
//  FSDiscoveryBannerImageViewCell.m
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBannerImageViewCell.h"

@implementation FSDiscoveryBannerImageViewCell

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
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 2;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.width.equalTo(@180);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
