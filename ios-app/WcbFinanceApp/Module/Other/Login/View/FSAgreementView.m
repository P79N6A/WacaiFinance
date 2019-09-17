//
//  FSAgreementView.m
//  Financeapp
//
//  Created by xingyong on 16/10/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAgreementView.h"
#import "EnvironmentInfo.h"
#import <UIView+FSUtils.h>
#import "TTTAttributedLabel.h"
#import <Masonry.h>
#import "FSAgreementInfo.h"
#import "FSAgreementModel.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>

@interface FSAgreementView ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) FSAgreementInfo *aggreements;
@property (nonatomic, strong, readwrite) UIButton *checkBtn;
@property (nonatomic, strong) TTTAttributedLabel *attLabel;

@property (nonatomic, assign) CGSize contentSize;

@end

@implementation FSAgreementView

- (instancetype)initWithFrame:(CGRect)frame
                   agreements:(FSAgreementInfo *)agreements
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _aggreements = agreements;
        [self setupSubViews];
        [self updateViewWithAgreements:_aggreements];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)setupSubViews
{
    self.backgroundColor = [UIColor clearColor];
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(35., 0,self.bounds.size.width - 35., self.bounds.size.height)];
    [self addSubview:label];
    
    self.attLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
    }];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    
    //对齐方式
    label.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    //行间距
    label.lineSpacing = 2;
    label.delegate = self;
    
    UIColor *activeColor = [UIColor colorWithHexString:@"449bff"];
    NSMutableDictionary *activeLinkAttributes = [NSMutableDictionary dictionary];
    [activeLinkAttributes setValue:(__bridge id)activeColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    label.activeLinkAttributes = activeLinkAttributes;
    
    UIColor *linkColor = [UIColor colorWithHexString:@"449bff"];
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [activeLinkAttributes setValue:(__bridge id)linkColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    
    label.linkAttributes = linkAttributes;
    
    UIColor *inActivelinkColor = [UIColor colorWithHexString:@"999999"];
    NSMutableDictionary *inActivelinkAttributes = [NSMutableDictionary dictionary];
    [activeLinkAttributes setValue:(__bridge id)inActivelinkColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    
    label.inactiveLinkAttributes = inActivelinkAttributes;
    
    
    [self addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    
}

- (void)updateViewWithAgreements:(FSAgreementInfo *)agreements
{
    _aggreements = agreements;
    
    if(self.checkBtn.selected)
    {
        //已经勾选、不做处理
    }
    else
    {
        self.checkBtn.selected = agreements.focus;
        if(self.checkBlock)
        {
            self.checkBlock(self.checkBtn.isSelected);
        }
    }
    
    TTTAttributedLabel *label = self.attLabel;
    label.preferredMaxLayoutWidth = label.bounds.size.width;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    
    NSString *prefix = @"我已同意";
    NSString *content = [self contentStringForAgreements:self.aggreements.agreementArray prefix:prefix];
    
    NSArray *agreementArray = self.aggreements.agreementArray;
    
    CGFloat width = label.width;
    
    [label setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        UIColor *color = [UIColor colorWithHexString:@"449bff"];
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[color CGColor] range:NSMakeRange(0, content.length)];
        
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:prefix options:NSCaseInsensitiveSearch];
        
        UIColor *prefixColor = [UIColor colorWithHexString:@"999999"];
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[prefixColor CGColor] range:boldRange];
        
        CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString withConstraints:CGSizeMake(width, CGFLOAT_MAX) limitedToNumberOfLines:100];
        self.contentSize = size;
        
        return mutableAttributedString;
    }];
    
    NSRange searchRange = NSMakeRange(0, content.length);
    NSUInteger tLength = content.length;
    
    for(NSInteger i = 0; i < agreementArray.count; i ++)
    {
        FSAgreementModel *model = agreementArray[i];
        NSString *title = [self titleWithFrenchquotes:model.agreementTitle];
        NSRange range = [content rangeOfString:title options:NSCaseInsensitiveSearch range:searchRange];
        if(range.location != NSNotFound)
        {
            NSURL *url = [NSURL URLWithString:model.agreementURL];
            [label addLinkToURL:url withRange:range];
            
            NSUInteger loc = range.location + range.length;
            NSInteger  length = tLength - range.location - range.length;
            if(length <= 0)
            {
                break;
            }
            searchRange = NSMakeRange(loc, length);
        }
    }
    
    //取巧方式，显示结尾截断省略号
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [label setNeedsDisplay];
}



- (NSString *)contentStringForAgreements:(NSArray *)agreements prefix:(NSString *)prefix
{
    NSMutableString *tmp = [[NSMutableString alloc] init];
    [tmp appendString:prefix];
    for(NSInteger i = 0; i < agreements.count; i ++)
    {
        FSAgreementModel *model = agreements[i];
        NSString *title = [self titleWithFrenchquotes:model.agreementTitle];
        [tmp appendString:title];
    }
    
    return [tmp copy];
}

- (NSString *)titleWithFrenchquotes:(NSString *)title
{
    return [NSString stringWithFormat:@"%@",title];
}

- (void)onButtonAction:(UIButton *)btn
{
    BOOL selected = self.checkBtn.isSelected;
    self.checkBtn.selected = !selected;
    
    if(self.checkBlock)
    {
        self.checkBlock(self.checkBtn.isSelected);
    }
}

- (UIButton *)checkBtn{
    
    if (!_checkBtn) {
        
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_checkBtn addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_disagree"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_agree"] forState:UIControlStateSelected];
    }
    
    return _checkBtn;
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    [FSSDKGotoUtility openURL:url.absoluteString from:self.fs_parentViewController];
}

- (BOOL)accepted
{
    return self.checkBtn.isSelected;
}

- (void)setAccepted:(BOOL)accepted
{
    self.checkBtn.selected = accepted;
    if(self.checkBlock)
    {
        self.checkBlock(self.checkBtn.isSelected);
    }
}

- (CGFloat)contentHeight
{
    if(self.contentSize.height < 35.)
    {
        return 35.;
    }
    return self.contentSize.height;
}

@end
