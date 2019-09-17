//
//  TitleAndTextFieldCell.m
//  FinanceApp
//
//  Created by 叶帆 on 1/12/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "TitleAndTextFieldCell.h"

@implementation TitleAndTextFieldCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@80);
        }];
        
        [self.contentView addSubview:self.textField];
        [self.textField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(16);
            make.right.equalTo(self.contentView).offset(-16);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}


#pragma mark - getter & setter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.textAlignment = NSTextAlignmentLeft;
    }
    return _textField;
}

@end
