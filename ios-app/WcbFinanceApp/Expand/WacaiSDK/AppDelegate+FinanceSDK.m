//
//  AppDelegate+FinanceSDK.m
//  FinanceApp
//
//  Created by xingyong on 14/02/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "AppDelegate+FinanceSDK.h"
#import "EnvironmentInfo.h"
#import <SdkFinanceAsset/SdkFinanceAsset.h>
#import <SdkFinanceShelf/SdkFinanceShelf.h>
#import <SdkFinanceHome/SdkFinanceHome.h>

@implementation AppDelegate (FinanceSDK)

- (void)initFinanceSDK{
     
    if ([[EnvironmentInfo sharedInstance] currentEnvironment] == FSEnvironmentTypeOnline) {
        [[SdkFinanceAsset sharedInstance] setServerEnvironmentType:FSEnvironmentRelease];
        [[SdkFinanceShelf sharedInstance] setServerEnvironmentType:FSEnvironmentRelease];
        [[SdkFinanceHome sharedInstance] setServerEnvironmentType:FSEnvironmentRelease];

    } else if([[EnvironmentInfo sharedInstance] currentEnvironment] == FSEnvironmentTypeTest1){
        [[SdkFinanceAsset sharedInstance] setServerEnvironmentType:FSEnvironmentDevelop];
        [[SdkFinanceShelf sharedInstance] setServerEnvironmentType:FSEnvironmentDevelop];
        [[SdkFinanceHome sharedInstance] setServerEnvironmentType:FSEnvironmentDevelop];

    } else if([[EnvironmentInfo sharedInstance] currentEnvironment] == FSEnvironmentTypeTest2){
        [[SdkFinanceAsset sharedInstance] setServerEnvironmentType:FSEnvironmentDevelop2];
        [[SdkFinanceShelf sharedInstance] setServerEnvironmentType:FSEnvironmentDevelop2];
        [[SdkFinanceHome sharedInstance] setServerEnvironmentType:FSEnvironmentDevelop2];

    } else if([[EnvironmentInfo sharedInstance] currentEnvironment] == FSEnvironmentTypePreRelease){
        [[SdkFinanceAsset sharedInstance] setServerEnvironmentType:FSEnvironmentPre];
        [[SdkFinanceShelf sharedInstance] setServerEnvironmentType:FSEnvironmentPre];
        [[SdkFinanceHome sharedInstance] setServerEnvironmentType:FSEnvironmentPre];
        
    } else {
        //TODO 此处应该为开发环境，理财 SDK 暂未支持
    }
    
}

@end
