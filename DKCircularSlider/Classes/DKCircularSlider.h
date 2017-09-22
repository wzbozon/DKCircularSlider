//
//  DKCircularSlider.h
//  CircularSlider
//
//  Created by Dennis Kutlubaev on 4/9/13.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface DKCircularSlider : UIControl

/**
 The maximum value of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger maxValue;

/**
 The minimum value of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger minValue;

/**
 The maximum allowed value of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger maxAllowedValue;

/**
 Current value of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger value;

/**
 Knob radius of the slider.
 */
@property (nonatomic, assign) IBInspectable NSInteger knobRadius;

/**
 Bar color for enabled state.
 */
@property (nonatomic, strong) IBInspectable UIColor *enabledColor;

/**
 Bar color for disabled state.
 */
@property (nonatomic, strong) IBInspectable UIColor *disabledColor;

/**
 Knob is being touched. We filter touches.
 */
@property (nonatomic, assign) BOOL isKnobBeingTouched;

@end
