//
//  DKCircularSlider.m
//  CircularSlider
//
//  Created by Dennis Kutlubaev on 4/9/13.
//

#import "DKCircularSlider.h"


#define MIN_ANGLE -M_PI/6
#define MAX_ANGLE 7*M_PI/6

// Converts degrees to radians.
#define degreesToRadians(angleDegrees) (angleDegrees * M_PI / 180.0)

// Converts radians to degrees.
#define radiansToDegrees(angleRadians) (angleRadians * 180.0 / M_PI)


@interface DKCircularSlider()

@property (nonatomic, assign) CGFloat knobAngle;

@property (nonatomic, assign) NSInteger maxRadius;

@property (nonatomic, assign) NSInteger barRadius;

@property (nonatomic, assign) CGFloat allowedAngle;

@end


@implementation DKCircularSlider

static CGPoint barCenter, knobCenter;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.value == 0) self.value = floor((self.maxValue + self.minValue) / 2);
    
    // Calclulate initial angle from initial value
    float percentDone = 1 - (self.value - self.minValue) / (self.maxValue - self.minValue);
    self.knobAngle = MIN_ANGLE + (percentDone * (MAX_ANGLE - MIN_ANGLE));
    
    if (! self.disabledColor) self.disabledColor = [UIColor colorWithRed:64.f/255.f green:178.f/255.f blue:226.f/255.f alpha:1.f];
    if (! self.enabledColor) self.enabledColor = [UIColor whiteColor];
}


- (void)drawRect:(CGRect)rect
{
    // Calculating max allowed angle from max allowed value
    NSInteger deltaValue = self.maxValue - self.minValue;
    CGFloat deltaAngle = MAX_ANGLE - MIN_ANGLE;
    CGFloat anglePerValue = deltaAngle / deltaValue;
    self.allowedAngle = MIN_ANGLE + anglePerValue * (self.maxValue - self.maxAllowedValue);
    
    // Bar and Knob coordinates
    barCenter.x = CGRectGetMidX(rect);
    barCenter.y = CGRectGetMidY(rect);
    self.maxRadius = (CGRectGetHeight(rect) <= CGRectGetWidth(rect))?CGRectGetHeight(rect)/2:CGRectGetWidth(rect)/2; //gets the width or height, whichever is smallest, and stores it in radius
    self.barRadius = self.maxRadius * 0.9;
    
    // Polar -> Cartesian coordinates, Center of Knob
    knobCenter.x = barCenter.x + (self.barRadius * cosf(self.knobAngle));
    knobCenter.y = barCenter.y - (self.barRadius * sinf(self.knobAngle));
    
    UIColor *color = self.enabled ? self.enabledColor : self.disabledColor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Slider bar
    
    // Note that start angle in CGContextAddArc is the angle to the starting point of the arc, measured in radians from the positive x-axis.
    
    // Draw bar with disabled color from minValue to maxValue
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.disabledColor.CGColor);
    CGContextAddArc(context, barCenter.x, barCenter.y, self.barRadius, fmodf(MIN_ANGLE + M_PI, 2 * M_PI), fmodf(MAX_ANGLE + M_PI, 2 * M_PI), 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw bar with color (depends on enabled state) from minValue to maxAllowedValue
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextAddArc(context, barCenter.x, barCenter.y, self.barRadius, fmodf(MIN_ANGLE + M_PI, 2 * M_PI), fmodf(2 * M_PI - self.allowedAngle, 2 * M_PI), 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Polar -> Cartesian coordinates
    double phi2 = MIN_ANGLE;
    double phi1 = MAX_ANGLE;
    double phi3 = self.allowedAngle;
    CGPoint P1 = CGPointMake(self.maxRadius + self.barRadius * cos(phi1), self.maxRadius - self.barRadius * sin(phi1));
    CGPoint P2 = CGPointMake(self.maxRadius + self.barRadius * cos(phi2), self.maxRadius - self.barRadius * sin(phi2));
    CGPoint P3 = CGPointMake(self.maxRadius + self.barRadius * cos(phi3), self.maxRadius - self.barRadius * sin(phi3));
    
    // Dots
    CGContextSetLineWidth(context, 5.0);
    CGContextSetFillColorWithColor(context, self.enabledColor.CGColor);
    CGContextAddArc(context, P1.x, P1.y, 5, 0, 2*M_PI, 1);
    CGContextDrawPath(context, kCGPathFill);
    CGContextAddArc(context, P2.x, P2.y, 5, 0, 2*M_PI, 1);
    CGContextDrawPath(context, kCGPathFill);
    CGContextAddArc(context, P3.x, P3.y, 5, 0, 2*M_PI, 1);
    CGContextDrawPath(context, kCGPathFill);
    
    // Labels
    NSString *minValueString = [NSString stringWithFormat:@"%ld", self.minValue];
    NSString *maxValueString = [NSString stringWithFormat:@"%ld", self.maxValue];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : self.enabledColor };
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:minValueString attributes:attributes];
    CGSize size = [minValueString sizeWithAttributes:attributes];
    [attributedString1 drawAtPoint:CGPointMake(P1.x - (size.width / 2.0), P1.y + 20)];
    NSAttributedString *attributedString2 = [[NSAttributedString alloc] initWithString:maxValueString attributes:attributes];
    size = [maxValueString sizeWithAttributes:attributes];
    [attributedString2 drawAtPoint:CGPointMake(P2.x - (size.width / 2.0), P2.y + 20)];
    
    if (self.enabled)
    {
        // Knob
        CGContextSaveGState(context);
        
        CGContextSetLineWidth(context, 1.0);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetShadowWithColor(context, CGSizeMake(0 , 2), 4.0, [UIColor colorWithWhite:0.f alpha:0.5].CGColor);
        CGContextAddArc(context, knobCenter.x, knobCenter.y, self.knobRadius, 0, 2*M_PI, 1);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextRestoreGState(context);
    }
}


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self setNeedsDisplay];
}


- (void)setMaxAllowedValue:(NSInteger)maxAllowedValue
{
    _maxAllowedValue = maxAllowedValue;
    
    if (self.value > self.maxAllowedValue) self.value = self.maxAllowedValue;
    
    [self setNeedsDisplay];
}


- (void)setValue:(NSInteger)value
{
    if (! self.enabled) return;
    
    _value = value;
    
    if (_value < self.minValue) _value = self.minValue;
    if (_value > self.maxAllowedValue && self.maxAllowedValue != 0) _value = self.maxAllowedValue;
    if (_value > self.maxValue && self.maxAllowedValue == 0) _value = self.maxValue;

    CGFloat valueFloat = (CGFloat)_value;
    float percentDone = 1 - (valueFloat - self.minValue) / (self.maxValue - self.minValue);
    self.knobAngle = MIN_ANGLE + (percentDone * (MAX_ANGLE - MIN_ANGLE));
    
    [self setNeedsDisplay];
}


- (void)setKnobAngle:(CGFloat)knobAngle
{
    _knobAngle = knobAngle;
    
    float percentDone = 1 - (_knobAngle - MIN_ANGLE) / (MAX_ANGLE - MIN_ANGLE);

    _value = self.minValue + percentDone * (self.maxValue - self.minValue);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat xDist = touchPoint.x - knobCenter.x;
    CGFloat yDist = touchPoint.y - knobCenter.y;
    if (sqrt((xDist * xDist) + (yDist * yDist)) <= self.knobRadius * 3) // if the touch is within the slider knob
    {
        self.isKnobBeingTouched = self.enabled;
    }
    
    return YES;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (! self.isKnobBeingTouched) return NO;
        
    CGPoint touchPoint = [touch locationInView:self];

    float touchVector[2] = {touchPoint.x-knobCenter.x, touchPoint.y-knobCenter.y}; //gets the vector of the difference between the touch location and the knob center
    float tangentVector[2] = {knobCenter.y-barCenter.y, barCenter.x-knobCenter.x}; //gets a vector tangent to the circle at the center of the knob
    float scalarProj = (touchVector[0]*tangentVector[0] + touchVector[1]*tangentVector[1])/sqrt((tangentVector[0]*tangentVector[0])+(tangentVector[1]*tangentVector[1])); //calculates the scalar projection of the touch vector onto the tangent vector
    self.knobAngle += scalarProj/self.barRadius;
    
    if (self.knobAngle > MAX_ANGLE) //ensure knob is always on the bar
        self.knobAngle = MAX_ANGLE;
    if (self.knobAngle < self.allowedAngle)
        self.knobAngle = self.allowedAngle;
    
    self.knobAngle = fmodf(self.knobAngle, 2*M_PI); //ensures knobAngle is always between 0 and 2*Pi
    
    [self setNeedsDisplay];
    
    return YES;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isKnobBeingTouched = NO;
}



@end
