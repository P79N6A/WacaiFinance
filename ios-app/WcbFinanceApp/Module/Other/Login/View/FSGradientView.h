//
//  FSGradientView.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/21.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSGradientView : UIView

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors
                              locations:(NSArray<NSNumber *> *)locations
                             startPoint:(CGPoint)startPoint
                               endPoint:(CGPoint)endPoint;

@end
