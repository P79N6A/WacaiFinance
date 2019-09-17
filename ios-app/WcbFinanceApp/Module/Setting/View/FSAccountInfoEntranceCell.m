//
//  FSAccountInfoEntranceCell.m
//  FinanceApp
//
//  Created by 叶帆 on 16/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSAccountInfoEntranceCell.h"

static const CGFloat kMargin = 16;
static const CGFloat kAvatarImageDiameter = 45;

@implementation FSAccountInfoEntranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.avatarImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = kAvatarImageDiameter / 2;
            imageView.clipsToBounds = YES;
            imageView;
        });
        [self.contentView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kMargin));
            make.centerY.equalTo(@0);
            make.width.height.equalTo(@(kAvatarImageDiameter));
        }];
        
        
        self.nicknameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            label;
        });
        [self.contentView addSubview:self.nicknameLabel];
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(15);
            make.centerY.equalTo(@0);
        }];
        
        
        self.arrowImageView = ({
            UIImage *arrowImage = [UIImage imageNamed:@"arrow_gray"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
            imageView;
        });
        [self.contentView addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLabel.mas_right).offset(8);
            make.right.equalTo(@(-kMargin));
            make.centerY.equalTo(@0);
        }];
        
        [self.arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.arrowImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.avatarImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.avatarImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

@end
