//
//  FSDiscoveryRefreshHeader.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryRefreshHeader.h"
#import "NSMutableArray+FSUtils.h"
#import "UIImage+FSUtils.h"

@interface FSDiscoveryRefreshHeader()
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

//@property (strong,nonatomic ) UIImageView         *arrowView;
@property (strong,nonatomic ) UIImageView         *gifView;

@end


@implementation FSDiscoveryRefreshHeader

- (void)prepare
{
    [super prepare];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger index = 0; index < 18; index ++) {
        NSString *imageName = [NSString stringWithFormat:@"pull_%ld",(long)index + 1];
        
        [imageArray fs_addObject:[UIImage fs_imageBundleNamed:imageName]];
    }
    
    [self setImages:imageArray forState:MJRefreshStateRefreshing];
}
#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:0.7 forState:state];
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    
    self.gifView.frame = CGRectMake(0., 26., self.bounds.size.width, 28.);
    self.gifView.contentMode         = UIViewContentModeCenter;
    
    self.lastUpdatedTimeLabel.textColor = [UIColor darkGrayColor];
    self.lastUpdatedTimeLabel.font      = [UIFont systemFontOfSize:11];
    self.lastUpdatedTimeLabel.frame     = CGRectMake(0, 35, self.bounds.size.width, 20.);
    self.lastUpdatedTimeLabel.alpha     = 1.0;
    // 状态标签
    self.stateLabel.frame            = CGRectMake(0, 18, self.bounds.size.width, 20.);
    self.stateLabel.textColor        = [UIColor darkGrayColor];
    self.stateLabel.alpha            = 1.0;
    self.stateLabel.font             = [UIFont systemFontOfSize:13];
    
}
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateIdle) {
        
        self.lastUpdatedTimeLabel.alpha = 0.5;
        self.stateLabel.alpha        = 0.5;
        self.lastUpdatedTimeLabel.hidden = NO;
        self.stateLabel.hidden        = NO;
        
        
        [self.gifView stopAnimating];
        
        if (oldState == MJRefreshStateRefreshing) {
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.gifView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.gifView.alpha = 1.0;
                
                [self.gifView stopAnimating];
                
            }];
        } else {
            [self.gifView stopAnimating];
            
            
        }
    } else if (state == MJRefreshStatePulling) {
        [UIView animateWithDuration:0.4 animations:^{
            self.lastUpdatedTimeLabel.alpha = 1;
            self.stateLabel.alpha        = 1;
        }];
        [self.gifView stopAnimating];
        
        
    }else if (state == MJRefreshStateWillRefresh){
        
    }
    else if (state == MJRefreshStateRefreshing) {
        
        self.gifView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
            
            
            self.lastUpdatedTimeLabel.alpha = 0;
            self.stateLabel.alpha        = 0;
            
            self.lastUpdatedTimeLabel.hidden = YES;
            self.stateLabel.hidden        = YES;
            
        }
        
    }
    
}


#pragma mark key的处理
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"上次更新时间：%@", time];
    } else {
        self.lastUpdatedTimeLabel.text = @"最后更新：无记录";
    }
}

- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}


- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
