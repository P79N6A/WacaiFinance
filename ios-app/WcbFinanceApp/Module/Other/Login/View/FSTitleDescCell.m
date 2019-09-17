//
//  FSTitleDescCell.m
//  FinanceApp
//
//  Created by xingyong on 12/1/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "FSTitleDescCell.h"
#import <TTTAttributedLabel.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FSTitleDescCell()

@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) TTTAttributedLabel *descLabel;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation FSTitleDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView{
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:26];
    if(!font)
    {
        font = [UIFont systemFontOfSize:26];
    }
    welcomeLabel.font = font;
    welcomeLabel.textColor = [UIColor colorWithHex:0x333333];
    welcomeLabel.textAlignment = NSTextAlignmentLeft;
    welcomeLabel.text = @"欢迎加入挖财宝";
    [self.contentView addSubview:welcomeLabel];
    [welcomeLabel makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(36);;
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(37);
        
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"login_gift"];
    
    self.icon = icon;
    
    [self.contentView addSubview:icon];
    [icon makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(welcomeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(16);
    }];
    
    
    TTTAttributedLabel *descLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(23, 23, 20, 20)];
    
    self.descLabel = descLabel;
    
    UIFont *tFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    if(!tFont)
    {
        tFont = [UIFont systemFontOfSize:15];
    }
    
    descLabel.font = tFont;
    descLabel.textColor = [UIColor colorWithHex:0xD94B40];
    descLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    descLabel.text = @"新用户注册即送218元红包";
    descLabel.lineSpacing = 2;
    
    [self.contentView addSubview:descLabel];
    [descLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(welcomeLabel.mas_bottom).offset(7);
        make.left.equalTo(icon.mas_right).offset(5);
        make.right.mas_equalTo(-23);
        make.bottom.equalTo(self.contentView);
    }];
    descLabel.numberOfLines = 0;
}

- (void)fillContent:(NSString *)content;
{
    NSString *text = content ? content :@"";
    if(text.length <= 0)
    {
        self.icon.hidden = YES;
    }
    else
    {
        self.icon.hidden = NO;
    }
    
    self.descLabel.text = text;
    self.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
