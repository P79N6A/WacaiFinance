//
//  InputTableViewCell.m
//  FinanceApp
//
//  Created by Alex on 6/26/15.
//  Copyright (c) 2015 com.wacai.licai. All rights reserved.
//

#import "InputTableViewCell.h"

@interface InputTableViewCell ()

@property (nonatomic, strong) MASConstraint *constraintTextFieldRightToSuper;
@property (nonatomic, strong) MASConstraint *constraintTextFieldRightToButton;
@property (nonatomic, strong) MASConstraint *constraintHidetRightButton;

@property (nonatomic, strong) MASConstraint *constraintTextFieldLeftToSuper;
@property (nonatomic, strong) MASConstraint *constraintTextFieldLeftWithIcon;
@property (nonatomic, strong) MASConstraint *constraintHideLeftIcon;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation InputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.centerY.equalTo(self.contentView);
            
            make.height.with.equalTo(@22);
            
            self.constraintHideLeftIcon = make.width.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.rightButton];
        [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-16);
            make.centerY.equalTo(self.contentView);

            self.constraintHidetRightButton = make.width.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.inputTextField];
        [self.inputTextField makeConstraints:^(MASConstraintMaker *make) {
            
            self.constraintTextFieldRightToSuper = make.right.equalTo(self.contentView).offset(-16);
            self.constraintTextFieldRightToButton = make.right.equalTo(self.rightButton.mas_left).offset(-9);
            
            self.constraintTextFieldLeftToSuper = make.left.equalTo(self.contentView).offset(16);
            self.constraintTextFieldLeftWithIcon = make.left.equalTo(self.contentView).offset(94/2.0);
            make.top.bottom.equalTo(self.contentView);
            
        }];
        
        
        [self setHideRighButton];
        [self setHideLeftIcon];
        //空间充足时, 拉伸 inputTextField
        [self.iconImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.inputTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.rightButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        
        [self.rightButton.imageView addObserver:self
                                      forKeyPath:@"image"
                                         options:NSKeyValueObservingOptionNew
                                         context:NULL];

        [self.rightButton.titleLabel addObserver:self
                                     forKeyPath:@"text"
                                        options:NSKeyValueObservingOptionNew
                                        context:NULL];
        
        [self.iconImageView addObserver:self
                             forKeyPath:@"image"
                                options:NSKeyValueObservingOptionNew
                                context:NULL];
    }
    
    return self;
}


- (void)dealloc
{
    [self.rightButton.imageView removeObserver:self forKeyPath:@"image"];
    [self.rightButton.titleLabel removeObserver:self forKeyPath:@"text"];
    [self.iconImageView removeObserver:self forKeyPath:@"image"];
    [self stopTimer];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (object == self.rightButton || object == self.rightButton.titleLabel) {
        // button 的 title 或者 image 有值时, 都不隐藏 button
        if ([keyPath isEqualToString:@"image"]) {
            UIImage *image = change[@"new"];
            if (image) {
                [self setShowRighButton];
            } else {
                [self setHideRighButton];
            }
        }
        
        if ([keyPath isEqualToString:@"text"]) {
            NSString *title = change[@"new"];
            if ([title length] > 0) {
                [self setShowRighButton];
            } else {
                [self setHideRighButton];
            }
        }
    }
    
    if (object == self.iconImageView) {
        if ([keyPath isEqualToString:@"image"]) {
            UIImage *image = change[@"new"];
            if (image) {
                [self setShowLeftIcon];
            } else {
                [self setHideLeftIcon];
            }
        }
    }
   
}

- (void)setHideRighButton
{
    [self.constraintTextFieldRightToButton deactivate];
    [self.constraintTextFieldRightToSuper activate];
    
    [self.constraintHidetRightButton activate];
}


- (void)setShowRighButton
{
    [self.constraintTextFieldRightToButton activate];
    [self.constraintTextFieldRightToSuper deactivate];
    
    [self.constraintHidetRightButton deactivate];
}

- (void)setHideLeftIcon {
    [self.constraintTextFieldLeftWithIcon deactivate];
    [self.constraintTextFieldLeftToSuper activate];
    
    [self.constraintHideLeftIcon activate];
}

- (void)setShowLeftIcon {
    [self.constraintTextFieldLeftWithIcon activate];
    [self.constraintTextFieldLeftToSuper deactivate];
    
    [self.constraintHideLeftIcon deactivate];
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

- (void)timerDidChange
{
    self.rightButton.enabled = NO;
    NSString *countString = [NSString stringWithFormat:@"%@秒后重发", @(self.count--)];
    [self.rightButton setTitle:countString forState:UIControlStateDisabled];
    if (self.count == 0) {
        self.rightButton.enabled = YES;
        [self stopTimer];
    }
}

- (void)startTimer
{
    if (self.timer) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerDidChange) userInfo:nil repeats:YES];
    self.count = 59;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
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
        _inputTextField = [UITextField new];
        _inputTextField.font = [UIFont systemFontOfSize:15];
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        _inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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




@end
