//
//  FSFaceIDLiveDetectError.h
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/3.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSFaceIDLiveDetectError : NSObject

/**
 错误类型：实际为 MGFaceIDLiveDetectErrorType 请参考对应定义
 为解耦 Middleware 对 FaceID 的直接依赖，此处转换成自定义错误 code
 */
@property (nonatomic, assign) NSUInteger errorType;

/**
 错误信息：实际为 FaceID SDK 返回的错误消息，请参考对应定义
 为解耦 Middleware 对 FaceID 的直接依赖，此处转换成自定义错误消息
 */
@property (nonatomic, assign) NSString* errorMessageStr;


+ (instancetype)errorWithType:(NSUInteger)type message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
