//
//  FSDiscoveryTagContainerView.m
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryTagContainerView.h"
#import "FSDiscoveryTagButton.h"

@interface FSDiscoveryTagContainerView ()

@property (nonatomic, strong) NSMutableArray<FSDiscoveryTagButton *> *buttonArray;
@property (nonatomic, strong) NSArray<FSDiscoveryTag *> *tags;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation FSDiscoveryTagContainerView

+ (instancetype)viewWithTags:(NSArray<FSDiscoveryTag *> *)tags {
    return [[self alloc] initWithTags:tags];
}

- (instancetype)initWithTags:(NSArray<FSDiscoveryTag *> *)tags {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.tags = tags;
        [self setupUI];
    }
    return self;
}

- (void)setTags:(NSArray<FSDiscoveryTag *> *)tags {
    if (_tags == tags) {
        return;
    } else {
        _tags = tags;
        [self.containerView removeFromSuperview];
        self.containerView = nil;
        self.buttonArray = nil;
        [self setupUI];
    }
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = YES;
    
    self.containerView = ({
        UIView *containerView = [[UIView alloc] init];
        containerView;
    });
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    
    NSUInteger buttonCount = self.tags.count;
    self.buttonArray = [NSMutableArray arrayWithCapacity:buttonCount];
    for (NSUInteger index = 0; index < buttonCount; index++) {
        
        FSDiscoveryTagButton *button = ({
            NSString *buttonTitle = ((FSDiscoveryTag *)[self.tags fs_objectAtIndex:index]).name;
            FSDiscoveryTagButton *button = [FSDiscoveryTagButton buttonWithTitle:buttonTitle];
            button.tag = index;
            [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        if (index == 0) {
            button.selected = YES;
            button.layer.borderColor = [UIColor clearColor].CGColor;
            _selectedTagIndex = 0;
        }
        
        [self.buttonArray addObject:button];
        
        [self.containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            NSUInteger firstButtonIndex = 0;
            NSUInteger lastButtonIndex = buttonCount - 1;
            
            make.height.equalTo(@24);
            make.centerY.equalTo(self.containerView);
            
            if (index == firstButtonIndex) {
                make.left.equalTo(self.containerView).offset(16);
            } else if (index == lastButtonIndex) {
                make.left.equalTo(self.buttonArray[index - 1].mas_right).offset(10);
                make.right.equalTo(self.containerView).offset(-16);
            } else {
                make.left.equalTo(self.buttonArray[index - 1].mas_right).offset(10);
            }
            
        }];
    }
    
    self.bottomLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        view.hidden = YES;
        view;
    });
    [self.containerView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)hideBottomLine {
    self.bottomLine.hidden = YES;
}

- (void)showBottomLine {
    self.bottomLine.hidden = NO;
}

- (void)onButtonClicked:(UIButton *)clickedButton {
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button == clickedButton) {
            button.selected = YES;
            button.layer.borderColor = [UIColor clearColor].CGColor;
            _selectedTagIndex = idx;
        } else {
            button.selected = NO;
            button.layer.borderColor = [UIColor colorWithHexString:@"#FFE4E4E4"].CGColor;
        }
    }];
    [self.clickDelegate didSelectedTagAtIndex:clickedButton.tag];
}



@end
