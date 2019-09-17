//
//  FSAgreementView.h
//  Financeapp
//
//  Created by xingyong on 16/10/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSAgreementInfo;
typedef void (^FSCheckBlock)(BOOL status);

@interface FSAgreementView : UIView

@property (nonatomic, strong, readonly) UIButton *checkBtn;
@property (nonatomic, copy) FSCheckBlock checkBlock;
@property (nonatomic, assign) BOOL accepted;

- (instancetype)initWithFrame:(CGRect)frame
                   agreements:(FSAgreementInfo *)agreements;

- (void)updateViewWithAgreements:(FSAgreementInfo *)agreements;

- (CGFloat)contentHeight;
 

@end
