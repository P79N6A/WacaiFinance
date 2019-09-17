//
//  FSWelcomeSlidesViewController.h
//  FinanceApp
//
//  Created by 叶帆 on 27/09/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSWelcomeSlidesViewController : UIViewController

/**
 用于在外部判断是否要展示（该版本不展示／已经展示过）
 
 @return BOOL YES/NO
 */
+ (BOOL)shouldShow;

@end
