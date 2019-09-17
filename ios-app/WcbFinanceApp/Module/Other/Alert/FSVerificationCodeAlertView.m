//
//  FSVerificationCodeAlertView.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/1/24.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSVerificationCodeAlertView.h"
#import "UIView+FSUtils.h"
#import <CMLayout/CMLayout.h>
#import <SdkUser/LRRequestFactory.h>
#import <UIButton+WebCache.h>
#import <CMDevice/CMDevice.h>

@interface FSVerificationCodeAlertView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton    *imageButton;

@property (nonatomic, strong) UIView *inputBackGroundView;
@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation FSVerificationCodeAlertView

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setButtonTitles:nil];
        
        CGFloat width = 275, height = 222;
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.containerView.backgroundColor = [UIColor clearColor];
        
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setImage:[UIImage imageNamed:@"alert_close"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(onCloseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.containerView addSubview:self.closeBtn];
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"当前操作频繁，请输入图形验证码";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithHexString:@"333333"];
            label.font = [UIFont systemFontOfSize:15.0];
            
            label;
        });
        [self.containerView addSubview:self.titleLabel];
        
        self.inputBackGroundView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.layer.borderColor = [UIColor colorWithHexString:@"ECECEC"].CGColor;
            view.layer.borderWidth = 0.5;
            view.layer.cornerRadius = 0.5;
            view;
        });
        
        [self.containerView addSubview:self.inputBackGroundView];
        
        self.inputTextField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.placeholder = @"输入图形验证码";
            textField.font = [UIFont systemFontOfSize:13.0];

            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.spellCheckingType = UITextSpellCheckingTypeNo;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            textField.delegate = self;
            
            
            textField;
        });
        
        [self.containerView addSubview:self.inputTextField];
        

        self.imageButton = ({
           
            UIButton *btn = [[UIButton alloc] init];
            [btn addTarget:self action:@selector(refreshVercode:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        [self.containerView addSubview:self.imageButton];
        
        self.lineView = ({
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
            view;
        });
        
        [self.containerView addSubview:self.lineView];
        
        self.confirmBtn = ({
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"确定" forState:UIControlStateNormal];

            [btn setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [btn addTarget:self action:@selector(onConfirmBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
        
        [self.containerView addSubview:self.confirmBtn];
        
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if([UIScreen mainScreen].bounds.size.height == iPhone4ScreenSize.height)
    {
        self.dialogView.top = 20;
    }
    else if([UIScreen mainScreen].bounds.size.height == iPhone5ScreenSize.height)
    {
        self.dialogView.top = 64;
    }
    
    [CMLayout layout:self.closeBtn block:^(CMLayout *layout) {
       
        layout.left = self.containerView.width - 8 - 25;
        layout.top = 8;
        layout.height = 25;
        layout.width = 25;
        
    }];
    
    self.titleLabel.frame = CGRectMake(22, 43, self.containerView.width - 44, 21);
    
    [CMLayout layout:self.inputBackGroundView block:^(CMLayout *layout) {
       
        layout.top = self.titleLabel.bottom + 32;
        layout.left = 20;
        layout.width = 150;
        layout.height = 40;
    }];
    
    [CMLayout layout:self.inputTextField block:^(CMLayout *layout) {
       
        layout.top = self.titleLabel.bottom + 42;
        layout.left = 30;
        layout.width = 130;
        layout.height = 20;
    }];
    
    [CMLayout layout:self.imageButton block:^(CMLayout *layout) {
       
        layout.top = self.titleLabel.bottom + 32;
        layout.left = self.inputBackGroundView.right + 10;
        layout.width = 75;
        layout.height = 40;
    }];
    
    [CMLayout layout:self.lineView block:^(CMLayout *layout) {
        
        layout.height = 1;
        layout.top = self.imageButton.bottom + 32;
        layout.left = 0;
        layout.width = self.containerView.width;
    }];
    
    [CMLayout layout:self.confirmBtn block:^(CMLayout *layout) {
       
        layout.height = 50;
        layout.top = self.lineView.bottom;
        layout.left = 0;
        layout.width =  self.containerView.width;
    }];
}

- (NSString *)imageVercode {
    return self.inputTextField.text;
}

- (void)show
{
    [self refreshVercode:nil];
    [super show];
    [self.inputTextField becomeFirstResponder];
}

- (void)onCloseBtnTapped:(id)sender
{
    [self close];
}


- (void)refreshVercode:(id)sender
{
    self.inputTextField.text = @"";
    
    NSURL *vercodeImageURL = [LRRequestFactory verificationCodeURLWithTips:self.tips];
    
    [self.imageButton sd_setImageWithURL:vercodeImageURL
                        forState:UIControlStateNormal
                placeholderImage:[UIImage imageNamed:@"verifyCode_loading"]
                         options:SDWebImageRefreshCached | SDWebImageAvoidAutoSetImage | SDWebImageRetryFailed
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           
                           if (error) {
                               [self.imageButton setImage:[UIImage imageNamed:@"verifyCode_error"] forState:UIControlStateNormal];
                           } else if (cacheType != SDImageCacheTypeNone) {
                               [self.imageButton setImage:[UIImage imageNamed:@"verifyCode_loading"] forState:UIControlStateNormal];
                           } else {
                               [self.imageButton setImage:image forState:UIControlStateNormal];
                           }
                       }];
}

- (void)onConfirmBtnTapped:(id)sender
{
    if(self.inputTextField.text.length <= 0)
    {
        [CMUIDisappearView showMessage:@"请输入图形验证码"];
        return;
    }
    
    if(self.onButtonTouchUpInside)
    {
        self.onButtonTouchUpInside(self, 1);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 4;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
