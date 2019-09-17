//
//  FSBaseAnimatedCell.m
//  Financeapp
//
//  Created by xingyong on 06/06/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSBaseAnimatedCell.h"

@interface FSBaseAnimatedCell ()<UIGestureRecognizerDelegate>
@property CGRect fadeAndClippingMaskRect;
@property CGPoint tapPoint;
@property CALayer *backgroundColorFadeLayer;
@property BOOL growthFinished;
@property BOOL touchCancelledOrEnded;
@property NSMutableArray *rippleAnimationQueue;
@property NSMutableArray *deathRowForCircleLayers;  // This is where old circle layers go to be killed :(
@property UIColor *dumbTapCircleFillColor;
@property UIColor *dumbBackgroundFadeColor;
@property (nonatomic, copy) void (^removeEffectsQueue)();
@end

@implementation FSBaseAnimatedCell

CGFloat const T_bfPaperTableViewCell_tapCircleDiameterMedium  = 462.f;
CGFloat const T_bfPaperTableViewCell_tapCircleDiameterLarge   = T_bfPaperTableViewCell_tapCircleDiameterMedium * 1.4f;
CGFloat const T_bfPaperTableViewCell_tapCircleDiameterSmall   = T_bfPaperTableViewCell_tapCircleDiameterMedium / 2.f;
CGFloat const T_bfPaperTableViewCell_tapCircleDiameterFull    = -1.f;
CGFloat const T_bfPaperTableViewCell_tapCircleDiameterDefault = -2.f;



- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
        [self addViewConstraint];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
        [self addViewConstraint];
    }
    return self;
}
- (void)addViewConstraint{
    
}
- (void)setupSubviews{
    
//    //子类实现
 
    // Animation:
    self.touchDownAnimationDuration  = 0.3f;
    self.touchUpAnimationDuration    = self.touchDownAnimationDuration * 2.5f;
    // Prettyness and Behaviour:
    self.usesSmartColor              = YES;
//    self.tapCircleColor              = nil;
//    self.backgroundFadeColor         = nil;
//    self.rippleFromTapLocation       = YES;
    self.tapCircleDiameterStartValue = 5.f;
//    self.tapCircleDiameter           = bfPaperTableViewCell_tapCircleDiameterDefault;
    self.tapCircleBurstAmount        = 100.f;
    self.dumbTapCircleFillColor      = [UIColor colorWithWhite:0.3 alpha:0.25f];
//    self.dumbBackgroundFadeColor     = [UIColor colorWithWhite:0.3 alpha:0.15f];
    self.letBackgroundLinger         = YES;
    self.alwaysCompleteFullAnimation = YES;
//    self.tapDelay                    = 0.1f;
    self.maskPath                    = nil;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    self.rippleAnimationQueue = [NSMutableArray array];
    self.deathRowForCircleLayers = [NSMutableArray array];
    
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    self.fadeAndClippingMaskRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    // Setup background fade layer:
    self.backgroundColorFadeLayer = [[CALayer alloc] init];
    self.backgroundColorFadeLayer.frame = self.fadeAndClippingMaskRect;
    self.backgroundColorFadeLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.backgroundColorFadeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:self.backgroundColorFadeLayer atIndex:0];
    
    
    
    self.usesSmartColor = YES;
    self.tapCircleColor = [UIColor colorWithHex:0xF6F6F6];
//    [UIColor colorWithRed:198.f/255.f green:255.f/255.f blue:0/255.f alpha:0.6];
    self.tapCircleDiameter = T_bfPaperTableViewCell_tapCircleDiameterFull;
    self.rippleFromTapLocation = NO;
    self.backgroundFadeColor = [UIColor colorWithWhite:1 alpha:0.2f];
    self.letBackgroundLinger = YES;
    self.tapDelay = 0.f;
    
    
     
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
}
- (void)setSelected:(BOOL)selected{
        [super setSelected:selected];
        //NSLog(@"setSelected:\'%@\' animated:\'%@\'", selected ? @"YES" : @"NO", animated ? @"YES" : @"NO");
    
        if (!self.letBackgroundLinger) {
            return; // If we are not letting the background linger, just return as we have nothing more to do here.
        }
    
        if (!selected) {
            [self removeBackground];
        }
        else {
            [self fadeBackgroundIn];
        }
}
//-(void)setHighlighted:(BOOL)highlighted{
//    [super setHighlighted:highlighted];
//    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
//    backView.backgroundColor    = highlighted ? [UIColor colorWithRed:249/255. green:249/255. blue:249/255. alpha:1] : [UIColor whiteColor];
//// [UIColor colorWithRed:249/255. green:249/255. blue:249/255. alpha:1];
//    self.selectedBackgroundView = backView;
//    //    self.contentView.backgroundColor = highlighted ? [UIColor colorWithRed:249/255. green:249/255. blue:249/255. alpha:1] : [UIColor whiteColor];
//
//}
#pragma Parent Overides
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    //NSLog(@"setSelected:\'%@\' animated:\'%@\'", selected ? @"YES" : @"NO", animated ? @"YES" : @"NO");
//    
//    if (!self.letBackgroundLinger) {
//        return; // If we are not letting the background linger, just return as we have nothing more to do here.
//    }
//    
//    if (!selected) {
//        [self removeBackground];
//    }
//    else {
//        [self fadeBackgroundIn];
//    }
//}

/*- (void)prepareForReuse
 {
 [super prepareForReuse];
 
 // Lets go ahead and "reset" our cell:
 // In your subclass, this is where you would call your custom setup.
 //    [self setupBFPaperTableViewCell];
 //    [self fadeBGOut];
 }*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.fadeAndClippingMaskRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y , self.bounds.size.width, self.bounds.size.height);
    self.backgroundColorFadeLayer.frame = self.fadeAndClippingMaskRect;
    
    [self setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.touchCancelledOrEnded = NO;
    self.growthFinished = NO;
    
    if (self.tapDelay > 0) {
        // Dispatch on main thread to delay animations
        dispatch_main_after(self.tapDelay, ^{
            if (!self.touchCancelledOrEnded) {
                [self fadeBackgroundIn];
                [self growTapCircle];
            }
            else {
                [self setSelected:NO];
                [self fadeBGOut];
            }
        });
    }
    else {
        // Avoid dispatching if there's no delay
        [self fadeBackgroundIn];
        [self growTapCircle];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.touchCancelledOrEnded = YES;
    
    [self removeCircle];
    if (!self.letBackgroundLinger) {
        [self removeBackground];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.touchCancelledOrEnded = YES;
    
    [self removeCircle];
    [self removeBackground];
}


#pragma mark - Setters and Getters
- (void)setUsesSmartColor:(BOOL)usesSmartColor
{
    _usesSmartColor = usesSmartColor;
    self.tapCircleColor = nil;
    self.backgroundFadeColor = nil;
}

#pragma mark - Gesture Recognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint location = [touch locationInView:self];
    //NSLog(@"location: x = %0.2f, y = %0.2f", location.x, location.y);
    self.tapPoint = location;
    
    return NO;  // Disallow recognition of tap gestures. We just needed this to grab that tasty tap location.
}


#pragma mark - Animation:
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    // NSLog(@"animation ENDED");
    self.growthFinished = YES;
    
    if ([[animation valueForKey:@"id"] isEqualToString:@"fadeCircleOut"]) {
        [[self.deathRowForCircleLayers objectAtIndex:0] removeFromSuperlayer];
        if (self.deathRowForCircleLayers.count > 0) {
            [self.deathRowForCircleLayers removeObjectAtIndex:0];
        }
    }
    
    if (self.alwaysCompleteFullAnimation) {
        if (self.removeEffectsQueue) {
            self.removeEffectsQueue();
            self.removeEffectsQueue = nil;
        }
    }
}

- (void)removeCircle
{
    if (!self.alwaysCompleteFullAnimation) {
        [self burstTapCircle];
    }
    else {
        //////////////////////////////////////////////////////////////////////////////
        // Special thanks to github user @ThePantsThief for providing this code!    //
        //////////////////////////////////////////////////////////////////////////////
        if (self.growthFinished) {
            [self burstTapCircle];
        } else {
            void (^oldCompletion)() = self.removeEffectsQueue;
            __weak typeof(self) weakSelf = self;
            
            self.removeEffectsQueue = ^void() {
                if (oldCompletion)
                    oldCompletion();
                [weakSelf burstTapCircle];
            };
        }
    }
}

- (void)removeBackground
{
    if (!self.alwaysCompleteFullAnimation) {
        [self fadeBGOut];
    }
    else {
        //////////////////////////////////////////////////////////////////////////////
        // Special thanks to github user @ThePantsThief for providing this code!    //
        //////////////////////////////////////////////////////////////////////////////
        if (self.growthFinished) {
            [self fadeBGOut];
        } else {
            void (^oldCompletion)() = self.removeEffectsQueue;
            __weak typeof(self) weakSelf = self;
            self.removeEffectsQueue = ^void() {
                if (oldCompletion)
                    oldCompletion();
                [weakSelf fadeBGOut];
            };
        }
    }
}

- (void)fadeBackgroundIn
{
//    if (!self.backgroundFadeColor) {
//        self.backgroundFadeColor = self.usesSmartColor ? [self.textLabel.textColor colorWithAlphaComponent:CGColorGetAlpha(self.dumbBackgroundFadeColor.CGColor)] : self.dumbBackgroundFadeColor;
//    }
    
    if (nil != self.maskPath) {
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = self.maskPath.CGPath;
        mask.fillColor = [UIColor blackColor].CGColor;
        mask.strokeColor = [UIColor clearColor].CGColor;
        mask.borderColor = [UIColor clearColor].CGColor;
        mask.borderWidth = 0;
        self.backgroundColorFadeLayer.mask = mask;
    }
    
    // Setup background fade layer:
    self.backgroundColorFadeLayer.backgroundColor = self.backgroundFadeColor.CGColor;
    
    CGFloat startingOpacity = self.backgroundColorFadeLayer.opacity;
    
    if ([[self.backgroundColorFadeLayer animationKeys] count] > 0) {
        startingOpacity = [[self.backgroundColorFadeLayer presentationLayer] opacity];
    }
    
    // Fade the background color a bit darker:
    CABasicAnimation *fadeBackgroundDarker = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeBackgroundDarker.duration = self.touchDownAnimationDuration;
    fadeBackgroundDarker.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeBackgroundDarker.fromValue = [NSNumber numberWithFloat:startingOpacity];
    fadeBackgroundDarker.toValue = [NSNumber numberWithFloat:1];
    fadeBackgroundDarker.fillMode = kCAFillModeForwards;
    fadeBackgroundDarker.removedOnCompletion = !NO;
    self.backgroundColorFadeLayer.opacity = 1;
    
    [self.backgroundColorFadeLayer addAnimation:fadeBackgroundDarker forKey:@"animateOpacity"];
}

- (void)growTapCircle
{
    //NSLog(@"expanding a tap circle");
    // Spawn a growing circle that "ripples" through the button:
    
    // Set the fill color for the tap circle (self.animationLayer's fill color):
    if (!self.tapCircleColor) {
//        self.tapCircleColor = self.usesSmartColor ? [self.textLabel.textColor colorWithAlphaComponent:CGColorGetAlpha(self.dumbTapCircleFillColor.CGColor)] : self.dumbTapCircleFillColor;
    }
    
    // Calculate the tap circle's ending diameter:
    CGFloat tapCircleFinalDiameter = [self calculateTapCircleFinalDiameter];
    
    // Create a UIView which we can modify for its frame value later (specifically, the ability to use .center):
    UIView *tapCircleLayerSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleFinalDiameter, tapCircleFinalDiameter)];
    tapCircleLayerSizerView.center = self.rippleFromTapLocation ? self.tapPoint : CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Calculate starting path:
    UIView *startingRectSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tapCircleDiameterStartValue, self.tapCircleDiameterStartValue)];
    startingRectSizerView.center = tapCircleLayerSizerView.center;
    
    // Create starting circle path:
    UIBezierPath *startingCirclePath = [UIBezierPath bezierPathWithRoundedRect:startingRectSizerView.frame cornerRadius:self.tapCircleDiameterStartValue / 2.f];
    
    // Calculate ending path:
    UIView *endingRectSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleFinalDiameter, tapCircleFinalDiameter)];
    endingRectSizerView.center = tapCircleLayerSizerView.center;
    
    // Create ending circle path:
    UIBezierPath *endingCirclePath = [UIBezierPath bezierPathWithRoundedRect:endingRectSizerView.frame cornerRadius:tapCircleFinalDiameter / 2.f];
    
    // Create tap circle:
    CAShapeLayer *tapCircle = [CAShapeLayer layer];
    tapCircle.fillColor = self.tapCircleColor.CGColor;
    tapCircle.strokeColor = [UIColor clearColor].CGColor;
    tapCircle.borderColor = [UIColor clearColor].CGColor;
    tapCircle.borderWidth = 0;
    tapCircle.path = startingCirclePath.CGPath;
    
    // Create a mask if we are not going to ripple over bounds:
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = (nil == self.maskPath) ? [UIBezierPath bezierPathWithRoundedRect:self.fadeAndClippingMaskRect cornerRadius:self.layer.cornerRadius].CGPath : self.maskPath.CGPath;
    mask.fillColor = [UIColor blackColor].CGColor;
    mask.strokeColor = [UIColor clearColor].CGColor;
    mask.borderColor = [UIColor clearColor].CGColor;
    mask.borderWidth = 0;
    
    // Set tap circle layer's mask to the mask:
    tapCircle.mask = mask;
    
    // Add tap circle to array and view:
    [self.rippleAnimationQueue addObject:tapCircle];
    [self.contentView.layer insertSublayer:tapCircle above:self.backgroundColorFadeLayer];
    
    
    // Grow tap-circle animation (performed on mask layer):
    CABasicAnimation *tapCircleGrowthAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    tapCircleGrowthAnimation.delegate = self;
    tapCircleGrowthAnimation.duration = self.touchDownAnimationDuration;
    tapCircleGrowthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    tapCircleGrowthAnimation.fromValue = (__bridge id)startingCirclePath.CGPath;
    tapCircleGrowthAnimation.toValue = (__bridge id)endingCirclePath.CGPath;
    tapCircleGrowthAnimation.fillMode = kCAFillModeForwards;
    tapCircleGrowthAnimation.removedOnCompletion = NO;
    
    // Fade in self.animationLayer:
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = self.touchDownAnimationDuration;
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.fillMode = kCAFillModeForwards;
    fadeIn.removedOnCompletion = NO;
    
    // Add the animations to the layers:
    [tapCircle addAnimation:tapCircleGrowthAnimation forKey:@"animatePath"];
    [tapCircle addAnimation:fadeIn forKey:@"opacityAnimation"];
}

- (void)fadeBGOut
{
    //NSLog(@"fading bg");
    
    CGFloat startingOpacity = self.backgroundColorFadeLayer.opacity;
    
    // Grab the current value if we are currently animating:
    if ([[self.backgroundColorFadeLayer animationKeys] count] > 0) {
        startingOpacity = [[self.backgroundColorFadeLayer presentationLayer] opacity];
    }
    
    CABasicAnimation *removeFadeBackgroundDarker = [CABasicAnimation animationWithKeyPath:@"opacity"];
    removeFadeBackgroundDarker.duration = self.touchUpAnimationDuration;
    removeFadeBackgroundDarker.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    removeFadeBackgroundDarker.fromValue = [NSNumber numberWithFloat:startingOpacity];
    removeFadeBackgroundDarker.toValue = [NSNumber numberWithFloat:0];
    removeFadeBackgroundDarker.fillMode = kCAFillModeForwards;
    removeFadeBackgroundDarker.removedOnCompletion = !NO;
    self.backgroundColorFadeLayer.opacity = 0;
    
    [self.backgroundColorFadeLayer addAnimation:removeFadeBackgroundDarker forKey:@"animateOpacity"];
}

- (void)burstTapCircle
{
    //NSLog(@"expanding a bit more");
    
    if (1 > self.rippleAnimationQueue.count) {
        return; // We don't have any circles to burst, we can just leave and ponder how and why we got here in this state.
    }
    
    // Get the next tap circle to expand:
    CAShapeLayer *tapCircle = [self.rippleAnimationQueue firstObject];
    if (self.rippleAnimationQueue.count > 0) {
        [self.rippleAnimationQueue removeObjectAtIndex:0];
    }
    [self.deathRowForCircleLayers addObject:tapCircle];
    
    
    // Calculate the tap circle's ending diameter:
    CGFloat tapCircleFinalDiameter = [self calculateTapCircleFinalDiameter];
    tapCircleFinalDiameter += self.tapCircleBurstAmount;
    
    UIView *endingRectSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleFinalDiameter, tapCircleFinalDiameter)];
    endingRectSizerView.center = self.rippleFromTapLocation ? self.tapPoint : CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Create ending circle path for mask:
    UIBezierPath *endingCirclePath = [UIBezierPath bezierPathWithRoundedRect:endingRectSizerView.frame cornerRadius:tapCircleFinalDiameter / 2.f];
    
    
    CGPathRef startingPath = tapCircle.path;
    CGFloat startingOpacity = tapCircle.opacity;
    
    if ([[tapCircle animationKeys] count] > 0) {
        startingPath = [[tapCircle presentationLayer] path];
        startingOpacity = [[tapCircle presentationLayer] opacity];
    }
    
    // Burst tap-circle:
    CABasicAnimation *tapCircleGrowthAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    tapCircleGrowthAnimation.duration = self.touchUpAnimationDuration;
    tapCircleGrowthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    tapCircleGrowthAnimation.fromValue = (__bridge id)startingPath;
    tapCircleGrowthAnimation.toValue = (__bridge id)endingCirclePath.CGPath;
    tapCircleGrowthAnimation.fillMode = kCAFillModeForwards;
    tapCircleGrowthAnimation.removedOnCompletion = NO;
    
    // Fade tap-circle out:
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOut setValue:@"fadeCircleOut" forKey:@"id"];
    fadeOut.delegate = self;
    fadeOut.fromValue = [NSNumber numberWithFloat:startingOpacity];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.duration = self.touchUpAnimationDuration;
    fadeOut.fillMode = kCAFillModeForwards;
    fadeOut.removedOnCompletion = NO;
    
    [tapCircle addAnimation:tapCircleGrowthAnimation forKey:@"animatePath"];
    [tapCircle addAnimation:fadeOut forKey:@"opacityAnimation"];
}
//- (void)animationDidStart:(CAAnimation *)anim;
//
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
- (CGFloat)calculateTapCircleFinalDiameter
{
    CGFloat finalDiameter = self.tapCircleDiameter;
    if (self.tapCircleDiameter == T_bfPaperTableViewCell_tapCircleDiameterFull) {
        // Calulate a diameter that will always cover the entire button:
        //////////////////////////////////////////////////////////////////////////////
        // Special thanks to github user @ThePantsThief for providing this code!    //
        //////////////////////////////////////////////////////////////////////////////
        CGFloat centerWidth   = self.frame.size.width;
        CGFloat centerHeight  = self.frame.size.height;
        CGFloat tapWidth      = 2 * MAX(self.tapPoint.x, centerWidth - self.tapPoint.x);
        CGFloat tapHeight     = 2 * MAX(self.tapPoint.y, centerHeight - self.tapPoint.y);
        CGFloat desiredWidth  = self.rippleFromTapLocation ? tapWidth : centerWidth;
        CGFloat desiredHeight = self.rippleFromTapLocation ? tapHeight : centerHeight;
        CGFloat diameter      = sqrt(pow(desiredWidth, 2) + pow(desiredHeight, 2));
        finalDiameter = diameter;
    }
    else if (self.tapCircleDiameter < T_bfPaperTableViewCell_tapCircleDiameterFull) {    // default
        finalDiameter = MAX(self.frame.size.width, self.frame.size.height);
    }
    return finalDiameter;
}


#pragma mark - Helpers
static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}
#pragma mark -



@end
