//
//  FSDiscoveryPostSectionController.m
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryPostSectionController.h"
#import "FSDiscoveryPostCell.h"
#import "FSDiscoveryPost.h"
#import "FSDiscoveryEntity.h"
#import <UIImageView+WebCache.h>
#import "CMSDKManager.h"
#import <Neutron/Neutron.h>
#import "FSDcvrPostViewModel.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>


@interface FSDiscoveryPostSectionController ()

@property (nonatomic, strong) FSDcvrPostViewModel *viewModel;

@end

@implementation FSDiscoveryPostSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 128);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDiscoveryPostCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass
                                            forSectionController:self
                                                         atIndex:index];
    
    FSDiscoveryPost *post = _viewModel.post;
    
    FSDiscoveryPostCell *postCell = (FSDiscoveryPostCell *)cell;
    postCell.titleLabel.text = post.title;
    UIFont *font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    UIColor *textColor = [UIColor colorWithHexString:@"#333333"];
    [postCell.titleLabel setFont:font color:textColor withRange:NSMakeRange(0, post.title.length)];
    [postCell.titleLabel setLineSpacing:1];
    postCell.type = post.isInFirstTag ? post.type : FSDiscoveryPostTypeNone;
    postCell.moduleNameLabel.text = post.isInFirstTag ? post.moduleName : @"";
    postCell.authorNameLabel.text = post.authorName;
    postCell.readCountLabel.text = [NSString stringWithFormat:@"阅读数：%@",post.readCountString];
    UIImage *illustrationPlaceHolder = [UIImage imageNamed:@"discovery_illustration_default"];
    [postCell.illustrationImageView sd_setImageWithURL:[NSURL URLWithString:post.illustrationURL]
                                      placeholderImage:illustrationPlaceHolder];
    return postCell;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(discoveryPostSectionDidClicked)]) {
        [self.delegate discoveryPostSectionDidClicked];
    }
    
    FSDiscoveryPost *post = _viewModel.post;
    
    if ([post.linkURL CM_isValidString]) {
        
//        NSString *event = [NSString stringWithFormat:@"{\"ThreadUrl\":\"%@\",\"ThreadposId\":\"%@\"}", _post.linkURL, @(indexPath.row - 4)];
        NSString *event = [NSString stringWithFormat:@"{\"ThreadUrl\":\"%@\",\"ThreadposId\":\"%@\"}", post.linkURL, @(index)];
         
        NSString *threadurl = post.linkURL? : @"";
        NSString *threadid  = post.postid? : @"";
        NSString *position  = [NSString stringWithFormat:@"%@", @(index)];
        
        NSDictionary *s_attributes = @{@"lc_thread_url": threadurl,
                                   @"lc_thread_id":threadid,
                                   @"lc_thread_position":position};
        
        [UserAction skylineEvent:@"finance_wcb_find_article_click" attributes:s_attributes];
        // 如果使用 FSGotoUtility 打开，遇到 error 页面之后，社区的页面会一直用 FSWebViewController 打开
        NSURL *postURL = [NSURL URLWithString:post.linkURL];
 
        [FSSDKGotoUtility openURL:post.linkURL from:self.viewController];
    }
}

- (void)didUpdateToObject:(id)object
{
    _viewModel = object;
}

@end
