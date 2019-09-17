//
//  FSLaunchSplashManager+FSUtils.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/4/9.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLaunchSplashManager+FSUtils.h"
#import <CMNSArray/CMNSArray.h>

@implementation FSLaunchSplashManager (FSUtils)

//根据屏幕尺寸 获取比例最接近的网络图片链接
- (NSString *)getImageUrl:(NSArray<NSString *> *)imageUrls {
    
    if (![imageUrls CM_isValidArray]) {
        return @"";
    }
    
    __block NSString *suitableURL = @"";
    __block CGFloat minRatioDelta = CGFLOAT_MAX;
    [imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull imgUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGSize imageSize = [self imageSize:imgUrl];
        CGFloat imageRatio = imageSize.height / imageSize.width;
        CGFloat screenRatio = [self screenRatio];
        
        CGFloat ratioDelta = fabs(imageRatio - screenRatio);

        if (ratioDelta < minRatioDelta) {
            minRatioDelta = ratioDelta;
            suitableURL = imgUrl;
        }
        
    }];
    
    return suitableURL;
}

- (CGSize)imageSize:(NSString *)imageURL {
    
    if (![imageURL CM_isValidString]) {
        return CGSizeZero;
    }
    
    // URL 格式为历史约定已不可考，按 “_”, “x” 和 "." 进行分割
    // e.g. https://s1.wacdn.com/wis/527/d2ef1f621fc19ba5_1242x2208.png
    NSRange underlineRange = [imageURL rangeOfString:@"_" options:NSBackwardsSearch];
    NSRange multiplicationRange = [imageURL rangeOfString:@"x" options:NSBackwardsSearch];
    NSRange pointRange = [imageURL rangeOfString:@"." options:NSBackwardsSearch];
    if ((underlineRange.location == NSNotFound) ||
        (multiplicationRange.location == NSNotFound) ||
        (pointRange.location == NSNotFound)) {
        return CGSizeZero;
    }
    
    NSInteger widthLength = multiplicationRange.location - underlineRange.location - underlineRange.length;
    NSInteger heightLength = pointRange.location - multiplicationRange.location - multiplicationRange.length;
    
    if ((widthLength <= 0) || (heightLength <= 0)) {
        return CGSizeZero;
    }
    
    NSRange widthRange = NSMakeRange(underlineRange.location + underlineRange.length, widthLength);
    NSRange heightRange = NSMakeRange(multiplicationRange.location + multiplicationRange.length, heightLength);
    
    NSString *widthString = [imageURL substringWithRange:widthRange];
    NSString *heightString = [imageURL substringWithRange:heightRange];
    
    CGFloat width = [widthString floatValue];
    CGFloat height = [heightString floatValue];
    
    if ((width <= 0) || (height <=0)) {
        return CGSizeZero;
    }
    
    return CGSizeMake(width, height);
}

- (CGFloat)screenRatio {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat ratio = screenSize.height / screenSize.width;
    return ratio;
}

@end
