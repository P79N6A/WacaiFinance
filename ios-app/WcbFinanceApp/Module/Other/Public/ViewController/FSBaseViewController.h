//
//  FSBaseViewController.h
//  XYSegmentViewController
//
//  Created by xingyong on 9/16/15.
//  Copyright (c) 2015 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, FSNavgationViewStyle) {
    FSNavgationViewStyleDarkRed,// 深红样式
    FSNavgationViewStyleWhite// 白色样式
};
@interface FSBaseViewController : UIViewController

/**
 *  头部视图
 */
@property (nonatomic,strong) UIView     *navgationView;
@property (nonatomic,strong) UILabel    *titleLabel;
@property (nonatomic,strong) UIButton   *backButton;
@property (nonatomic,strong) UIButton   *rightButton;
@property(nonatomic, strong) UIView     *baseLineView;

- (void)onBackAction:(id)sender;
- (void)onRightAction:(id)sender;


/**
 *  导航栏样式 子类可以重写该方法来定义样式
 *
 *  @return 导航栏样式
 */
- (FSNavgationViewStyle)navgationStyle;

/**
 *  设置右侧按钮背景
 *
 */
- (void)setupRightButtonImage:(NSString *)imageName;

/**
 *  设置带标题的右侧按钮
 */
- (void)setupRightButtonTitle:(NSString *)title;

@end

 
