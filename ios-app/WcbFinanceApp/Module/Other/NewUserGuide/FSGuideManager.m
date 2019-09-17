//
//  FSGuideManager.m
//  FinanceApp
//
//  Created by xingyong on 22/12/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSGuideManager.h"
#import "KLCPopup.h"
#import "FSHomeGuideView.h"
#import "FSAssetListGuideView.h"
#import "EnvironmentInfo.h"

static NSString * const kFSAssetListGuide = @"FSAssetListGuideView";
static NSString * const kFSHomeGuide      = @"FSHomeGuideView";

@implementation FSGuideManager

 
+ (void)showGuideView:(FSGuideViewType)type{
 
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    if ([[EnvironmentInfo sharedInstance] isNewlyInstallation]) {
        
        NSString *key = nil;
    
        UIView *guideView = nil;
        
        if (type == FSGuideViewTypeHome) {
            guideView = [[FSHomeGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            key = kFSHomeGuide;

        }else if(type == FSGuideViewTypeAsset){
            
            guideView = [[FSAssetListGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            key = kFSAssetListGuide;
        }
    
        if (![userDefault boolForKey:key]) {
            
            KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutCenter);
            
            KLCPopup* popup = [KLCPopup popupWithContentView:guideView
                                                    showType:KLCPopupShowTypeFadeIn
                                                 dismissType:KLCPopupDismissTypeFadeOut
                                                    maskType:KLCPopupMaskTypeNone
                                    dismissOnBackgroundTouch:NO
                                       dismissOnContentTouch:YES];
            
            [popup showWithLayout:layout];
        }
        
        [userDefault setBool:YES forKey:key];
        
    }else{
        [userDefault setBool:YES forKey:kFSHomeGuide];
        [userDefault setBool:YES forKey:kFSAssetListGuide];

    }
    [userDefault synchronize];

}
@end
