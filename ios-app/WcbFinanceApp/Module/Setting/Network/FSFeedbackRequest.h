//
//  FSFeedbackRequest.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 08/03/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <i-Finance-Library/FSSDKRequest.h>

@interface FSFeedbackRequest : FSSDKRequest

- (id)initWithContent:(NSString *)content email:(NSString *)email;

@end
