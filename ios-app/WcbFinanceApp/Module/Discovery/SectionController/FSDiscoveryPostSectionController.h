//
//  FSDiscoveryPostSectionController.h
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <IGListKit/IGListKit.h>

@protocol FSDiscoveryPostSectionDelegate <NSObject>
@optional
- (void)discoveryPostSectionDidClicked;
@end

@interface FSDiscoveryPostSectionController : IGListSectionController

@property (nonatomic, weak) id<FSDiscoveryPostSectionDelegate> delegate;

@end
