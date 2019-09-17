//
//  FSDiscoveryNavView.h
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSDiscoveryNavViewDelegate <NSObject>

@optional
- (void)navViewSettingBtnTap:(UIButton *)btn;

@end

@interface FSDiscoveryNavView : UIView

@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, weak) id<FSDiscoveryNavViewDelegate>delegate;

@end
