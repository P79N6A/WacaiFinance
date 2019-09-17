//
//  FSDiscoverFServiceMenuCell.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/10.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSMenuData;
@interface FSDiscoverFServiceMenuCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;


- (void)fillContent:(FSMenuData *)object showBottomline:(BOOL)show;

+ (NSString *)cellIdentifer;



@end
