//
//  MGFaceIDCameraManager.h
//  MGFaceIDBaseKit
//
//  Created by MegviiDev on 2019/1/29.
//  Copyright © 2019 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MGCameraDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDCameraManager : NSObject

@property (nonatomic, weak) id <MGCameraDelegate> delegate;
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

+ (instancetype)videoPreset:(NSString *)sessionPreset
             devicePosition:(AVCaptureDevicePosition)devicePosition
                videoRecord:(BOOL)isRecordVideo
                 videoSound:(BOOL)isRecordAudio;

/**
 视频流的预览layer

 @return 视频流预览图
 */
- (AVCaptureVideoPreviewLayer *)videoPreview;

/**
 开启摄像机
 */
- (void)startRunning;

/**
 关闭摄像机
 */
- (void)stopRunning;

/**
 开始录像
 */
- (void)startRecording;

/**
 停止录像
 */
- (void)stopRceording;

/**
 重置录像，丢弃之前已录制文件
 */
- (void)resetRceording;

/**
 自定义录像视频文件名称

 @param videoName 文件名称，后缀为`.mov`
 */
- (void)cameraVideoRecordName:(NSString *)videoName;

/**
 自定义录像视频帧率。该参数为近似值，录制的视频帧率可能和设置的FPS有差异。

 @param videoFPS 视频帧率，阈值范围[0, 33]，其中0表示使用默认帧率。
 */
- (void)cameraVideoRecordFPS:(NSUInteger)videoFPS;

/**
 自定义录制配置-是否手动添加Buffer数据，默认为NO，不手动添加
 如果配置该参数为YES，需要主动调用`-cameraVideoRecordWithSampleBuffer:connection:`接口传入sambuffer数据，SDK不在进行摄像头数据录制操作。

 @param isManualInput 是否手动添加
 */
- (void)cameraVideoRecordManualInput:(BOOL)isManualInput;

/**
 录制视频过程中手动添加Buffer数据。手动添加数据可能导致FPS低于期望值

 @param sampleBuffer Buffer数据
 @param connection 连接器信息
 */
- (void)cameraVideoRecordWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                               connection:(AVCaptureConnection *)connection;

/**
 获取SDK版本信息

 @return SDK版本号
 */
+ (NSString *)getSDKVersion;

@end

NS_ASSUME_NONNULL_END
