//
//  FSiRateDelegate.m
//  FinanceApp
//
//  Created by Alex on 1/14/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSiRateDelegate.h"
#import "AppDelegate.h"
#import "FSFeedbackViewController.h"

#define FIN_APP	((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define SECONDS_IN_A_DAY 86400.0


static NSString *const kFSRateDeclineTimes = @"FSRateDeclineTimes";
static NSString *const kFSRateLastDeclineDate = @"FSRateLastDeclineDate";


@implementation FSiRateDelegate


+ (FSiRateDelegate*)shareInstance {
    
    static dispatch_once_t onceToken;
    static FSiRateDelegate *iRateDelegate;
    dispatch_once(&onceToken, ^{
        iRateDelegate  = [[FSiRateDelegate alloc] init];

    });
    return iRateDelegate;
}


#pragma mark - iRateDelegate
//点击我要吐槽 其实是 decline

- (void)iRateUserDidRequestReminderToRateApp
{
    [CustomiRate sharedInstance].declinedThisVersion = YES;
    FSFeedbackViewController *feedbackViewController = [FSFeedbackViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.fs_navgationController presentViewController:nav animated:YES completion:nil];
}
                                   
                                   
// 点击多用用再说 其实是 reminderlater
- (void)iRateUserDidDeclineToRateApp
{
    //cancel button did press
    [CustomiRate sharedInstance].declinedThisVersion = NO;
    [CustomiRate sharedInstance].lastReminded = [NSDate date];

}
                                   
- (void)iRateDidPromptForRating
{
    [CustomiRate sharedInstance].eventCount++;
    if ([CustomiRate sharedInstance].eventCount >= 2) {
        [CustomiRate sharedInstance].ratedThisVersion = YES;
    }
}
                               
                                   
#pragma mark - private
- (void)promptForRating{

    if ([[CustomiRate sharedInstance] shouldPromptForRating]) {
        [[CustomiRate sharedInstance] promptForRating];
    }
}
@end
