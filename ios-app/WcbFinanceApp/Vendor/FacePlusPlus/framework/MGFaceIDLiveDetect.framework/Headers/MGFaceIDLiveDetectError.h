//
//  MGFaceIDLiveDetectError.h
//  MGFaceIDLiveDetect
//
//  Created by MegviiDev on 2018/6/21.
//  Copyright © 2018年 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGFaceIDLiveDetectConfig.h"

@interface MGFaceIDLiveDetectError : NSObject

/**
 错误类型，详情查看enum-MGFaceIDLiveDetectErrorType
 如果errorType为MGFaceIDLiveDetectErrorNone，则表示没有错误
 */
@property (nonatomic, assign) MGFaceIDLiveDetectErrorType errorType;

/**
 错误信息
 */
@property (nonatomic, assign) NSString* errorMessageStr;

@end
