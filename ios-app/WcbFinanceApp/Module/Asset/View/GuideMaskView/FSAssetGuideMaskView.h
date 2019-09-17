//
//  FSAssetGuideMaskView.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/16.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAssetGuideMaskView : UIView

- (instancetype)initWithFrame:(CGRect)frame arrowTop:(CGFloat)arrowTop;

- (void)updateClipFrame:(CGRect)clipFrame;

+ (BOOL)maskViewShouldShow;

@end
