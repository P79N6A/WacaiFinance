//
//  FSWelcomeSlidesView.h
//  FinanceApp
//
//  Created by 叶帆 on 17/10/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FSWelcomeSlidesViewDismissBlock)();
@interface FSWelcomeSlidesView : UIView

+ (instancetype)viewWithSlidesNumber:(NSInteger)numberOfSlides dismissBlock:(FSWelcomeSlidesViewDismissBlock)dismissBlock;

@end
