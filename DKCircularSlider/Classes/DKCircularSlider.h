//
//  DKCircularSlider.h
//  CircularSlider
//
//  Created by Dennis Kutlubaev on 4/9/13.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface DKCircularSlider : UIView

/**
 The maximum value of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger maxValue;

/**
 The minimum value of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger minValue;

/**
 Current value of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger value;

/**
 Knob radius of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger knobRadius;

@property (nonatomic, assign) BOOL isKnobBeingTouched;

@property (nonatomic, assign) BOOL disabled;

@end
