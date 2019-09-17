//
//  MGCameraDelegate.h
//  MGFaceIDGeneralModule
//
//  Created by MegviiDev on 2018/5/18.
//  Copyright © 2018年 Megvii. All rights reserved.
//

#ifndef MGCameraDelegate_h
#define MGCameraDelegate_h
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    MGCameraErrorNOPermission        = 100,
    MGCameraErrorNOSessionPreset,
    MGCameraErrorNODevice,
} MGCameraErrorType;

@protocol MGCameraDelegate <NSObject>

@required
//  Output Video
- (void)mgCaptureOutput:(AVCaptureOutput *)captureOutput
  didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
         fromConnection:(AVCaptureConnection *)connection;

@optional
//  Output Audio
- (void)mgCaptureOutput:(AVCaptureOutput *)captureOutput
   didAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer
         fromConnection:(AVCaptureConnection *)connection;

- (void)mgCaptureOutput:(AVCaptureOutput *)captureOutput error:(MGCameraErrorType)error;

- (void)mgCaptureFinishVideoRecord:(NSString *)videoFilePathStr;

- (void)mgCaptureFailedVideoRecord;

@end

#endif /* MGCameraDelegate_h */
