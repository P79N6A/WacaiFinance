//
//  FSLoginLoadingHandler.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/6/8.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLoginLoadingHandler.h"

@interface FSLoginLoadingHandler()

@property (nonatomic, strong) UIActivityIndicatorView *mActivityView;
@property (nonatomic, strong) UIView *mCoverView;

@end

@implementation FSLoginLoadingHandler

- (void)addLoadingWithParentView:(UIView *)parentView activityView:(UIView *)activityView {
    if ([activityView isKindOfClass:[UIButton class]]) {
        UIButton *activityBtn = (UIButton *)activityView;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [activityBtn setTitle:@"" forState:UIControlStateNormal];
        [activityBtn addSubview:indicatorView];
        indicatorView.color = [UIColor whiteColor];
        indicatorView.center = CGPointMake(activityBtn.frame.size.width / 2, activityBtn.frame.size.height / 2);
        [indicatorView startAnimating];
        self.mActivityView = indicatorView;
    }
    
    UIControl *coverView = [[UIControl alloc] initWithFrame:parentView.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [parentView addSubview:coverView];
    self.mCoverView = coverView;
    
}

- (void)removeLoadingWithCompletion:(void(^)(void))completion {
    if (self.mCoverView) {
        [self.mCoverView removeFromSuperview];
        self.mCoverView = nil;
    }
    
    if (self.mActivityView) {
        [self.mActivityView stopAnimating];
        [self.mActivityView removeFromSuperview];
        self.mActivityView = nil;
    }
    
    if (completion) {
        completion();
    }
}

@end
