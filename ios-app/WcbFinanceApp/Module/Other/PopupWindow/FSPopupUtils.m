//
//  FSPopupUtils.m
//  FinanceApp
//
//  Created by xingyong on 09/11/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSPopupUtils.h"
#import "SDWebImageManager.h"
#import "FSBasePopupView.h"
#import "KLCPopup.h"
#import "FSTabbarController.h"
#import "AppDelegate.h"
#import "FSGestureLockViewController.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>
@implementation FSPopupUtils

static FSPopupUtils *_popupInstance = nil;

+ (FSPopupUtils *)sharedInstance {
    
    if (self != [FSPopupUtils class]) {
        
        [NSException raise:@"SingletonPattern"
                    format:@"Cannot use sharedInstance method from subclass."];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _popupInstance = [[FSPopupUtils alloc] initInstance];
    });
    
    return _popupInstance;
}
#pragma mark - private method

- (id)initInstance {
    
    return [super init];
}
- (instancetype)init {
    
    [NSException raise:@"SingletonPattern"
                format:@"Cannot instantiate singleton using init method, sharedInstance must be used."];
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    
    [NSException raise:@"SingletonPattern"
                format:@"Cannot copy singleton using copy method, sharedInstance must be used."];
    
    return nil;
}

- (void)showImageUrl:(NSString *)imageUrl
             linkUrl:(NSString *)linkUrl
             eventId:(NSString *)eventId
{
    [self showImageUrl:imageUrl linkUrl:linkUrl eventId:eventId clickBlock:nil closeBlock:nil];
}

- (void)showImageUrl:(NSString *)imageUrl
             linkUrl:(NSString *)linkUrl
             eventId:(NSString *)eventId
          clickBlock:(void(^ _Nullable)())clickBlock
          closeBlock:(void(^ _Nullable)())closeBlock
{
 
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl]
                                                    options:SDWebImageLowPriority
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       
                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       if (image) {
                                                           [self popupImage:image
                                                                    linkUrl:linkUrl
                                                                    eventId:eventId
                                                                 clickBlock:clickBlock
                                                                 closeBlock:closeBlock];
                                                       }
                                                   }];

}

 



- (void)popupImage:(UIImage *)image
           linkUrl:(NSString *)linkUrl
           eventId:(NSString *)eventId
        clickBlock:(void(^ _Nullable)())clickBlock
        closeBlock:(void(^ _Nullable)())closeBlock
{
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*5/6, [UIScreen mainScreen].bounds.size.width + 150.);
    
    __weak typeof(self) weakSelf = self;
    FSBasePopupView *popuView = [[FSBasePopupView alloc]
                                 initWithFrame:rect
                                        action:^(UIButton *button) {
                                            [weakSelf handleButtonAction:button
                                                                 linkUrl:linkUrl
                                                                 eventId:eventId
                                                              clickBlock:clickBlock
                                                              closeBlock:closeBlock];
                                            }];
    
    popuView.popupImage = image;
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:popuView
                                            showType:KLCPopupShowTypeSlideInFromTop
                                         dismissType:KLCPopupDismissTypeSlideOutToBottom
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    popup.dimmedMaskAlpha = 0.7;

    [popup showWithLayout:layout];

}

- (void)handleButtonAction:(UIButton *)button
                   linkUrl:(NSString *)linkUrl
                   eventId:(NSString *)eventId
                clickBlock:(void(^ _Nullable)())clickBlock
                closeBlock:(void(^ _Nullable)())closeBlock
{
    [button dismissPresentingPopup];
    if (button.tag == 2) { //关闭
        if (closeBlock) {
            closeBlock();
        }
        
    }
    if (button.tag == 1){//点击图片跳转
        if (clickBlock) {
            clickBlock();
        }
      
        
        [self performSelector:@selector(delayPush:) withObject:linkUrl afterDelay:0.5];
    }
}
-(void)delayPush:(NSString *)linkUrl{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *controllers = appdelegate.fs_navgationController.viewControllers;
    FSTabbarController *tabBarController = (FSTabbarController *)[controllers firstObject];
    [FSSDKGotoUtility openURL:linkUrl from:tabBarController];
}

@end
