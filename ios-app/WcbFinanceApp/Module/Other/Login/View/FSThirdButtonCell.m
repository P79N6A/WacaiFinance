//
//  FSThirdButtonCell.m
//  FinanceApp
//
//  Created by xingyong on 12/1/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "FSThirdButtonCell.h"
#import "SocialShareSDK.h"
#import "FSGradientView.h"

@interface FSButtonItem : UIView
@property(nonatomic,strong) UIButton *button;

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image;
@end

@implementation FSButtonItem

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:image forState:UIControlStateNormal];
  
        [self addSubview:_button];
        
        __weak typeof(self) weakSelf = self;
 
        [_button makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
 
        }];
        

    }
    return self;
}


@end

@implementation FSThirdButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupView];

    }
    return self;
}

- (void)setupView{
    
    NSInteger mid = ScreenWidth / 2;
    NSArray *colors = @[HEXCOLOR(0xe0e0e0), [UIColor whiteColor]];

    FSGradientView *lineLeft = [[FSGradientView alloc] init];
    lineLeft.frame = CGRectMake(20, 10, mid - 40 - 20., 1);
    //lineView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    
    [lineLeft setGradientBackgroundWithColors:colors locations:nil startPoint:CGPointMake(1, 0) endPoint:CGPointMake(0, 0)];
    [self.contentView addSubview:lineLeft];
    
    FSGradientView *lineRight = [[FSGradientView alloc] init];
    lineRight.frame = CGRectMake(mid + 40, 10, mid - 40 - 20., 1);
    //lineView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    
    [lineRight setGradientBackgroundWithColors:colors locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self.contentView addSubview:lineRight];
    
    
    
    UILabel *loginLabel = [[UILabel alloc] init];
    loginLabel.text = @"使用其他方式";
    loginLabel.font = [UIFont systemFontOfSize:12];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.textColor = [UIColor lightGrayColor];
    loginLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:loginLabel];
    [loginLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
        make.centerX.equalTo(self.contentView);
    }];
    UIView *containerView = [[UIView alloc] init];

    [self.contentView addSubview:containerView];
//    containerView.backgroundColor = [UIColor orangeColor];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
  
    //按钮顺序：QQ*、微信*、新浪微博
    NSMutableArray *buttonItems = [NSMutableArray new];
    
    if ([SOCIALSHARESDK isInstallShareType:SSShareTypeWeChat]) {
        FSButtonItem *item = [[FSButtonItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"new_wechat"]];
        item.button.tag = FSThirdButtonTypeWeChat;
        [buttonItems addObject:item];
    }
    
//    if ([SOCIALSHARESDK isInstallShareType:SSShareTypeQQ]) {
        FSButtonItem *item = [[FSButtonItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"new_qq"]];
        item.button.tag = FSThirdButtonTypeQQ;
        [buttonItems addObject:item];
//    }
    
    
    if([SOCIALSHARESDK isInstallShareType:SSShareTypeWeibo]){
        FSButtonItem *item = [[FSButtonItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"new_weibo"]];
        item.button.tag = FSThirdButtonTypeSina;
        [buttonItems addObject:item];
    }
    
    
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width - 60.)/[buttonItems count];
    
    [buttonItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FSButtonItem *buttonItem = obj;
        buttonItem.frame = CGRectMake(width * idx, 28, width, 45.);
        [buttonItem.button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:buttonItem];
    }];
    
}

- (void)onButtonClick:(UIButton *)sender{
    FSThirdButtonType type = sender.tag;
    if (self.buttonBlock) {
        self.buttonBlock(type);
    }
}

+ (NSInteger)cellHeight
{
    return 158;
}



@end
