//
//  FSStatusBar.h
//  FinanceApp
//
//  Created by 叶帆 on 1/28/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSStatusBar : UIWindow

+ (instancetype)sharedInstance;

- (void)showWithContent:(NSString *)string;

- (void)hide;


@end
