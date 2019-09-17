//
//  FSLoginInputCell.m
//  FinanceApp
//
//  Created by xingyong on 12/2/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "FSLoginInputCell.h"
#import "FSTextField.h"

@interface FSLoginInputCell ()<UITextFieldDelegate>

@property (nonatomic, strong) MASConstraint *constraintTextFieldRightToSuper;
@property (nonatomic, strong) MASConstraint *constraintTextFieldRightToButton;
@property (nonatomic, strong) MASConstraint *constrainHidetRightButton;

@property (nonatomic, assign) NSUInteger count;


@end


@implementation FSLoginInputCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.contentView addSubview:self.iconImageView];
//        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(20);
//            make.centerY.equalTo(self.contentView);
//
//            make.height.with.equalTo(@16);
//        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.rightButton];
        [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-25);
            make.centerY.equalTo(self.contentView);

            self.constrainHidetRightButton = make.width.equalTo(@0);

        }];
        
        [self.contentView addSubview:self.inputTextField];
        [self.inputTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(23);
            self.constraintTextFieldRightToSuper = make.right.equalTo(self.contentView).offset(-23);
            self.constraintTextFieldRightToButton = make.right.equalTo(self.rightButton.mas_left).offset(-13);
            
            make.top.bottom.equalTo(self.contentView);
      
        }];
        
        
        [self.contentView addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(23);
            make.right.mas_equalTo(-23);
            make.bottom.mas_equalTo(-1);
            make.height.mas_equalTo(0.5);
            
        }];
        
        
        //优先拉伸 inputTextField 
        [self.iconImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.inputTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.rightButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return self;
}



- (void)setHideRighButton
{
    self.rightButton.hidden = YES;
    
    [self.constraintTextFieldRightToButton deactivate];
    [self.constraintTextFieldRightToSuper activate];
    [self.constrainHidetRightButton activate];
}


- (void)setShowRighButton
{
    self.rightButton.hidden = NO;
    
    [self.constraintTextFieldRightToButton activate];
    [self.constraintTextFieldRightToSuper deactivate];
    
    [self.constrainHidetRightButton deactivate];
}




#pragma mark - Event
- (void)buttonAction:(id)sender
{
    _buttonBlock();
}

- (void)textFieldAction:(id)sender
{
    _textFieldBlock();
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.lineView.backgroundColor = HEXCOLOR(0xD94B40);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.lineView.backgroundColor = HEXCOLOR(0xe7e7e7);
}

 

#pragma mark - Getter and Setter
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    
    return _iconImageView;
}

- (UITextField *)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [FSTextField new];
        _inputTextField.font = [UIFont systemFontOfSize:20];
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        _inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _inputTextField.delegate = self;
    }
    
    return _inputTextField;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton new];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightButton setTitleColor:HEXCOLOR(0x0d9cff) forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightButton;
}


- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =  HEXCOLOR(0xe7e7e7);
    }
    
    return _lineView;
}


 

@end
