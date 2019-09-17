//
//  FSDiscoveryBindPromotionCell.m
//  Financeapp
//
//  Created by 叶帆 on 23/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBindPromotionCell.h"

@implementation FSDiscoveryBindPromotionCell

- (void)setupSubviews {
    [super setupSubviews];
    
    UIColor *cellBackgroundColor = [UIColor colorWithHexString:@"#fff1c1"];
    self.contentView.backgroundColor = cellBackgroundColor;
    self.backgroundColor = cellBackgroundColor;
    
    self.contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#d94b40"];
        label;
    });
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(-10);
    }];
    
    UIImageView *arrowImage = ({
        UIImage *arrowImage = [UIImage imageNamed:@"bind_arrow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
        imageView;
    });
    [self.contentView addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentLabel).offset(20);
    }];
    
    
}

@end
