//
//  FSAssetViewController+NotificationReminder.m
//  FinanceApp
//
//  Created by 叶帆 on 15/05/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSAssetViewController+NotificationReminder.h"

static NSString *const countOfPoppedKey = @"countOfNotificationReminderHasPopped";
static NSString *const lastPoppedKey = @"lastPoppedNotificationReminderDate";

@implementation FSAssetViewController (NotificationReminder)

- (void)popNotificationReminderIfNeeded {
    if ([self shouldShowNotificationReminder]) {
        [self popNotificationReminder];
    }
}

- (BOOL)shouldShowNotificationReminder {
    
    NSDictionary *params = @{@"lc_enable": [self isNotificationAllowed] ? @"true" : @"false"};
    [UserAction skylineEvent:@"finance_wcb_notify_enable" attributes:params];
    
    if ([self isNotificationAllowed]) {
        return NO;
    } else {
        if ([[NSCalendar currentCalendar] isDateInToday:[self firstDateOfNotificationUnavailableRecorded]]) {
            return NO;
        } else {
            NSUInteger poppoedCount = [self countOfNotificationReminderHasPopped];
            if (poppoedCount == 0) {
                //通知提醒弹窗出现过的次数为0，距离首次检测到未开启弹窗日期是否>=3天进行第1次弹窗提醒
                return [self hasFirstDateOfNotificationUnavailableReachedNDaysLater:3];
            } else if (poppoedCount == 1) {
                //通知提醒弹窗出现过的次数为1，距离距离上次弹窗日期是否>=11天进行第2次弹窗提醒
                return [self hasLastPoppedDateReachedNDaysLater:11];
            } else {
                //通知提醒弹窗出现过的次数为2，距离距离上次弹窗日期是否>=31天进行第3+次弹窗提醒
                return [self hasLastPoppedDateReachedNDaysLater:31];
            }
        }
    }
}

- (void)popNotificationReminder {
    UIAlertController *notificationReminderAlert = [UIAlertController alertControllerWithTitle:@"听说财主您关闭了通知，这样一不小心就会错过几个亿的！"
                                                                                       message:@"强烈推荐打开消息提醒\n“设置——通知——挖财宝”开启"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [notificationReminderAlert addAction:dismissAction];
    
    UIAlertAction *gotoSettingsAction = [UIAlertAction actionWithTitle:@"现在去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoSettings];//跳转到系统内App的设置界面
    }];
    [notificationReminderAlert addAction:gotoSettingsAction];
    [self presentViewController:notificationReminderAlert animated:YES completion:^{
        [self addCountOfNotificationReminderHasPopped];
        [self recordTodayAslastPoppedNotificationReminderDate];
    }];
}


- (void)gotoSettings {
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
}

- (BOOL)isNotificationAllowed {
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return notificationSettings.types != UIUserNotificationTypeNone;
}

- (NSDate *)firstDateOfNotificationUnavailableRecorded {
    //获取首次检测到未开启通知的日期
    static NSString *const firstDateKey = @"firstDateOfNotificationUnavailableRecorded";
    NSDate *firstDate = [[NSUserDefaults standardUserDefaults] objectForKey:firstDateKey];
    if (!firstDate) {
        //若本地不存在该值，即为今天，记录到本地
        firstDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:firstDate forKey:firstDateKey];
    }
    return firstDate;
}

- (NSUInteger)countOfNotificationReminderHasPopped {
    //获取开启通知弹窗曾出现过的次数
    NSNumber *countNumber = [[NSUserDefaults standardUserDefaults] objectForKey:countOfPoppedKey];
    if (!countNumber) {
        //若本地不存在该值，即为0，记录到本地
        countNumber = [NSNumber numberWithUnsignedInteger:0];
        [[NSUserDefaults standardUserDefaults] setObject:countNumber forKey:countOfPoppedKey];
    }
    return countNumber.unsignedIntegerValue;
}

- (void)addCountOfNotificationReminderHasPopped {
    //弹窗次数本地记录+1
    NSUInteger originCount = [self countOfNotificationReminderHasPopped];
    NSNumber *latestCount = [NSNumber numberWithUnsignedInteger:(originCount + 1)];
    [[NSUserDefaults standardUserDefaults] setObject:latestCount forKey:countOfPoppedKey];
}

- (void)recordTodayAslastPoppedNotificationReminderDate {
    //本地记录今天为最近一次开启通知弹窗日期
    NSDate *todayDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:todayDate forKey:lastPoppedKey];
}

- (NSDate *)lastPoppedNotificationReminderDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:lastPoppedKey];
}

- (BOOL)hasReachedNDaysLater:(NSUInteger)nDays since:(NSDate *)sinceDate {
    NSTimeInterval interval = nDays * 24 * 60 * 60;
    NSDate *targetDate = [sinceDate dateByAddingTimeInterval:interval];
    NSDate *todayDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSComparisonResult compareResult = [calendar compareDate:targetDate toDate:todayDate toUnitGranularity:NSCalendarUnitDay];
    return compareResult != NSOrderedDescending;
}

- (BOOL)hasFirstDateOfNotificationUnavailableReachedNDaysLater:(NSUInteger)nDays {
    return [self hasReachedNDaysLater:nDays since:[self firstDateOfNotificationUnavailableRecorded]];
}

- (BOOL)hasLastPoppedDateReachedNDaysLater:(NSUInteger)NDays {
    return [self hasReachedNDaysLater:NDays since:[self lastPoppedNotificationReminderDate]];
}

@end
