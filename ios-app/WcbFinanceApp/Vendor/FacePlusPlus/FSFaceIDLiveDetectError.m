//
//  FSFaceIDLiveDetectError.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/3.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSFaceIDLiveDetectError.h"

@implementation FSFaceIDLiveDetectError

+ (instancetype)errorWithType:(NSUInteger)type message:(NSString *)message {
    return [[self alloc] initWithType:type message:message];
}

- (instancetype)initWithType:(NSUInteger)type message:(NSString *)message {
    self = [super init];
    if (self) {
        self.errorType = type;
        self.errorMessageStr = message;
    }
    return self;
}

@end
