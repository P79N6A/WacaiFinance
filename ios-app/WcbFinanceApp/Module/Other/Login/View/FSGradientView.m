//
//  FSGradientView.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/21.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSGradientView.h"

@interface FSGradientView()

@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;
@property CGPoint startPoint;
@property CGPoint endPoint;

@end

@implementation FSGradientView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    
    self.colors = [colorsM copy];
    self.locations = locations;
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    
    [layer setColors:self.colors];
    [layer setLocations:locations];
    [layer setStartPoint:startPoint];
    [layer setEndPoint:endPoint];
}


@end
