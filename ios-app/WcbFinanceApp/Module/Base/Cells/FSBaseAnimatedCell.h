//
//  FSBaseAnimatedCell.h
//  Financeapp
//
//  Created by xingyong on 06/06/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

// Nice circle diameter constants:
extern const CGFloat T_bfPaperTableViewCell_tapCircleDiameterMedium;
extern const CGFloat T_bfPaperTableViewCell_tapCircleDiameterLarge;
extern const CGFloat T_bfPaperTableViewCell_tapCircleDiameterSmall;
extern const CGFloat T_bfPaperTableViewCell_tapCircleDiameterFull;
extern const CGFloat T_bfPaperTableViewCell_tapCircleDiameterDefault;

IB_DESIGNABLE
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
// CAAnimationDelegate is not available before iOS 10 SDK
@interface FSBaseAnimatedCell : UICollectionViewCell
#else
@interface FSBaseAnimatedCell : UICollectionViewCell <CAAnimationDelegate>
#endif

- (void)setupSubviews;
- (void)addViewConstraint;



#pragma mark - Properties
#pragma mark Animation
/** A CGFLoat representing the duration of the animations which take place on touch DOWN! Default is 0.25f seconds. (Go Steelers) */
@property IBInspectable CGFloat touchDownAnimationDuration;
/** A CGFLoat representing the duration of the animations which take place on touch UP! Default is 2 * touchDownAnimationDuration seconds. */
@property IBInspectable CGFloat touchUpAnimationDuration;


#pragma mark Prettyness and Behaviour
/** A flag to set YES to use Smart Color, or NO to use a custom color scheme. While Smart Color is recommended, customization is cool too. */
@property (nonatomic) IBInspectable BOOL usesSmartColor;

/** A CGFLoat representing the diameter of the tap-circle as soon as it spawns, before it grows. Default is 5.f. */
@property IBInspectable CGFloat tapCircleDiameterStartValue;

/** The CGFloat value representing the Diameter of the tap-circle. By default it will be the result of MAX(self.frame.width, self.frame.height). tapCircleDiameterFull will calculate a circle that always fills the entire view. Any value less than or equal to tapCircleDiameterFull will result in default being used. The constants: tapCircleDiameterLarge, tapCircleDiameterMedium, and tapCircleDiameterSmall are also available for use. */
@property IBInspectable CGFloat tapCircleDiameter;

/** The CGFloat value representing how much we should increase the diameter of the tap-circle by when we burst it. Default is 100.f. */
@property IBInspectable CGFloat tapCircleBurstAmount;

/** The UIColor to use for the circle which appears where you tap. NOTE: Setting this defeats the "Smart Color" ability of the tap circle. Alpha values less than 1 are recommended. */
@property IBInspectable UIColor *tapCircleColor;

/** The UIColor to fade clear backgrounds to. NOTE: Setting this defeats the "Smart Color" ability of the background fade. Alpha values less than 1 are recommended. */
@property IBInspectable UIColor *backgroundFadeColor;

/** A flag to set to YES to have the tap-circle ripple from point of touch. If this is set to NO, the tap-circle will always ripple from the center of the tab. Default is YES. */
@property (nonatomic) IBInspectable BOOL rippleFromTapLocation;

/** A BOOL flag that determines whether or not to keep the background around after a tap, essentially "highlighting/selecting" the cell. Note that this does not trigger setSelected:! It is purely aesthetic. Also this kinda clashes with cell.selectionStyle, so by defualt the constructor sets that to UITableViewCellSelectionStyleNone.
 Default is YES. */
@property IBInspectable BOOL letBackgroundLinger;

/** A BOOL flag indicating whether or not to always complete a full animation cycle (bg fade in, tap-circle grow and burst, bg fade out) before starting another one. NO will behave just like the other BFPaper controls, tapping rapidly spawns many circles which all fade out in turn. Default is YES. */
@property IBInspectable BOOL alwaysCompleteFullAnimation;

/** A CGFLoat to set the amount of time in seconds to delay the tap event / trigger to spawn circles. For example, if the tapDelay is set to 1.f, you need to press and hold the cell for 1.f seconds to trigger spawning a circle. Default is 0.1f. */
@property IBInspectable CGFloat tapDelay;

/** A UIBezierPath you can set to override the mask path of the ripples and background fade. Set this if you have a custom path for your cell. If this is nil, BFPaperTableViewCell will try its best to provide a correct mask. Default is nil. */
@property IBInspectable UIBezierPath *maskPath;

@end
