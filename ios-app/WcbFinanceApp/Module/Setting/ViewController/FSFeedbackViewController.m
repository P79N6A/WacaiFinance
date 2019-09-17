//
//  FInFeedBackViewController.m
//  FinanceSDK
//
//  Created by Alex on 7/26/15.
//  Copyright (c) 2015 com.wac.finance. All rights reserved.
//

#import "FSFeedbackViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIImage+FSUtils.h"
#import "UserActionStatistics.h"
#import "UIViewController+FSUtil.h"
#import "EnvironmentInfo.h"
#import <CMNetworking/CMNetworking.h>
#import "CMUIDisappearView.h"
#import "CMApp.h"
#import "CMDevice.h"
#import "FSFeedbackRequest.h"

#define isEmpty(string) (!string || string.length == 0 || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)


@interface FSFeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *feedBackContentTextView;
@property (nonatomic, strong) UITextField *contactTextField;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *wordCountLabel;



@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation FSFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助与反馈";
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([CMDevice sharedInstance].navigationBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    
    [self generateScrollViewContent];
}

- (void)generateScrollViewContent
{
    UIView *contentView = [UIView new];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [contentView addSubview:self.feedBackContentTextView];
    [self.feedBackContentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@(92/2.0));
        
        make.height.equalTo(@(352/2));
    }];
    
    [contentView addSubview:self.wordCountLabel];
    [self.wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.feedBackContentTextView.mas_right).offset(-16);
        make.bottom.equalTo(self.feedBackContentTextView.mas_bottom).offset(-10);
    }];
    
    [contentView addSubview:self.contactTextField];
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(self.feedBackContentTextView.mas_bottom).offset(92/2);
        
        make.height.equalTo(@(116/2));
    }];
    
    
    [contentView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(16);
        make.top.equalTo(self.contactTextField.mas_bottom).offset(16);
        make.right.equalTo(contentView).offset(-16);
        
        make.height.equalTo(@(96/2.0));
    }];
    
    
    
    UILabel *labelOne = [UILabel new];
    labelOne.text = @"感谢您对挖财宝的支持, 我们期待您的宝贵意见";
    labelOne.font = [UIFont systemFontOfSize:12];
    labelOne.textColor = HEXCOLOR(0x444546);
    labelOne.backgroundColor = [UIColor clearColor];
    [contentView addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.bottom.equalTo(self.feedBackContentTextView.mas_top).offset(-10);
    }];
    
    UILabel *labelTwo = [UILabel new];
    labelTwo.text = @"联系方式";
    labelTwo.font = [UIFont systemFontOfSize:12];
    labelTwo.textColor = HEXCOLOR(0x444546);
    labelTwo.backgroundColor = [UIColor clearColor];
    [contentView addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.bottom.equalTo(self.contactTextField.mas_top).offset(-10);
    }];
    
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.submitButton);
    }];
    
}


#pragma UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 500) {
        textView.text = [textView.text substringToIndex:500];
        self.wordCountLabel.text = @"剩余0字";
        return;
    }
    
    self.wordCountLabel.text = [NSString stringWithFormat:@"剩余%@字", @(500-[textView.text length])];

    //随着文字输入使输入框随之滚动以免输入文字盖住剩余字数提示
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    contentInset.bottom = 30;
    textView.contentInset = contentInset;
}

#pragma mark - Event
- (void)startFeedbackRequestWithContent:(NSString *)content email:(NSString *)email {
    
    FSFeedbackRequest *request = [[FSFeedbackRequest alloc] initWithContent:content email:email];
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        NSDictionary *responseDic = request.responseJSONObject;
        NSInteger code = [responseDic CM_intForKey:@"code"];
        if (code == 0) {
            NSDictionary *data = [responseDic CM_dictionaryForKey:@"data"];
            NSString *message = [data CM_stringForKey:@"desc"];
            [CMUIDisappearView showMessage:message];
            [self onBackAction:nil];
        } else {
            NSString *message = [responseDic CM_stringForKey:@"error"];
            [CMUIDisappearView showMessage:message];
        }
        
    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        [CMUIDisappearView showMessage:@"服务器异常，请稍后再试"];
    }];
    
}

- (void)submitButtonDidPress:(id)sender
{
 
    NSString *content = self.feedBackContentTextView.text;
    NSString *email = self.contactTextField.text;
    
    NSString *errorTips = [self checkErrorTipsOfContent:content email:email];
    BOOL isSubmitInfoValid = !([errorTips length] > 0);
    
    if (isSubmitInfoValid) {
        [self startFeedbackRequestWithContent:content email:email];
    } else {
        [CMUIDisappearView showMessage:errorTips];
    }
}

- (NSString *)checkErrorTipsOfContent:(NSString *)content email:(NSString *)email {
    NSString *errorString = [NSString string];
    if (isEmpty(email) && isEmpty(content)) {
        errorString = NSLocalizedString(@"error_email_content_empty", nil);
    }else if (isEmpty(email)) {
        errorString = NSLocalizedString(@"error_email_empty", nil);
    }else if (![email CM_isValidEmail]) {
        errorString = NSLocalizedString(@"error_email_invalid", nil);
    }else if (isEmpty(content)) {
        errorString = NSLocalizedString(@"error_content_empty", nil);
    }
    return errorString;
}


- (void)onBackAction:(id)sender {
    if ([self fs_isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Getter and Setter
- (TPKeyboardAvoidingScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [TPKeyboardAvoidingScrollView new];
    }
    
    return _scrollView;

}

- (UITextView *)feedBackContentTextView
{
    if (!_feedBackContentTextView) {
        _feedBackContentTextView = [UITextView new];
        _feedBackContentTextView.font = [UIFont systemFontOfSize:15];
        _feedBackContentTextView.delegate = self;

    }
    
    return _feedBackContentTextView;
}

- (UITextField *)contactTextField
{
    if (!_contactTextField) {
        _contactTextField = [UITextField new];
        _contactTextField.backgroundColor = [UIColor whiteColor];
        _contactTextField.placeholder = @"请输入您的邮箱地址";
        _contactTextField.text = [UserInfo sharedInstance].mUserEmail ?: @"";
        _contactTextField.font = [UIFont systemFontOfSize:15];
        UIView *paddingTxtfieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 92/2)];// what ever you want
        _contactTextField.leftView = paddingTxtfieldView;
        _contactTextField.rightView = paddingTxtfieldView;
        _contactTextField.leftViewMode = UITextFieldViewModeAlways;
        _contactTextField.rightViewMode = UITextFieldViewModeAlways;

    }
    
    return _contactTextField;
}


- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _submitButton.layer.cornerRadius = 3;
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD95149)] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xB8453F)] forState:UIControlStateHighlighted];
        [_submitButton setBackgroundImage:[UIImage fs_imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_submitButton addTarget:self action:@selector(submitButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
}

- (UILabel *)wordCountLabel
{
    if (!_wordCountLabel) {
        _wordCountLabel = [UILabel new];
        _wordCountLabel.backgroundColor = [UIColor clearColor];
        _wordCountLabel.font = [UIFont systemFontOfSize:14];
        _wordCountLabel.textColor = [UIColor lightGrayColor];
        _wordCountLabel.text = @"剩余500字";
    }
    
    return _wordCountLabel;
}

@end
