//
//  FSDiscoverFServiceMenuCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/10.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoverFServiceMenuCell.h"
#import "FSMenuData.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FSDiscoverFServiceMenuCell()

@property (nonatomic, strong) UIView *bottomLine;

@end;


@implementation FSDiscoverFServiceMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
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


- (void)dealloc
{
    NSLog(@"Dealloc %@", self);
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];

    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(28);
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(16);
    }];
    
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    if(font)
    {
        self.titleLabel.font = font;
    }
    
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.imageView);
        make.left.equalTo(self.imageView.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-2);
        
    }];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
    [self.contentView addSubview:self.bottomLine];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(1);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
    
    
}

- (void)fillContent:(FSMenuData *)object showBottomline:(BOOL)show
{
    if(!object)
    {
        return;
    }

    self.bottomLine.hidden = !show;
    self.titleLabel.text = object.name;
    
    NSString *imageUrl = object.status ? object.tipIconSrc : object.iconSrc;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:[UIImage imageNamed:@"menu_default"]];
}

+ (NSString *)cellIdentifer
{
    return NSStringFromClass([self class]);
}

@end
