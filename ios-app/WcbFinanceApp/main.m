//
//  main.m
//  licai
//
//  Created by wac on 14-5-9.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
#if DEBUG
//    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
//    [[FBAllocationTrackerManager sharedManager] enableGenerations];
#endif
    
    @autoreleasepool {
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
