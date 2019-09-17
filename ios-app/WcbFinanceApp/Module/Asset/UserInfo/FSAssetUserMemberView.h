//
//  FSAssetUserMemberView.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSUserLevelInfo;

@protocol FSAssetUserMemberViewDelegate <NSObject>
@optional
- (void)userMemberViewTap;
@end

@interface FSAssetUserMemberView : UIView

@property (nonatomic, strong) UIImageView *levelIconView;
@property (nonatomic, strong) UILabel *levelLabel;

@property (nonatomic, weak) id<FSAssetUserMemberViewDelegate>delegate;

- (void)updateUserLevelView:(FSUserLevelInfo *)levelInfo;

- (CGFloat)viewHeight;
- (CGFloat)widthForLevelInfo:(FSUserLevelInfo *)levelInfo;

@end
