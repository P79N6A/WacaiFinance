//
//  FSGuideManager.h
//  FinanceApp
//
//  Created by xingyong on 22/12/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, FSGuideViewType) {
    FSGuideViewTypeHome,
    FSGuideViewTypeAsset
};
@interface FSGuideManager : NSObject

+ (void)showGuideView:(FSGuideViewType)type;

@end
