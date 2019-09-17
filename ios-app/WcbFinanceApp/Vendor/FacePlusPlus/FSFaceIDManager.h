//
//  FSFaceIDManager.h
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/1.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSFaceIDLiveDetectError.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FSFaceIDLiveDetectResultBlock)(FSFaceIDLiveDetectError *error, NSString *resultString);

@interface FSFaceIDManager : NSObject

+ (void)startDetectWithBizToken:(nonnull NSString *)bizToken
                     controller:(UIViewController *)controller
                       callback:(FSFaceIDLiveDetectResultBlock)callback;

@end

NS_ASSUME_NONNULL_END
