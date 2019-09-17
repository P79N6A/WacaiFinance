//
//  FSDiscoveryTagContainerView.h
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDiscoveryTag.h"

@protocol FSDiscoveryTagContainerViewDelegate <NSObject>

- (void)didSelectedTagAtIndex:(NSUInteger)index;

@end

@interface FSDiscoveryTagContainerView : UIScrollView

@property (nonatomic, weak) id<FSDiscoveryTagContainerViewDelegate> clickDelegate;
@property (nonatomic, assign, readonly) NSUInteger selectedTagIndex;

+ (instancetype)viewWithTags:(NSArray<FSDiscoveryTag *> *)tags;
- (void)setTags:(NSArray<FSDiscoveryTag *> *)tags;

- (void)hideBottomLine;
- (void)showBottomLine;

@end
