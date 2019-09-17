//
//  FSAssetUserMemberView.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAssetUserMemberView.h"
#import "FSAssetUserInfo.h"
#import "FSAssetUserLevelInfo.h"
#import "NSAttributedString+FSUtil.h"
#import "FSUserLevelInfo.h"

static const NSUInteger kAvatarEdge = 22;
static const NSUInteger kLabelLeftMargin = 4;
static const NSUInteger kLabelRightMargin = 0;

@interface FSAssetUserMemberView ()

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIControl *tapControl;

@end

@implementation FSAssetUserMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupSubviews];
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        self.layer.cornerRadius = 10;
        
    }
    return self;
}

- (void)setupSubviews
{
    _levelIconView  = [[UIImageView alloc] init];
    [self addSubview:_levelIconView];
    _levelIconView.clipsToBounds = YES;
    _levelIconView.layer.cornerRadius = kAvatarEdge/2;
    _levelIconView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_levelIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.equalTo(@(kAvatarEdge));
        make.left.equalTo(@(0));
        make.centerY.equalTo(self);
    }];
    
    
    _arrowView = [[UIImageView alloc] init];
    [self addSubview:_arrowView];
    _arrowView.image = [UIImage imageNamed:@"asset_member_arrow"];
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.equalTo(@(8));
        make.right.equalTo(@(-6));
        make.centerY.equalTo(self);
        
    }];
    
    _levelLabel = [[UILabel alloc] init];
    [self addSubview:_levelLabel];
    _levelLabel.text = @"--会员";
    
    _levelLabel.font = [UIFont boldSystemFontOfSize:11.0];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:11.0];
    if(font)
    {
        _levelLabel.font = font;
    }
    
    _levelLabel.textColor = RGBA(0xC9, 0x55, 0x47, 1.0);
    _levelLabel.backgroundColor = [UIColor clearColor];
    
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.levelIconView.mas_right).offset(kLabelLeftMargin);
        make.right.equalTo(self.arrowView.mas_left).offset(kLabelRightMargin);
        make.height.equalTo(@(16));
        make.centerY.equalTo(self);
        
    }];
    
    _tapControl = [[UIControl alloc] init];
    [self addSubview:_tapControl];
    
    [_tapControl addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tapControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)onTap:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(userMemberViewTap)])
    {
        [self.delegate userMemberViewTap];
    }
}

- (void)updateUserLevelView:(FSUserLevelInfo *)levelInfo {
    self.levelLabel.text = [levelInfo.levelName CM_isValidString] ? levelInfo.levelName : @"--会员";
    self.levelIconView.image = [self iconOfLevel:levelInfo];
}

- (UIImage *)iconOfLevel:(FSUserLevelInfo *)levelInfo {
    NSUInteger levelValue = levelInfo.levelValue;
    UIImage *icon = nil;
    switch (levelValue) {
        case 1:
            icon = [UIImage imageNamed:@"vip_icon_standard"];
            break;
        case 2:
            icon = [UIImage imageNamed:@"vip_icon_bronze"];
            break;
        case 3:
            icon = [UIImage imageNamed:@"vip_icon_silver"];
            break;
        case 4:
            icon = [UIImage imageNamed:@"vip_icon_gold"];
            break;
        case 5:
            icon = [UIImage imageNamed:@"vip_icon_platinum"];
            break;
        case 6:
            icon = [UIImage imageNamed:@"vip_icon_diamond"];
            break;
        default:
            icon = [UIImage imageNamed:@"vip_icon_default"];
            break;
    }
    return icon;
}


- (CGFloat)viewHeight
{
    return 20;
}

- (CGFloat)widthForLevelInfo:(FSUserLevelInfo *)levelInfo
{
    NSString *levelString = @"";
    
    if([levelInfo.levelName CM_isValidString]) {
        levelString = levelInfo.levelName;
    } else {
        levelString = @"--会员";
    }
    
    NSInteger contentWidth = 80;
    NSDictionary *attribute = @{NSFontAttributeName:self.levelLabel.font};
    
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:levelString attributes:attribute];
    contentWidth = [tmp widthForFixHeight:16];
    
    CGFloat viewWidth = kAvatarEdge + kLabelLeftMargin + contentWidth + kLabelRightMargin + 16;
    
    return viewWidth;
}


@end
