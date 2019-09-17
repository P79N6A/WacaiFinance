//
//  FSErrorView.h
//  WcbFinanceApp
//
//  Created by 金镖 on 2018/10/11.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSCommonErrorView : UIView
@property (nonatomic, copy) void(^reloadAction)(void);

@end

NS_ASSUME_NONNULL_END
