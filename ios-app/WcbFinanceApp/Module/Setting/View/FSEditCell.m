//
//  FSEditCell.m
//  Financeapp
//
//  Created by xingyong on 14/10/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSEditCell.h"

@implementation FSEditCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.editTextField];
        
        [self.editTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    return self;
}
- (UITextField *)editTextField
{
    if (!_editTextField) {
        _editTextField = [[UITextField alloc] init];
        _editTextField.font = [UIFont systemFontOfSize:15];
        _editTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_editTextField addTarget:self action:@selector(onTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
        _editTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
    return _editTextField;
}
- (void)onTextFieldAction:(UITextField *)textField{
    if (self.editActionBlock) {
        self.editActionBlock(textField.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
