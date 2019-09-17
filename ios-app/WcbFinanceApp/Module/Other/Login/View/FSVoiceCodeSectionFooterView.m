//
//  FSVoiceCodeSectionFooterView.m
//  FinanceApp
//
//  Created by Alex on 12/2/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "FSVoiceCodeSectionFooterView.h"

@interface FSVoiceCodeSectionFooterView ()

@property (nonatomic, strong) UIButton *voiceCodeButton;

@end

@implementation FSVoiceCodeSectionFooterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.voiceCodeButton];
        CGSize buttonLabelSize = [self.voiceCodeButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.voiceCodeButton.titleLabel.font}];
        

        [self.voiceCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.centerY.equalTo(@0);
            
            make.height.equalTo(@22);
            make.width.equalTo(@(buttonLabelSize.width + buttonLabelSize.height));
            
        }];
        
        UILabel *describeLabel = [UILabel new];
        describeLabel.text = @"收不到短信验证码?";
        describeLabel.font = [UIFont systemFontOfSize:12];
        describeLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:describeLabel];
        [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.voiceCodeButton.mas_left).offset(-5);
            make.baseline.equalTo(self.voiceCodeButton);
        }];
    }
    
    return self;
}

//- (void)buttonDidTouchDown:(id)sender
//{
//    UIButton *button = sender;
//    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//}

- (void)buttonDidpress:(id)sender
{
//    UIButton *button = sender;
//    button.layer.borderColor = [HEXCOLOR(0x0d9cff) CGColor];
    
    if (self.buttonActonBlock) {
        self.buttonActonBlock();
    }
}


- (void)setVoiceButtonEnable:(BOOL)enable
{
    self.voiceCodeButton.enabled = enable;
    if (enable) {
        self.voiceCodeButton.layer.borderColor = [HEXCOLOR(0x0d9cff) CGColor];
    } else {
        self.voiceCodeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
}


- (UIButton *)voiceCodeButton
{
    if (!_voiceCodeButton) {
        _voiceCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 22)];
        //        [voiceCodeButton addTarget:self action:@selector(buttonDidTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_voiceCodeButton addTarget:self action:@selector(buttonDidpress:) forControlEvents:UIControlEventTouchUpInside];
        _voiceCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _voiceCodeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_voiceCodeButton setTitle:@"语音验证" forState:UIControlStateNormal];
        [_voiceCodeButton setTitleColor:HEXCOLOR(0x0d9cff) forState:UIControlStateNormal];
        [_voiceCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _voiceCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _voiceCodeButton.layer.cornerRadius = CGRectGetHeight(_voiceCodeButton.frame)/2;
        _voiceCodeButton.layer.borderWidth = 1;
        _voiceCodeButton.layer.borderColor = [HEXCOLOR(0x0d9cff) CGColor];
    }
    
    return _voiceCodeButton;
}

@end
