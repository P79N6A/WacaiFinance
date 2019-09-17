//
//  FSWelcomeSlidesView.m
//  FinanceApp
//
//  Created by 叶帆 on 17/10/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSWelcomeSlidesView.h"




@interface FSWelcomeSlidesView ()<UIScrollViewDelegate>

@property (strong, nonatomic)UIPageControl *pageControl;
@property (strong, nonatomic)UIButton *skipButton;
@property (nonatomic)NSUInteger numberOfSlides;
@property (nonatomic, copy)FSWelcomeSlidesViewDismissBlock dismissBlock;

@end

@implementation FSWelcomeSlidesView
+ (instancetype)viewWithSlidesNumber:(NSInteger)numberOfSlides dismissBlock:(FSWelcomeSlidesViewDismissBlock)dismissBlock {
    return [[FSWelcomeSlidesView alloc] initWithSlidesNumber:numberOfSlides dismissBlock:dismissBlock];
}

- (instancetype)init {
    return [self initWithSlidesNumber:0 dismissBlock:nil];
}

//Designated initializer
- (instancetype)initWithSlidesNumber:(NSInteger)numberOfSlides dismissBlock:(FSWelcomeSlidesViewDismissBlock)dismissBlock {
    self = [super init];
    if (self) {
        if (numberOfSlides == 0) {
            return self;
        }
        
        //Config
        _numberOfSlides = numberOfSlides;
        _dismissBlock = dismissBlock;
        
        //ScrollView
        UIScrollView *scrollView = ({
            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectZero];
            sv.pagingEnabled = YES;
            sv.bounces = NO;
            sv.bouncesZoom = NO;
            sv.showsVerticalScrollIndicator = NO;
            sv.showsHorizontalScrollIndicator = NO;
            sv.delegate = self;
            sv;
        });
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        
        //PageControl
        self.pageControl = ({
            UIPageControl *pc = [UIPageControl new];
            pc.hidden = YES;
            pc.numberOfPages = self.numberOfSlides;
            pc.pageIndicatorTintColor = HEXCOLOR(0xf1d2c9);
            pc.currentPageIndicatorTintColor = HEXCOLOR(0xf2c4b7);
            pc;
        });
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(scrollView.mas_centerX);
            make.bottom.equalTo(scrollView.mas_bottom);
        }];
        
        
        //SkipButton
        self.skipButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self addSubview:self.skipButton];
        [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@42);
            make.height.equalTo(@24);
            make.top.mas_equalTo(FS_StatusBarHeight);
            make.right.equalTo(self).offset(-12);
        }];
        
        
        //ContainerView
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [scrollView addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.height.equalTo(scrollView);
        }];
        
        
        //SlideImageViews
        NSMutableArray *imageViewsArray = [NSMutableArray arrayWithCapacity:self.numberOfSlides];
        for (int i = 0; i < self.numberOfSlides; i++) {
            
            NSString *imageName = [NSString stringWithFormat:@"WelcomeSlide%@.png", @(i)];
            NSString *imageName_iphoneX = [NSString stringWithFormat:@"WelcomeSlide%@_iPhoneX.png", @(i)];
            
            UIImage *image = nil;
 
            if(FS_iPhoneX){
                image =  [UIImage imageNamed:imageName_iphoneX];
            }else{
                image =  [UIImage imageNamed:imageName];
            }
            
            
            UIImageView *imageView = ({
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
                iv.image = image;
                if(!FS_iPhoneX){
                  iv.contentMode = UIViewContentModeScaleAspectFill;
                }

                iv.clipsToBounds = YES;
                iv;
            });
            [imageViewsArray addObject:imageView];
            [containerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.width.equalTo(scrollView.mas_width);
                if (i == 0) {
                    make.left.mas_equalTo(containerView.mas_left);
                } else  {
                    UIImageView *leftImageView = imageViewsArray[i-1];
                    make.left.mas_equalTo(leftImageView.mas_right);
                }
            }];
        }
        
        //EnterButton
        UIButton *enterButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"enterNowButton"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"enterNowButton_pressed"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        UIImageView *lastImageView = imageViewsArray[self.numberOfSlides - 1];
        lastImageView.userInteractionEnabled = YES;
        [lastImageView addSubview:enterButton];
        
        [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(lastImageView);
            make.bottom.equalTo(lastImageView).offset(FS_iPhoneX ? -45. - 34. : -45.);
            
            make.size.mas_equalTo(CGSizeMake(172, 43));

        }];
        
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastImageView.mas_right);
        }];
        
    }
    return self;
}

- (void)dismiss {
    self.dismissBlock();
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
    if (page == self.numberOfSlides - 1) {
        self.skipButton.hidden = YES;
    } else {
        self.skipButton.hidden = NO;
    }
}

@end
