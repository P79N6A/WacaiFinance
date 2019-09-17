//
//  FSBasePopupView.h
//  FinanceApp
//
//  Created by xingyong on 09/11/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSBasePopupView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                       action:(void (^)(UIButton *button)) block;

@property(nonatomic,strong) UIImage *popupImage;
//@property(nonatomic,copy) NSString *linkUrl;
@end
