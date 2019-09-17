//
//  FSDiscoveryExceptionCell.m
//  Financeapp
//
//  Created by 叶帆 on 29/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryExceptionCell.h"



@implementation FSDiscoveryExceptionCell

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
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"exception_placeholder"];
        imageView;
    });
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@80);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-18);
    }];
    
    UILabel *label = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"加载异常，请下拉刷新";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"#FF666666"];
        label;
    });
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(30);
    }];
}

- (void)hiddenPlaceHolderView:(BOOL)hidden{
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = hidden;
    }];
}
@end
