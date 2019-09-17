//
//  FSStatusBar.m
//  FinanceApp
//
//  Created by 叶帆 on 1/28/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSStatusBar.h"

@interface FSStatusBar ()

@property (strong, nonatomic)UILabel *contentLabel;

@end


@implementation FSStatusBar

+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat barWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat barHeight = 20;
        sharedInstance = [[self alloc] initWithFrame:CGRectMake(0, 0, barWidth, barHeight)];
    });
    return sharedInstance;
}

- (void)showWithContent:(NSString *)string{
    self.contentLabel.text = string;
    [self show];
}

- (void)show{
    self.windowLevel = UIWindowLevelStatusBar;
    [self makeKeyWindow];
    self.hidden = NO;
}

- (void)hide{
    [self resignKeyWindow];
    self.hidden = YES;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        CGFloat barWidth = self.frame.size.width;
        CGFloat barHeight = self.frame.size.height;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, barWidth, barHeight)];
        _contentLabel.backgroundColor = [UIColor blackColor];
        _contentLabel.textColor = [UIColor whiteColor];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}


@end
